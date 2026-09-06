#!/bin/bash
# Battery level and charging state.
#
# The empty-value guard now runs BEFORE the numeric comparisons. It used to sit
# at the bottom, so a failed pmset read hit `[ "" -ge 1 ]` first and threw
# `[: -ge: unary operator expected`. Silent on a healthy machine, which is why
# it went unnoticed.
#
# The per-range AC branches collapsed into one wrap at the end - the charging
# colour is the same regardless of level, so it was eight duplicated pairs.

source "${BASH_SOURCE[0]%/*}/lib/icons.sh"

battery_percentage=$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)
battery_state=$(pmset -g ps | sed -nE "s|.*'(.*) Power.*|\1|p")

if [ -z "$battery_percentage" ]; then
  echo "#[fg=#fde466,bg=#222222,bold]󰪥#[fg=#f8f1ff,bg=#222222,bold] 󰬺󰬹󰬹"
  exit 0
fi

if [ "$battery_percentage" -ge 1 ] && [ "$battery_percentage" -le 100 ]; then
  if   [ "$battery_percentage" -le 12 ]; then battery_state_icon="󰪞"
  elif [ "$battery_percentage" -le 25 ]; then battery_state_icon="󰪟"
  elif [ "$battery_percentage" -le 37 ]; then battery_state_icon="󰪠"
  elif [ "$battery_percentage" -le 50 ]; then battery_state_icon="󰪡"
  elif [ "$battery_percentage" -le 62 ]; then battery_state_icon="󰪢"
  elif [ "$battery_percentage" -le 75 ]; then battery_state_icon="󰪣"
  elif [ "$battery_percentage" -le 88 ]; then battery_state_icon="󰪤"
  else                                        battery_state_icon="󰪥"
  fi

  if [ "$battery_state" = "AC" ]; then
    battery_state_icon="#[fg=#fde466,bg=#222222,bold]${battery_state_icon}#[fg=#f8f1ff,bg=#222222,bold]"
  fi
else
  battery_state_icon="󰗖"
fi

echo "$battery_state_icon $(render_digits "$battery_percentage")"
