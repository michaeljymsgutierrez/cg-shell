#!/bin/bash
# Render a tmux window name as Nerd Font glyphs.
#
# Two fixes over the previous version:
#   1. It compared an UNQUOTED $string, so any window name containing a space
#      threw `[: ==: unary operator expected` once per space, per render.
#   2. The lookup was a function called through command substitution inside a
#      per-character loop - one subshell per character, per window, per tick.
#      A case statement does the same job in-process, and folds the upper/lower
#      pair into one branch so the tr subshell goes too.
#
# Unmapped characters (spaces, punctuation) are dropped, as before.

raw_window_name="${1-}"
formatted_window_name=""

# Retained for future use; the call site is currently commented out below.
add_dev_icon() {
  case "$(echo "$1" | tr '[:upper:]' '[:lower:]')" in
    *node*)       echo "󰎙 " ;;
    *git*)        echo "󰊢 " ;;
    *ember*)      echo "󰬰 " ;;
    *javascript*) echo "󰌞 " ;;
    *note*)       echo " " ;;
    *vim*)        echo " " ;;
    *zsh*)        echo " " ;;
    *src*)        echo " " ;;
    *srv*)        echo " " ;;
  esac
}

# formatted_window_name=$(add_dev_icon "$raw_window_name")

for (( i=0; i<${#raw_window_name}; i++ )); do
  case "${raw_window_name:$i:1}" in
    0)   formatted_window_name+="󰬹" ;;
    1)   formatted_window_name+="󰬺" ;;
    2)   formatted_window_name+="󰬻" ;;
    3)   formatted_window_name+="󰬼" ;;
    4)   formatted_window_name+="󰬽" ;;
    5)   formatted_window_name+="󰬾" ;;
    6)   formatted_window_name+="󰬿" ;;
    7)   formatted_window_name+="󰭀" ;;
    8)   formatted_window_name+="󰭁" ;;
    9)   formatted_window_name+="󰭂" ;;
    a|A) formatted_window_name+="󰫮" ;;
    b|B) formatted_window_name+="󰫯" ;;
    c|C) formatted_window_name+="󰫰" ;;
    d|D) formatted_window_name+="󰫱" ;;
    e|E) formatted_window_name+="󰫲" ;;
    f|F) formatted_window_name+="󰫳" ;;
    g|G) formatted_window_name+="󰫴" ;;
    h|H) formatted_window_name+="󰫵" ;;
    i|I) formatted_window_name+="󱂈" ;;
    j|J) formatted_window_name+="󰫷" ;;
    k|K) formatted_window_name+="󰫸" ;;
    l|L) formatted_window_name+="󱎦" ;;
    m|M) formatted_window_name+="󱎥" ;;
    n|N) formatted_window_name+="󰫻" ;;
    o|O) formatted_window_name+="󰬹" ;;
    p|P) formatted_window_name+="󰫽" ;;
    q|Q) formatted_window_name+="󰫾" ;;
    r|R) formatted_window_name+="󰫿" ;;
    s|S) formatted_window_name+="󰬀" ;;
    t|T) formatted_window_name+="󰬁" ;;
    u|U) formatted_window_name+="󰬂" ;;
    v|V) formatted_window_name+="󱂌" ;;
    w|W) formatted_window_name+="󰬄" ;;
    x|X) formatted_window_name+="󱂑" ;;
    y|Y) formatted_window_name+="󰬆" ;;
    z|Z) formatted_window_name+="󰬇" ;;
  esac
done

echo "$formatted_window_name"
