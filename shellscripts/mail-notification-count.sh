#!/bin/bash

source "${BASH_SOURCE[0]%/*}/lib/icons.sh"

unread_mail_notification=$(osascript -e 'tell application "Mail" to get unread count of inbox')

# osascript yields an empty string when Accessibility is blocked or the app is
# not in the Dock; [ "" -eq 0 ] throws "integer expression expected".
case "$unread_mail_notification" in
  ''|*[!0-9]*) unread_mail_notification=0 ;;
esac

unread_notification=""

if [ "$unread_mail_notification" -eq 0 ]; then
  unread_notification="#[fg=#f8f1ff,bg=#222222,bold]󰛮#[fg=#f8f1ff,bg=#222222,bold]"
fi

if [ "$unread_mail_notification" -gt 0 ]; then
  unread_notification="#[fg=#fde466,bg=#222222,bold]󰶍#[fg=#f8f1ff,bg=#222222,bold]"
fi

unread_notification+=$(render_digits "$unread_mail_notification")

echo "$unread_notification"
