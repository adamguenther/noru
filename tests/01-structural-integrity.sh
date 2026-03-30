#!/usr/bin/env bash
# Category 1: Structural Integrity
# Validates cross-references, schemas, and completeness across the framework.

set -euo pipefail
source "$(dirname "$0")/helpers.sh"

# ── Test: Every track step resolves to an existing step file ──

category "Track → Step references"

while IFS= read -r track_file; do
  track_name=$(yq -r '.name' "$track_file")
  while IFS= read -r step_name; do
    if [ -f "$STEPS_DIR/${step_name}.md" ]; then
      pass "$track_name → $step_name"
    else
      fail "$track_name → $step_name" "steps/${step_name}.md not found"
    fi
  done < <(yq -r '.legs[].step' "$track_file")
done < <(track_files)

# ── Test: Every agent referenced by a step exists ──

category "Step → Agent references"

while IFS= read -r step_file; do
  step_name=$(basename "$step_file" .md)
  agent=$(frontmatter_field "$step_file" "agent")
  if [ -z "$agent" ]; then
    continue  # no agent required
  fi
  if [ -f "$AGENTS_DIR/${agent}.md" ]; then
    pass "$step_name → $agent"
  else
    fail "$step_name → $agent" "agents/${agent}.md not found"
  fi
done < <(step_files)

# ── Test: Track leg counts match track-compositions.md ──

category "Track leg counts vs track-compositions.md"

while IFS= read -r track_file; do
  track_name=$(yq -r '.name' "$track_file")
  display_name=$(yq -r '.display_name' "$track_file")
  actual_count=$(yq -r '.legs | length' "$track_file")

  # Extract expected count from the compositions reference
  # Format: "| Track | Legs | Execution Mode |"
  expected_count=$(grep -i "| ${display_name} " "$REFERENCES_DIR/track-compositions.md" \
    | head -1 | awk -F'|' '{print $3}' | tr -d ' ')

  if [ -z "$expected_count" ]; then
    fail "$track_name leg count" "not found in track-compositions.md"
  elif [ "$actual_count" = "$expected_count" ]; then
    pass "$track_name: $actual_count legs"
  else
    fail "$track_name leg count" "YAML has $actual_count, compositions says $expected_count"
  fi
done < <(track_files)

# ── Test: Step frontmatter completeness ──

category "Step frontmatter fields"

REQUIRED_STEP_FIELDS=("name" "display_name" "execution_mode" "description")

