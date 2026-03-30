#!/usr/bin/env bash
# Run all Noru framework tests.
# Usage: bash tests/run-all.sh [category-number]
#   No args: run all categories
#   With arg: run only that category (e.g., "3" for routing)

set -euo pipefail

TESTS_DIR="$(cd "$(dirname "$0")" && pwd)"
TOTAL_PASS=0
TOTAL_FAIL=0
TOTAL_SKIP=0
FAILED_CATEGORIES=()

run_category() {
  local test_file="$1"
  local name
  name=$(basename "$test_file" .sh | sed 's/^[0-9]*-//')

  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "  Category: $name"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

  local output
  output=$(bash "$test_file" 2>&1) || true
  echo "$output"

  # Extract counts from the Results line
  local p f s
  p=$(echo "$output" | grep "passed" | grep -oE '[0-9]+ passed' | grep -oE '[0-9]+' || echo 0)
  f=$(echo "$output" | grep "failed" | grep -oE '[0-9]+ failed' | grep -oE '[0-9]+' || echo 0)
  s=$(echo "$output" | grep "skipped" | grep -oE '[0-9]+ skipped' | grep -oE '[0-9]+' || echo 0)

  TOTAL_PASS=$((TOTAL_PASS + p))
  TOTAL_FAIL=$((TOTAL_FAIL + f))
  TOTAL_SKIP=$((TOTAL_SKIP + s))

  if [ "$f" -gt 0 ]; then
    FAILED_CATEGORIES+=("$name ($f)")
  fi
}

# Determine which tests to run
if [ -n "${1:-}" ]; then
  target=$(printf "%02d" "$1")
  matching_files=("$TESTS_DIR"/${target}-*.sh)
  if [ ! -f "${matching_files[0]}" ]; then
    echo "No test file found for category $1"
    exit 1
  fi
  for f in "${matching_files[@]}"; do
    run_category "$f"
  done
else
  for test_file in "$TESTS_DIR"/[0-9]*.sh; do
    run_category "$test_file"
  done
fi

# Final summary
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  TOTAL: $TOTAL_PASS passed, $TOTAL_FAIL failed, $TOTAL_SKIP skipped"
if [ ${#FAILED_CATEGORIES[@]} -gt 0 ]; then
  echo "  FAILED: ${FAILED_CATEGORIES[*]}"
fi
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

[ "$TOTAL_FAIL" -gt 0 ] && exit 1
exit 0
