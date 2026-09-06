#!/bin/bash
# Current time as glyphs: HH⋅MM followed by the AM/PM marker.

source "${BASH_SOURCE[0]%/*}/lib/icons.sh"

if [ "$(date +%p)" = "AM" ]; then
  period="󰫮󱎥"
else
  period="󰫽󱎥"
fi

echo "$(render_digits "$(date +%I)")⋅$(render_digits "$(date +%M)")$period"
