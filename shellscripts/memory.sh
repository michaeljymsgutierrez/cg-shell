#!/bin/bash
# Memory pressure as active+wired pages against total physical memory.

source "${BASH_SOURCE[0]%/*}/lib/icons.sh"

total_mem=$(sysctl -n hw.memsize)
page_size=$(sysctl -n hw.pagesize)

mem_usage=$(vm_stat | awk -v total="$total_mem" -v ps="$page_size" '
  /Pages active:/     { gsub(/\./, ""); active=$NF }
  /Pages wired down:/ { gsub(/\./, ""); wired=$NF }
  END { printf "%.0f", (active + wired) * ps / total * 100 }
')

if [ "$mem_usage" -lt 0 ] 2>/dev/null; then mem_usage=0; fi
if [ "$mem_usage" -gt 99 ] 2>/dev/null; then mem_usage=99; fi

if [ ${#mem_usage} -eq 1 ]; then
  mem_usage="0$mem_usage"
fi

mem_icon="#[fg=#fde466,bg=#222222,bold]󰘚#[fg=#f8f1ff,bg=#222222,bold]"

echo "$mem_icon $(render_digits "$mem_usage")"
