#!/bin/bash
# Current date as glyphs: YYYY·MM⋅DD

source "${BASH_SOURCE[0]%/*}/lib/icons.sh"

echo "$(render_digits "$(date +%Y)")·$(render_digits "$(date +%m)")⋅$(render_digits "$(date +%d)")"
