# Monokai Pro Theme
pane_text_color="#f8f1ff"
pane_background_color="#222222"
active_pane_border_color="#fde466"
inactive_pane_border_color="#444444"
tab_pointer_background_color="#fde465"

set -g mode-style "fg=$pane_text_color,bg=$inactive_pane_border_color"
set -g message-style "fg=$pane_text_color,bg=$pane_background_color"
set -g message-command-style "fg=$pane_text_color,bg=$inactive_pane_border_color"
set -g pane-border-style "fg=$inactive_pane_border_color"
set -g pane-active-border-style "fg=$active_pane_border_color"
set -g status "on"
set -g status-justify "left"
set -g status-style "fg=$pane_text_color,bg=$pane_background_color"
set -g status-left-length "190"
set -g status-right-length "100"
# Nothing on the bar is finer-grained than a minute (the clock renders %I/%M,
# never seconds), so a 3s tick was re-running every probe for no visible gain.
set -g status-interval 5
set -g status-left-style NONE
set -g status-right-style NONE

# Section contents
#
# `#()` already forks a shell, so the old `bash -c` wrapper was a second,
# pointless fork+exec per segment per tick. Every script is executable with a
# shebang, so it is called directly now.
#
# The five notification counters each spawn an AppleScript runtime and walk the
# Dock's Accessibility tree (measured 0.10-0.24s apiece, all firing on the same
# tick). They go through lib/cached.sh, which serves the last value instantly and
# refreshes in the background, so they never sit on the critical path. Badge
# counts do not meaningfully change faster than the 15s TTL.
display_time='#(~/cg-shell/shellscripts/time.sh)'
display_date='#(~/cg-shell/shellscripts/date.sh)'
display_datetime="$display_time $display_date"
display_system_notification_count='#(~/cg-shell/shellscripts/lib/cached.sh 15 system-notification-count.sh)'
display_calendar_notification_count='#(~/cg-shell/shellscripts/lib/cached.sh 15 calendar-notification-count.sh)'
display_mail_notification_count='#(~/cg-shell/shellscripts/lib/cached.sh 15 mail-notification-count.sh)'
display_discord_notification_count='#(~/cg-shell/shellscripts/lib/cached.sh 15 discord-notification.sh)'
display_slack_notification_count='#(~/cg-shell/shellscripts/lib/cached.sh 15 slack-notification-count.sh)'
display_battery_status='#(~/cg-shell/shellscripts/battery.sh)'
display_network_status='#(~/cg-shell/shellscripts/network.sh)'
display_earth_status='#(~/cg-shell/shellscripts/earth.sh)'
display_cpu_status='#(~/cg-shell/shellscripts/cpu.sh)'
display_memory_status='#(~/cg-shell/shellscripts/memory.sh)'

display_left_section_content="$display_network_status "
display_right_section_content="$display_mail_notification_count $display_calendar_notification_count $display_slack_notification_count $display_discord_notification_count $display_cpu_status $display_memory_status $display_battery_status $display_earth_status $display_datetime $display_system_notification_count"


# #W is quoted so a window name containing a space arrives as ONE argument
# rather than being word-split across the script's parameters.
window_name="#(~/cg-shell/shellscripts/iconize-string.sh '#W')"

display_left_section="$display_left_section_content"
display_right_section="$display_right_section_content"

set -g status-left "$display_left_section"
set -g status-right "$display_right_section"

setw -g window-status-activity-style "underscore,fg=$pane_text_color,bg=$pane_background_color"
setw -g window-status-separator ""
setw -g window-status-style "NONE,fg=$pane_text_color,bg=$pane_background_color"

# Window Format
inactive_window_format="#[default]$window_name "
active_window_format="#[fg=$tab_pointer_background_color,bg=$pane_background_color]󰩀$window_name#[fg=$tab_pointer_background_color,bg=$pane_background_color]󰨿 "

setw -g window-status-format "$inactive_window_format"
setw -g window-status-current-format "$active_window_format"
