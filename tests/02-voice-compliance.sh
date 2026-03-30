#!/usr/bin/env bash
# Category 2: Voice Compliance
# Validates that output-facing files don't contain banned phrases or sycophancy patterns.

set -euo pipefail
source "$(dirname "$0")/helpers.sh"

# ── Banned phrases from voice.md ──

category "Banned phrases"

BANNED_PHRASES=(
  "Great idea"
  "Great question"
  "You're absolutely right"
  "That's a really smart approach"
  "Excellent point"
  "Love that idea"
  "Perfect, let me"
  "Absolutely! I"
  "That's a great catch"
)

while IFS= read -r file; do
  rel_path="${file#$REPO_ROOT/}"
  file_clean=true
  for phrase in "${BANNED_PHRASES[@]}"; do
    # Case-insensitive search, skip the voice.md file itself (it lists them as examples)
    if [[ "$rel_path" == "soul/voice.md" ]]; then
      continue 2
    fi
    if grep -qi "$phrase" "$file" 2>/dev/null; then
      fail "$rel_path: contains banned phrase" "\"$phrase\""
      file_clean=false
    fi
  done
  if $file_clean; then
    pass "$rel_path: no banned phrases"
  fi
done < <(output_facing_files)

# ── Sycophancy patterns ──

category "Sycophancy patterns"

# Broader patterns that indicate sycophantic tone
SYCOPHANCY_PATTERNS=(
  "Great!"
  "Excellent!"
  "Awesome!"
  "Wonderful!"
  "Fantastic!"
  "Amazing!"
  "Brilliant!"
  "Well done"
  "Good job"
  "Nice work"
  "Love it"
  "I love"
  "That's perfect"
  "You're right"
  "Absolutely right"
  "Couldn't agree more"
)

while IFS= read -r file; do
  rel_path="${file#$REPO_ROOT/}"
  # Skip voice.md (contains examples of what NOT to say)
  [[ "$rel_path" == "soul/voice.md" ]] && continue
  file_clean=true
  for pattern in "${SYCOPHANCY_PATTERNS[@]}"; do
    if grep -qi "$pattern" "$file" 2>/dev/null; then
      # Check it's not in a "Bad:" example block
      line=$(grep -ni "$pattern" "$file" | head -1)
      line_num=$(echo "$line" | cut -d: -f1)
      # Check if nearby lines contain "Bad:" — if so, it's an anti-example
      context=$(sed -n "$((line_num > 3 ? line_num - 3 : 1)),${line_num}p" "$file")
      if echo "$context" | grep -q "Bad:"; then
        continue
      fi
      fail "$rel_path: sycophancy pattern" "\"$pattern\" (line $line_num)"
      file_clean=false
    fi
  done
  if $file_clean; then
    pass "$rel_path: no sycophancy patterns"
  fi
done < <(output_facing_files)

# ── Customer support / chatbot tone indicators ──

category "Tone red flags"

TONE_RED_FLAGS=(
  "I'd be happy to"
  "I'm happy to"
  "Let me help you"
  "How can I help"
  "Thank you for"
  "Thanks for sharing"
  "I understand your"
  "I appreciate your"
  "Don't hesitate to"
  "Feel free to"
  "No worries"
  "Sure thing"
  "Of course!"
)

while IFS= read -r file; do
  rel_path="${file#$REPO_ROOT/}"
  [[ "$rel_path" == "soul/voice.md" ]] && continue
  file_clean=true
  for phrase in "${TONE_RED_FLAGS[@]}"; do
    if grep -qi "$phrase" "$file" 2>/dev/null; then
      line=$(grep -ni "$phrase" "$file" | head -1)
      line_num=$(echo "$line" | cut -d: -f1)
      # Skip if in a "Bad:" example
      context=$(sed -n "$((line_num > 3 ? line_num - 3 : 1)),${line_num}p" "$file")
      if echo "$context" | grep -q "Bad:"; then
        continue
      fi
      fail "$rel_path: customer support tone" "\"$phrase\" (line $line_num)"
      file_clean=false
    fi
  done
  if $file_clean; then
    pass "$rel_path: clean tone"
  fi
done < <(output_facing_files)

summary
