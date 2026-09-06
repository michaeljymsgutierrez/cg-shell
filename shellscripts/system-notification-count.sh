#!/bin/bash

source "${BASH_SOURCE[0]%/*}/lib/icons.sh"

unread_system_notification=$(osascript <<'EOT'
  set totalCount to 0
  tell application "System Events"
      tell process "Dock"
          try
              -- Get every icon currently in the Dock
              set allDockItems to UI elements of list 1
              repeat with anItem in allDockItems
                  try
                      -- Get the red badge value for the current icon
                      set badgeValue to value of attribute "AXStatusLabel" of anItem

                      -- If the badge exists and contains a number, add it to the total
                      if badgeValue is not missing value and badgeValue is not "" then
                          set totalCount to totalCount + (badgeValue as integer)
                      end if
                  on error
                      -- Ignore items that dont have badges
                  end try
              end repeat
          on error
              return 0
          end try
      end tell
  end tell
  return totalCount
EOT
)

# osascript yields an empty string when Accessibility is blocked or the app is
# not in the Dock; [ "" -eq 0 ] throws "integer expression expected".
case "$unread_system_notification" in
  ''|*[!0-9]*) unread_system_notification=0 ;;
esac

unread_notification=""

if [ "$unread_system_notification" -eq 0 ]; then
  unread_notification="#[fg=#f8f1ff,bg=#222222,bold]󰵛#[fg=#f8f1ff,bg=#222222,bold] "
fi

if [ "$unread_system_notification" -gt 0 ]; then
  unread_notification="#[fg=#fde466,bg=#222222,bold]󰵚#[fg=#f8f1ff,bg=#222222,bold] "
fi

unread_notification+=$(render_digits "$unread_system_notification")

echo "$unread_notification"

