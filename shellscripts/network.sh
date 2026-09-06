#!/bin/bash
# Network reachability indicator.
#
# The probe is cached and refreshed in the background; only the spinner advances
# on every tick. The previous version ran a bare `ping -c 2 google.com` inline
# with no timeout, which cost a measured 1.02s on a good connection and blocked
# for a measured 12s against an unroutable host - against a status-interval of
# 3s, so a wifi drop left four ping jobs overlapping. `-t 2` now caps the probe,
# and the cache keeps it off the tick entirely.

connected_icons=("󰤡" "󰤤" "󰤧" "󰤪")
disconnected_icons=("󰤠" "󰤣" "󰤦" "󰤩")

state_file="/tmp/net_progress_index"
cache_file="${TMPDIR:-/tmp}/cg-status-network-state.cache"
lock_dir="$cache_file.lock"
ttl=15

now=$(date +%s)

probe() {
  # -t bounds the whole operation. Without it an unroutable host hangs ~12s.
  if ping -c 1 -t 2 google.com >/dev/null 2>&1; then
    echo up
  else
    echo down
  fi
}

if [ ! -s "$cache_file" ]; then
  # Cold: probe once so the first render is truthful rather than guessing.
  probe > "$cache_file" 2>/dev/null
else
  mtime=$(stat -f %m "$cache_file" 2>/dev/null || echo 0)
  if [ $(( now - mtime )) -ge "$ttl" ]; then
    if [ -d "$lock_dir" ]; then
      lock_mtime=$(stat -f %m "$lock_dir" 2>/dev/null || echo 0)
      [ $(( now - lock_mtime )) -gt 60 ] && rmdir "$lock_dir" 2>/dev/null
    fi
    # Atomic lock: at most one probe in flight, so probes can never stack.
    if mkdir "$lock_dir" 2>/dev/null; then
      (
        trap 'rmdir "$lock_dir" 2>/dev/null' EXIT
        probe > "$cache_file.tmp" 2>/dev/null && mv -f "$cache_file.tmp" "$cache_file"
      ) </dev/null >/dev/null 2>&1 &
    fi
  fi
fi

network_state=$(cat "$cache_file" 2>/dev/null)

index=$(cat "$state_file" 2>/dev/null || echo 0)
# Guard a missing or corrupted state file before using it as an array index.
case "$index" in
  ''|*[!0-9]*) index=0 ;;
esac
[ "$index" -ge "${#connected_icons[@]}" ] && index=0

if [ "$network_state" = "up" ]; then
  output="#[fg=#fde466,bg=#222222,bold]${connected_icons[$index]} #[fg=#f8f1ff,bg=#222222,bold]󰫰󰫻"
else
  output="#[fg=#fa618d,bg=#222222,bold]${disconnected_icons[$index]} #[fg=#f8f1ff,bg=#222222,bold]󰫱󰫰"
fi

echo $(( (index + 1) % ${#connected_icons[@]} )) > "$state_file"

echo "$output"
