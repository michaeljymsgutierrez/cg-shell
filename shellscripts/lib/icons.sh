#!/bin/bash
# Shared Nerd Font digit glyphs, sourced by every status script that renders a
# number. Kept in one place so a glyph change lands everywhere at once - this
# block was previously copy-pasted verbatim into eight scripts.
#
# Usage:
#   source "${BASH_SOURCE[0]%/*}/lib/icons.sh"
#   render_digits "42"   ->  the glyphs for 4 and 2

icons[0]="󰬹"
icons[1]="󰬺"
icons[2]="󰬻"
icons[3]="󰬼"
icons[4]="󰬽"
icons[5]="󰬾"
icons[6]="󰬿"
icons[7]="󰭀"
icons[8]="󰭁"
icons[9]="󰭂"

# Map each digit of $1 to its glyph. Non-digits are skipped, matching the
# behaviour of the per-script loops this replaces.
render_digits() {
  local input="$1"
  local out=""
  local i char
  for (( i=0; i<${#input}; i++ )); do
    char="${input:$i:1}"
    case "$char" in
      [0-9]) out+="${icons[$char]}" ;;
    esac
  done
  printf '%s' "$out"
}
