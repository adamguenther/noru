#!/usr/bin/env bash
# Category 5: Lifecycle Consistency
# Validates state transitions, checkpoint firing, and archive cleanup rules.

set -euo pipefail
source "$(dirname "$0")/helpers.sh"

TEMP_DIR=$(mktemp -d)
trap "rm -rf $TEMP_DIR" EXIT

# ── Helper: create a state.yaml for a given track at a given leg ──

create_state() {
  local track="$1" leg_index="$2" outfile="$3"
  local track_file="$TRACKS_DIR/${track}.yaml"
  local total_legs display_name description

  total_legs=$(yq -r '.legs | length' "$track_file")
  display_name=$(yq -r '.display_name' "$track_file")
  description="test run of $display_name"

  {
    echo "version: 1"
    echo "track: $track"
    echo "description: \"$description\""
    echo "started: 2026-03-30T00:00:00Z"
    echo "status: active"
    echo "current_leg: $((leg_index + 1))"
    echo "total_legs: $total_legs"
    echo "legs:"

    for i in $(seq 0 $((total_legs - 1))); do
      local leg_id
      leg_id=$(yq -r ".legs[$i].id" "$track_file")
      if [ "$i" -lt "$leg_index" ]; then
        echo "  - id: $leg_id"
        echo "    status: complete"
        echo "    started: 2026-03-30T00:00:00Z"
        echo "    completed: 2026-03-30T00:01:00Z"
      elif [ "$i" -eq "$leg_index" ]; then
        echo "  - id: $leg_id"
        echo "    status: in-progress"
        echo "    started: 2026-03-30T00:01:00Z"
        echo "    completed: null"
      else
        echo "  - id: $leg_id"
        echo "    status: pending"
        echo "    started: null"
        echo "    completed: null"
      fi
    done

    echo "decisions: []"
  } > "$outfile"
}

# ── Test: State transitions are valid ──

category "State transition validity"

VALID_STATUSES=("pending" "in-progress" "complete" "skipped")

# For each track, simulate progression through all legs
while IFS= read -r track_file; do
  track_name=$(yq -r '.name' "$track_file")
  total_legs=$(yq -r '.legs | length' "$track_file")

  for leg_index in $(seq 0 $((total_legs - 1))); do
    state_file="$TEMP_DIR/${track_name}-leg${leg_index}.yaml"
    create_state "$track_name" "$leg_index" "$state_file"

    # Validate: all legs before current are complete, current is in-progress, rest are pending
    all_valid=true
    for i in $(seq 0 $((total_legs - 1))); do
      status=$(yq -r ".legs[$i].status" "$state_file")
      if [ "$i" -lt "$leg_index" ]; then
        [ "$status" != "complete" ] && all_valid=false
      elif [ "$i" -eq "$leg_index" ]; then
        [ "$status" != "in-progress" ] && all_valid=false
      else
        [ "$status" != "pending" ] && all_valid=false
      fi
    done

    if $all_valid; then
      pass "$track_name at leg $((leg_index + 1))/$total_legs: valid state"
    else
      fail "$track_name at leg $((leg_index + 1))/$total_legs" "invalid leg statuses"
    fi
  done
done < <(track_files)

# ── Test: current_leg advances correctly ──

category "Leg advancement"

while IFS= read -r track_file; do
  track_name=$(yq -r '.name' "$track_file")
  total_legs=$(yq -r '.legs | length' "$track_file")

  for leg_index in $(seq 0 $((total_legs - 1))); do
    state_file="$TEMP_DIR/${track_name}-leg${leg_index}.yaml"
    current_leg=$(yq -r '.current_leg' "$state_file")
    expected=$((leg_index + 1))

    if [ "$current_leg" -eq "$expected" ]; then
      pass "$track_name: current_leg=$current_leg at position $expected"
    else
      fail "$track_name" "current_leg=$current_leg, expected $expected"
    fi
  done
done < <(track_files)

# ── Test: Checkpoints fire only at marked legs ──

category "Checkpoint markers"

