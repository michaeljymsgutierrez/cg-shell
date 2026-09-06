#!/bin/bash
# CPU usage as a percentage of total capacity across all logical cores.

source "${BASH_SOURCE[0]%/*}/lib/icons.sh"

cpu_cores=$(sysctl -n hw.logicalcpu)
cpu_usage=$(ps -A -o %cpu | awk -v cores="$cpu_cores" '{sum+=$1} END {printf "%.0f", sum/cores}')

if [ "$cpu_usage" -lt 0 ] 2>/dev/null; then cpu_usage=0; fi
if [ "$cpu_usage" -gt 99 ] 2>/dev/null; then cpu_usage=99; fi

if [ ${#cpu_usage} -eq 1 ]; then
  cpu_usage="0$cpu_usage"
fi

cpu_icon="#[fg=#fde466,bg=#222222,bold]󰍛#[fg=#f8f1ff,bg=#222222,bold]"

echo "$cpu_icon $(render_digits "$cpu_usage")"
