#!/usr/bin/env bash
# Category 4: Promotion Integrity
# Validates promotion targets, carry-forward rules, and skip-leg documentation.

set -euo pipefail
source "$(dirname "$0")/helpers.sh"

# ── Test: All promotion targets reference valid tracks ──

category "Promotion target validity"

while IFS= read -r track_file; do
  track_name=$(yq -r '.name' "$track_file")
  trigger_count=$(yq -r '.promotion_triggers | length' "$track_file")

  if [ "$trigger_count" -eq 0 ]; then
    pass "$track_name: no promotion triggers (OK)"
    continue
  fi

  for i in $(seq 0 $((trigger_count - 1))); do
    target=$(yq -r ".promotion_triggers[$i].suggest" "$track_file")
    condition=$(yq -r ".promotion_triggers[$i].condition" "$track_file")

    if [ -z "$target" ] || [ "$target" = "null" ]; then
      fail "$track_name trigger $i" "missing 'suggest' field"
      continue
    fi

    # Check target resolves to a valid track
    if [ -f "$TRACKS_DIR/${target}.yaml" ]; then
      pass "$track_name → $target (\"$condition\")"
    else
      fail "$track_name → $target" "tracks/${target}.yaml not found"
    fi
  done
done < <(track_files)

# ── Test: Promotion triggers have required fields ──

category "Promotion trigger structure"

while IFS= read -r track_file; do
  track_name=$(yq -r '.name' "$track_file")
  trigger_count=$(yq -r '.promotion_triggers | length' "$track_file")

  [ "$trigger_count" -eq 0 ] && continue

  for i in $(seq 0 $((trigger_count - 1))); do
    condition=$(yq -r ".promotion_triggers[$i].condition // \"\"" "$track_file")
    suggest=$(yq -r ".promotion_triggers[$i].suggest // \"\"" "$track_file")
    message=$(yq -r ".promotion_triggers[$i].message // \"\"" "$track_file")

    missing=()
    [ -z "$condition" ] && missing+=("condition")
    [ -z "$suggest" ] && missing+=("suggest")
    [ -z "$message" ] && missing+=("message")

    if [ ${#missing[@]} -eq 0 ]; then
      pass "$track_name trigger $i: all fields present"
    else
      fail "$track_name trigger $i" "missing: ${missing[*]}"
    fi
  done
done < <(track_files)

# ── Test: Track YAML triggers match promotion-rules.md ──

category "Promotion rules sync"

promotion_rules_md="$REFERENCES_DIR/promotion-rules.md"

while IFS= read -r track_file; do
  track_name=$(yq -r '.name' "$track_file")
  display_name=$(yq -r '.display_name' "$track_file")
  trigger_count=$(yq -r '.promotion_triggers | length' "$track_file")

  if [ "$trigger_count" -eq 0 ]; then
    # Check that promotion-rules.md also says no triggers
    if grep -qi "No defined promotion triggers\|no promotion triggers" "$promotion_rules_md" 2>/dev/null; then
      pass "$track_name: no triggers, documented in promotion-rules.md"
    fi
    continue
  fi

  # For each trigger target in the YAML, check it's mentioned in promotion-rules.md
  # under the track's section
  for i in $(seq 0 $((trigger_count - 1))); do
    target=$(yq -r ".promotion_triggers[$i].suggest" "$track_file")
    target_display=$(yq -r '.display_name' "$TRACKS_DIR/${target}.yaml" 2>/dev/null || echo "$target")

    # Check if the promotion-rules.md mentions this track promoting to the target
    # Look in the section for this track
    if grep -A20 "### ${display_name}" "$promotion_rules_md" | grep -qi "$target_display\|$target"; then
      pass "$track_name → $target: documented in promotion-rules.md"
    else
      fail "$track_name → $target" "not found in promotion-rules.md under ### $display_name"
    fi
  done
done < <(track_files)

# ── Test: Carry-forward documentation ──

category "Carry-forward completeness"

# promotion-rules.md must document what carries forward
CARRY_FORWARD_FIELDS=("description" "decisions" "files_in_scope")

for field in "${CARRY_FORWARD_FIELDS[@]}"; do
  if grep -qi "$field" "$promotion_rules_md"; then
    pass "carry-forward: \"$field\" documented"
  else
    fail "carry-forward" "\"$field\" not mentioned in promotion-rules.md"
  fi
done

# Check the promote command also handles carry-forward
promote_cmd="$COMMANDS_DIR/promote.md"
if [ -f "$promote_cmd" ]; then
  for field in "${CARRY_FORWARD_FIELDS[@]}"; do
    if grep -qi "$field" "$promote_cmd"; then
      pass "promote command: handles \"$field\""
    else
      fail "promote command" "\"$field\" not mentioned in promote.md"
    fi
  done
else
  fail "promote command" "commands/noru/promote.md not found"
fi

# ── Test: Skip-leg rules documented in promote.md ──

category "Skip-leg documentation"

if [ -f "$promote_cmd" ]; then
  # promote.md should document which promotions can skip legs
  if grep -q "skip\|Skip" "$promote_cmd"; then
    pass "skip-leg rules: present in promote.md"
  else
    fail "skip-leg rules" "no skip documentation in promote.md"
  fi

  # Specific known skip-leg scenarios
  SKIP_SCENARIOS=(
    "Bug Fix.*Change"
    "Troubleshoot.*Bug Fix"
  )

  for pattern in "${SKIP_SCENARIOS[@]}"; do
    if grep -qE "$pattern" "$promote_cmd"; then
      pass "skip-leg: $pattern documented"
    else
      fail "skip-leg" "$pattern not documented in promote.md"
    fi
  done
else
  fail "promote command" "not found"
fi

# ── Test: Bidirectional promotion consistency ──
# If track A can promote to track B, check that this makes semantic sense

category "Promotion direction sanity"

# Tracks should not promote to themselves
while IFS= read -r track_file; do
  track_name=$(yq -r '.name' "$track_file")
  trigger_count=$(yq -r '.promotion_triggers | length' "$track_file")

  if [ "$trigger_count" -gt 0 ]; then
    for i in $(seq 0 $((trigger_count - 1))); do
      target=$(yq -r ".promotion_triggers[$i].suggest" "$track_file")
      if [ "$target" = "$track_name" ]; then
        fail "$track_name" "promotes to itself"
      fi
    done
  fi
  pass "$track_name: no self-promotion"
done < <(track_files)

# Exploration should only promote to build tracks (Feature, Change), not diagnostic ones
exploration_targets=()
if [ -f "$TRACKS_DIR/exploration.yaml" ]; then
  while IFS= read -r target; do
    exploration_targets+=("$target")
  done < <(yq -r '.promotion_triggers[].suggest' "$TRACKS_DIR/exploration.yaml")

  for target in "${exploration_targets[@]}"; do
    case "$target" in
      feature|change|new-project)
        pass "exploration → $target: sensible promotion"
        ;;
      bug-fix|troubleshoot)
        fail "exploration → $target" "exploration shouldn't promote to diagnostic tracks"
        ;;
      *)
        pass "exploration → $target: noted"
        ;;
    esac
  done
fi

summary
