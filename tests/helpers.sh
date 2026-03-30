#!/usr/bin/env bash
# Test helpers — shared across all test categories

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TRACKS_DIR="$REPO_ROOT/tracks"
STEPS_DIR="$REPO_ROOT/steps"
AGENTS_DIR="$REPO_ROOT/agents"
COMMANDS_DIR="$REPO_ROOT/commands/noru"
SOUL_DIR="$REPO_ROOT/soul"
REFERENCES_DIR="$REPO_ROOT/references"
TEMPLATES_DIR="$REPO_ROOT/templates"

# Counters
PASS=0
FAIL=0
SKIP=0
CURRENT_CATEGORY=""

category() {
  CURRENT_CATEGORY="$1"
  echo ""
  echo "── $1 ──"
}

pass() {
  PASS=$((PASS + 1))
  echo "  ✓ $1"
}

fail() {
  FAIL=$((FAIL + 1))
  echo "  ✗ $1"
  [ -n "${2:-}" ] && echo "    → $2"
}

skip() {
  SKIP=$((SKIP + 1))
  echo "  - $1 (skipped)"
}

summary() {
  echo ""
  echo "── Results ──"
  echo "  $PASS passed, $FAIL failed, $SKIP skipped"
  [ "$FAIL" -gt 0 ] && return 1
  return 0
}

# Extract YAML frontmatter field from a markdown file
# Usage: frontmatter_field file.md "field_name"
frontmatter_field() {
  local file="$1" field="$2"
  sed -n '/^---$/,/^---$/p' "$file" | grep "^${field}:" | sed "s/^${field}:[[:space:]]*//" | sed 's/^["'"'"']//' | sed 's/["'"'"']$//' || true
}

# Extract all values of a YAML list field from track YAML
# Usage: yaml_list_field file.yaml "field_path"
yaml_list_field() {
  yq -r "$2 // [] | .[]" "$1" 2>/dev/null
}

# Get all track YAML files
track_files() {
  find "$TRACKS_DIR" -name '*.yaml' -type f | sort
}

# Get all step markdown files
step_files() {
  find "$STEPS_DIR" -name '*.md' -type f | sort
}

# Get all agent markdown files
agent_files() {
  find "$AGENTS_DIR" -name '*.md' -type f | sort
}

# Get all command markdown files
command_files() {
  find "$COMMANDS_DIR" -name '*.md' -type f | sort
}

# Get all output-facing files (commands, steps, agents, templates)
output_facing_files() {
  find "$COMMANDS_DIR" "$STEPS_DIR" "$AGENTS_DIR" "$TEMPLATES_DIR" -name '*.md' -type f | sort
}
