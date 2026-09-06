#!/bin/bash

source "${BASH_SOURCE[0]%/*}/lib/icons.sh"

unread_discord_notification=$(osascript <<'EOT'
    set discordBadge to 0
    tell application "System Events"
        tell process "Dock"
            try
                -- Target the specific Discord UI element
                set badgeValue to value of attribute "AXStatusLabel" of UI element "Discord" of list 1

                -- Check if the badge has a value and isn't empty
                if badgeValue is not missing value and badgeValue is not "" then
                    set discordBadge to badgeValue as integer
                end if
            on error
                -- Discord isn't in the Dock or Accessibility is blocked
                set discordBadge to 0
            end try
        end tell
    end tell
    return discordBadge
EOT
)

# osascript yields an empty string when Accessibility is blocked or the app is
# not in the Dock; [ "" -eq 0 ] throws "integer expression expected".
case "$unread_discord_notification" in
  ''|*[!0-9]*) unread_discord_notification=0 ;;
esac

unread_notification=""

if [ "$unread_discord_notification" -eq 0 ]; then
  unread_notification="#[fg=#f8f1ff,bg=#222222,bold]#[fg=#f8f1ff,bg=#222222,bold]"
fi

if [ "$unread_discord_notification" -gt 0 ]; then
  unread_notification="#[fg=#fde466,bg=#222222,bold]#[fg=#f8f1ff,bg=#222222,bold]"
fi

unread_notification+=$(render_digits "$unread_discord_notification")

echo "$unread_notification"

