#!/bin/bash
# Serve a status script's output from a cache, refreshing in the background.
#
# The status bar never blocks on a slow script: it prints the last known value
# immediately and, only when that value has gone stale, kicks off a detached
# refresh for the NEXT tick to pick up. This is what keeps the AppleScript
# notification counters (measured 0.10-0.24s each, five of them firing on the
# same tick) off the critical path.
#
# Usage: cached.sh <ttl_seconds> <script-name> [args...]
#   cached.sh 15 mail-notification-count.sh
#
# The wrapped scripts stay untouched and independently runnable - caching is a
# status-bar concern, not theirs.

set -u

[ "$#" -ge 2 ] || { echo "usage: cached.sh <ttl> <script> [args...]" >&2; exit 64; }

ttl="$1"; shift
script_name="$1"; shift

# Pure parameter expansion - no subshell, since this runs on every tick.
lib_dir="${BASH_SOURCE[0]%/*}"
script="${lib_dir%/*}/$script_name"

cache_file="${TMPDIR:-/tmp}/cg-status-${script_name%.sh}.cache"
lock_dir="$cache_file.lock"

now=$(date +%s)

# Cold cache: block once, so the bar shows something on the very first tick
# instead of a gap.
if [ ! -s "$cache_file" ]; then
  "$script" "$@" > "$cache_file" 2>/dev/null
  cat "$cache_file" 2>/dev/null
  exit 0
fi

# Warm: always serve immediately, stale or not.
cat "$cache_file"

mtime=$(stat -f %m "$cache_file" 2>/dev/null || echo 0)
[ $(( now - mtime )) -lt "$ttl" ] && exit 0

# Stale. Clear a lock abandoned by a killed refresh before trying to take it.
if [ -d "$lock_dir" ]; then
  lock_mtime=$(stat -f %m "$lock_dir" 2>/dev/null || echo 0)
  [ $(( now - lock_mtime )) -gt 60 ] && rmdir "$lock_dir" 2>/dev/null
fi

# mkdir is atomic, so only one refresh can be in flight per script - this is
# what stops slow probes from stacking the way the old un-timed ping did.
if mkdir "$lock_dir" 2>/dev/null; then
  (
    trap 'rmdir "$lock_dir" 2>/dev/null' EXIT
    if "$script" "$@" > "$cache_file.tmp" 2>/dev/null; then
      mv -f "$cache_file.tmp" "$cache_file"
    else
      # Keep serving the last good value, but reset the clock so a failing
      # script is retried once per TTL rather than on every single tick.
      rm -f "$cache_file.tmp"
      touch "$cache_file"
    fi
  # Detaching all three streams is load-bearing: tmux reads #() until EOF on
  # stdout, so a background child holding it open would hang the whole tick.
  ) </dev/null >/dev/null 2>&1 &
fi

exit 0
