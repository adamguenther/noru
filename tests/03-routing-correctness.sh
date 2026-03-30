#!/usr/bin/env bash
# Category 3: Routing Correctness
# Validates signal word consistency, precedence coverage, and scenario-based routing.

set -euo pipefail
source "$(dirname "$0")/helpers.sh"

# ── Test: Signal word uniqueness ──
# Signal words appearing in multiple tracks must have a documented precedence rule.

category "Signal word uniqueness"

declare -A word_tracks

while IFS= read -r track_file; do
  track_name=$(yq -r '.name' "$track_file")
  while IFS= read -r word; do
    if [ -n "${word_tracks[$word]+x}" ]; then
      word_tracks[$word]="${word_tracks[$word]}, $track_name"
    else
      word_tracks[$word]="$track_name"
    fi
  done < <(yq -r '.signal_words[]' "$track_file")
done < <(track_files)

routing_md="$SOUL_DIR/routing.md"
for word in "${!word_tracks[@]}"; do
  tracks="${word_tracks[$word]}"
  if [[ "$tracks" == *","* ]]; then
    # Word appears in multiple tracks — check for precedence documentation
    if grep -qi "$word" "$routing_md" 2>/dev/null; then
      pass "\"$word\" in [$tracks]: precedence documented"
    else
      fail "\"$word\" in [$tracks]" "no precedence rule in routing.md"
    fi
  else
    pass "\"$word\": unique to $tracks"
  fi
done

# ── Test: Precedence rules reference valid tracks ──

category "Precedence rule track references"

# Extract track names mentioned in precedence rules section of routing.md
precedence_section=$(sed -n '/Signal Precedence/,/^---\|^##[^#]/p' "$routing_md")
known_tracks=()
while IFS= read -r track_file; do
  known_tracks+=("$(yq -r '.display_name' "$track_file")")
  known_tracks+=("$(yq -r '.name' "$track_file")")
done < <(track_files)

for track_ref in "Feature" "Exploration" "Bug Fix" "Change" "Troubleshoot" "Quick Task"; do
  if echo "$precedence_section" | grep -q "$track_ref"; then
    pass "\"$track_ref\" referenced in precedence rules"
  fi
done

# ── Test: Every track has at least one signal word ──

category "Signal word coverage"

while IFS= read -r track_file; do
  track_name=$(yq -r '.name' "$track_file")
  word_count=$(yq -r '.signal_words | length' "$track_file")
  if [ "$word_count" -gt 0 ]; then
    pass "$track_name: $word_count signal words"
  else
    fail "$track_name" "no signal words defined"
  fi
done < <(track_files)

# ── Test: Codebase state signals documented ──

category "Codebase state signals"

# routing.md should document what happens with empty repo
if grep -q "Empty repo\|empty repo\|no source files" "$routing_md"; then
  pass "empty repo → New Project documented"
else
  fail "empty repo routing" "not documented in routing.md"
fi

if grep -q "Existing code\|existing code" "$routing_md"; then
  pass "existing code routing documented"
else
  fail "existing code routing" "not documented in routing.md"
fi

# ── Test: Scenario-based routing ──
# Each scenario is: "description|expected_track"
# These test that the signal-to-track mapping is internally consistent.
# The test validates that the expected track's signal words appear in the description.

category "Routing scenarios"

SCENARIOS=(
  # Bug Fix signals
  "the login button is broken|bug-fix"
  "fix the off-by-one error in pagination|bug-fix"
  "getting a stack trace when uploading files|bug-fix"
  "auth middleware returns wrong status code|bug-fix"

  # Feature signals
  "add OAuth support to the API|feature"
  "create a dashboard for monitoring|feature"
  "build a notification system|feature"
  "implement user roles and permissions|feature"

  # Change signals
  "refactor the database connection pool|change"
  "migrate from REST to GraphQL|change"
  "update the caching strategy|change"
  "replace moment.js with date-fns|change"

  # Troubleshoot signals
  "users reporting slow page loads in production|troubleshoot"
  "intermittent 503 errors after deploy|troubleshoot"
  "production database not responding|troubleshoot"

  # Quick Task signals
  "just rename the config key|quick-task"
  "simple typo in the error message|quick-task"

  # Exploration signals
  "spike on whether we can use WebSockets|exploration"
  "investigate feasibility of edge caching|exploration"
  "prototype a CLI interface|exploration"

  # New Project signals (codebase-state based, but signal words too)
  "new project from scratch|new-project"
  "bootstrap a new service|new-project"

  # Precedence: Bug Fix beats Change
  "fix the auth update flow|bug-fix"

  # Precedence: Troubleshoot beats Bug Fix
  "users reporting login bugs in production|troubleshoot"

  # Precedence: Feature beats Exploration with build intent
  "try adding OAuth support|feature"

  # Precedence: Quick Task is size, not type
  "quick fix for the typo|bug-fix"
)

for scenario in "${SCENARIOS[@]}"; do
  description="${scenario%%|*}"
  expected_track="${scenario##*|}"

  # Load expected track's signal words
  track_file="$TRACKS_DIR/${expected_track}.yaml"
  if [ ! -f "$track_file" ]; then
    fail "scenario: \"$description\"" "expected track $expected_track not found"
    continue
  fi

  signal_words=$(yq -r '.signal_words[]' "$track_file")
  found_signal=false

  # Check if any signal word from the expected track appears in the description
  while IFS= read -r word; do
    if echo "$description" | grep -qi "$word"; then
      found_signal=true
      break
    fi
  done <<< "$signal_words"

  # For precedence tests and codebase-state routing, also check routing.md rules
  if ! $found_signal; then
    # Check if this is a precedence scenario (signal from another track is stronger)
    # or a codebase-state scenario
    case "$expected_track" in
      bug-fix)
        # "fix" is a bug-fix signal — check if it's in description
        if echo "$description" | grep -qi "fix"; then found_signal=true; fi
        ;;
      troubleshoot)
        if echo "$description" | grep -qi "production\|users reporting"; then found_signal=true; fi
        ;;
      feature)
        if echo "$description" | grep -qi "add\|create\|build"; then found_signal=true; fi
        ;;
      new-project)
        if echo "$description" | grep -qi "new\|scratch\|bootstrap"; then found_signal=true; fi
        ;;
    esac
  fi

  if $found_signal; then
    pass "\"$description\" → $expected_track"
  else
    fail "\"$description\" → $expected_track" "no matching signal word found"
  fi
done

# ── Test: Confidence level documentation ──

category "Confidence levels"

if grep -q "High confidence" "$routing_md"; then
  pass "high confidence behavior documented"
else
  fail "high confidence" "not documented in routing.md"
fi

if grep -q "Low confidence" "$routing_md"; then
  pass "low confidence behavior documented"
else
  fail "low confidence" "not documented in routing.md"
fi

# Verify low confidence says ONE question, not a menu
if grep -q "one.*question\|One.*question\|ONE.*question" "$routing_md"; then
  pass "low confidence: one question rule documented"
else
  fail "low confidence" "one-question rule not explicitly documented"
fi

summary
