#!/bin/bash

source "${BASH_SOURCE[0]%/*}/lib/icons.sh"

unread_calendar_notification=$(osascript <<'EOT'
    set calendarBadge to 0
    tell application "System Events"
        tell process "Dock"
            try
                -- Target the specific Calendar UI element
                set badgeValue to value of attribute "AXStatusLabel" of UI element "Calendar" of list 1

                -- Check if the badge has a value and isn't empty
                if badgeValue is not missing value and badgeValue is not "" then
                    set calendarBadge to badgeValue as integer
                end if
            on error
                -- Calendar isn't in the Dock or Accessibility is blocked
                set calendarBadge to 0
            end try
        end tell
    end tell
    return calendarBadge
EOT
)

# osascript yields an empty string when Accessibility is blocked or the app is
# not in the Dock; [ "" -eq 0 ] throws "integer expression expected".
case "$unread_calendar_notification" in
  ''|*[!0-9]*) unread_calendar_notification=0 ;;
esac

unread_notification=""

if [ "$unread_calendar_notification" -eq 0 ]; then
  unread_notification="#[fg=#f8f1ff,bg=#222222,bold]󰃗#[fg=#f8f1ff,bg=#222222,bold]"
fi

if [ "$unread_calendar_notification" -gt 0 ]; then
  unread_notification="#[fg=#fde466,bg=#222222,bold]󱃐#[fg=#f8f1ff,bg=#222222,bold]"
fi

unread_notification+=$(render_digits "$unread_calendar_notification")

echo "$unread_notification"