while IFS= read -r step_file; do
  step_name=$(basename "$step_file" .md)
  missing=()
  for field in "${REQUIRED_STEP_FIELDS[@]}"; do
    value=$(frontmatter_field "$step_file" "$field")
    if [ -z "$value" ]; then
      missing+=("$field")
    fi
  done
  if [ ${#missing[@]} -eq 0 ]; then
    pass "$step_name: all required fields present"
  else
    fail "$step_name: missing fields" "${missing[*]}"
  fi
done < <(step_files)

# ── Test: Track YAML required fields ──

category "Track YAML structure"

REQUIRED_TRACK_FIELDS=("name" "display_name" "description" "signal_words" "legs" "execution_mode" "promotion_triggers")

while IFS= read -r track_file; do
  track_name=$(yq -r '.name' "$track_file")
  missing=()
  for field in "${REQUIRED_TRACK_FIELDS[@]}"; do
    value=$(yq -r ".$field // \"\"" "$track_file")
    if [ -z "$value" ] || [ "$value" = "null" ]; then
      missing+=("$field")
    fi
  done
  if [ ${#missing[@]} -eq 0 ]; then
    pass "$track_name: all required fields present"
  else
    fail "$track_name: missing fields" "${missing[*]}"
  fi
done < <(track_files)

# ── Test: No orphan steps ──

category "Orphan detection — steps"

# Collect all steps referenced by tracks
referenced_steps=()
while IFS= read -r track_file; do
  while IFS= read -r step_name; do
    referenced_steps+=("$step_name")
  done < <(yq -r '.legs[].step' "$track_file")
done < <(track_files)

while IFS= read -r step_file; do
  step_name=$(basename "$step_file" .md)
  found=false
  for ref in "${referenced_steps[@]}"; do
    if [ "$ref" = "$step_name" ]; then
      found=true
      break
    fi
  done
  if $found; then
    pass "$step_name: referenced by a track"
  else
    fail "$step_name: orphan step" "not referenced by any track"
  fi
done < <(step_files)

# ── Test: No orphan agents ──

category "Orphan detection — agents"

# Collect all agents referenced by steps
referenced_agents=()
while IFS= read -r step_file; do
  agent=$(frontmatter_field "$step_file" "agent")
  [ -n "$agent" ] && referenced_agents+=("$agent")
done < <(step_files)

while IFS= read -r agent_file; do
  agent_name=$(basename "$agent_file" .md)
  found=false
  for ref in "${referenced_agents[@]}"; do
    if [ "$ref" = "$agent_name" ]; then
      found=true
      break
    fi
  done
  if $found; then
    pass "$agent_name: referenced by a step"
  else
    fail "$agent_name: orphan agent" "not referenced by any step"
  fi
done < <(agent_files)

# ── Test: Command-track alignment ──

category "Command → Track alignment"

# Direct track commands should reference valid track names
TRACK_COMMANDS=("fix:bug-fix" "feature:feature" "change:change" "quick:quick-task" "troubleshoot:troubleshoot" "explore:exploration" "new:new-project")

for mapping in "${TRACK_COMMANDS[@]}"; do
  cmd_name="${mapping%%:*}"
  expected_track="${mapping##*:}"
  cmd_file="$COMMANDS_DIR/${cmd_name}.md"
  if [ ! -f "$cmd_file" ]; then
    fail "command $cmd_name" "commands/noru/${cmd_name}.md not found"
    continue
  fi
  if [ ! -f "$TRACKS_DIR/${expected_track}.yaml" ]; then
    fail "command $cmd_name → $expected_track" "tracks/${expected_track}.yaml not found"
  else
    pass "$cmd_name → $expected_track"
  fi
done

# ── Test: State template matches schema defaults ──

category "State template vs schema"

template_file="$TEMPLATES_DIR/state.yaml"
if [ -f "$template_file" ]; then
  # Template should have version: 1
  version=$(yq -r '.version' "$template_file")
  if [ "$version" = "1" ]; then
    pass "state template: version is 1"
  else
    fail "state template: version" "expected 1, got $version"
  fi

  # Template should have null/empty track (reset state)
  track=$(yq -r '.track' "$template_file")
  if [ "$track" = "null" ]; then
    pass "state template: track is null (reset state)"
  else
    fail "state template: track" "expected null, got $track"
  fi
else
  fail "state template" "templates/state.yaml not found"
fi

# ── Test: Each track leg has required sub-fields ──

category "Track leg structure"

while IFS= read -r track_file; do
  track_name=$(yq -r '.name' "$track_file")
  leg_count=$(yq -r '.legs | length' "$track_file")
  all_valid=true
  issues=""
  for i in $(seq 0 $((leg_count - 1))); do
    leg_id=$(yq -r ".legs[$i].id // \"\"" "$track_file")
    leg_step=$(yq -r ".legs[$i].step // \"\"" "$track_file")
    leg_display=$(yq -r ".legs[$i].display_name // \"\"" "$track_file")
    if [ -z "$leg_id" ] || [ "$leg_id" = "null" ]; then
      all_valid=false; issues="$issues leg[$i] missing id;"
    fi
    if [ -z "$leg_step" ] || [ "$leg_step" = "null" ]; then
      all_valid=false; issues="$issues leg[$i] missing step;"
    fi
    if [ -z "$leg_display" ] || [ "$leg_display" = "null" ]; then
      all_valid=false; issues="$issues leg[$i] missing display_name;"
    fi
  done
  if $all_valid; then
    pass "$track_name: all legs have id, step, display_name"
  else
    fail "$track_name: leg structure" "$issues"
  fi
done < <(track_files)

summary