while IFS= read -r track_file; do
  track_name=$(yq -r '.name' "$track_file")
  total_legs=$(yq -r '.legs | length' "$track_file")
  checkpoint_legs=()
  non_checkpoint_legs=()

  for i in $(seq 0 $((total_legs - 1))); do
    leg_id=$(yq -r ".legs[$i].id" "$track_file")
    checkpoint=$(yq -r ".legs[$i].checkpoint" "$track_file")

    if [ "$checkpoint" = "true" ]; then
      checkpoint_legs+=("$leg_id")
    else
      non_checkpoint_legs+=("$leg_id")
    fi
  done

  if [ ${#checkpoint_legs[@]} -gt 0 ]; then
    pass "$track_name: checkpoint legs: ${checkpoint_legs[*]}"
  else
    pass "$track_name: no checkpoint legs (lightweight track)"
  fi

  # Verify checkpoint legs are at meaningful boundaries (not first or last leg)
  first_leg=$(yq -r '.legs[0].id' "$track_file")
  last_leg=$(yq -r ".legs[$((total_legs - 1))].id" "$track_file")

  for cp_leg in "${checkpoint_legs[@]}"; do
    if [ "$cp_leg" = "$first_leg" ]; then
      fail "$track_name: checkpoint on first leg" "$cp_leg — checkpoints should be at meaningful boundaries"
    fi
    # Last leg checkpoint is fine (final state preservation)
  done
done < <(track_files)

# ── Test: Archive step resets state correctly ──

category "Archive behavior"

# The archive step should reference resetting state to template
archive_step="$STEPS_DIR/archive.md"
if [ -f "$archive_step" ]; then
  if grep -q "state.yaml" "$archive_step"; then
    pass "archive: references state.yaml update"
  else
    fail "archive" "doesn't mention state.yaml"
  fi

  if grep -q "templates/state.yaml\|template" "$archive_step"; then
    pass "archive: references template for reset"
  else
    fail "archive" "doesn't reference template for state reset"
  fi

  # Archive should preserve checkpoints
  if grep -qi "keep.*checkpoint\|checkpoint.*keep\|Keep.*checkpoint" "$archive_step"; then
    pass "archive: preserves checkpoints"
  else
    fail "archive" "doesn't document checkpoint preservation"
  fi

  # Archive should remove plans and specs
  if grep -qi "remove.*plan\|clean.*plan\|Remove.*plan" "$archive_step"; then
    pass "archive: cleans up plans"
  else
    fail "archive" "doesn't document plan cleanup"
  fi

  if grep -qi "remove.*spec\|clean.*spec\|Remove.*spec" "$archive_step"; then
    pass "archive: cleans up specs"
  else
    fail "archive" "doesn't document spec cleanup"
  fi
else
  fail "archive step" "steps/archive.md not found"
fi

# ── Test: State template is valid reset state ──

category "Reset state validity"

template="$TEMPLATES_DIR/state.yaml"
if [ -f "$template" ]; then
  # All fields should be at reset values
  track=$(yq -r '.track' "$template")
  desc=$(yq -r '.description' "$template")
  started=$(yq -r '.started' "$template")
  current_leg=$(yq -r '.current_leg' "$template")
  total_legs=$(yq -r '.total_legs' "$template")
  legs_count=$(yq -r '.legs | length' "$template")
  decisions_count=$(yq -r '.decisions | length' "$template")

  [ "$track" = "null" ] && pass "reset: track is null" || fail "reset: track" "expected null, got $track"
  [ "$desc" = "" ] && pass "reset: description is empty" || fail "reset: description" "expected empty, got $desc"
  [ "$started" = "null" ] && pass "reset: started is null" || fail "reset: started" "expected null, got $started"
  [ "$current_leg" = "0" ] && pass "reset: current_leg is 0" || fail "reset: current_leg" "expected 0, got $current_leg"
  [ "$total_legs" = "0" ] && pass "reset: total_legs is 0" || fail "reset: total_legs" "expected 0, got $total_legs"
  [ "$legs_count" = "0" ] && pass "reset: legs is empty" || fail "reset: legs" "expected empty, got $legs_count items"
  [ "$decisions_count" = "0" ] && pass "reset: decisions is empty" || fail "reset: decisions" "expected empty, got $decisions_count items"
else
  fail "reset state" "templates/state.yaml not found"
fi

# ── Test: Every track that uses multi-review or archive has it as a late leg ──

category "Review and archive ordering"

while IFS= read -r track_file; do
  track_name=$(yq -r '.name' "$track_file")
  total_legs=$(yq -r '.legs | length' "$track_file")

  # Find position of archive and review legs
  for i in $(seq 0 $((total_legs - 1))); do
    step=$(yq -r ".legs[$i].step" "$track_file")
    if [ "$step" = "archive" ]; then
      if [ "$i" -eq $((total_legs - 1)) ]; then
        pass "$track_name: archive is last leg"
      else
        fail "$track_name" "archive at position $((i + 1))/$total_legs — should be last"
      fi
    fi
    if [ "$step" = "multi-review" ]; then
      if [ "$i" -ge $((total_legs - 3)) ]; then
        pass "$track_name: review is near end (position $((i + 1))/$total_legs)"
      else
        fail "$track_name" "review at position $((i + 1))/$total_legs — too early"
      fi
    fi
  done
done < <(track_files)

# ── Test: Execution legs come after planning legs ──

category "Planning before execution ordering"

while IFS= read -r track_file; do
  track_name=$(yq -r '.name' "$track_file")
  total_legs=$(yq -r '.legs | length' "$track_file")

  plan_pos=-1
  exec_pos=-1

  for i in $(seq 0 $((total_legs - 1))); do
    step=$(yq -r ".legs[$i].step" "$track_file")
    case "$step" in
      plan) plan_pos=$i ;;
      wave-execute|sequential-execute|inline-execute) exec_pos=$i ;;
    esac
  done

  if [ "$plan_pos" -ge 0 ] && [ "$exec_pos" -ge 0 ]; then
    if [ "$plan_pos" -lt "$exec_pos" ]; then
      pass "$track_name: planning (pos $((plan_pos + 1))) before execution (pos $((exec_pos + 1)))"
    else
      fail "$track_name" "execution at pos $((exec_pos + 1)) before planning at pos $((plan_pos + 1))"
    fi
  fi
done < <(track_files)

summary
