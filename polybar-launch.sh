#!/usr/bin/env bash

# Terminate already running bar instances
killall -q polybar
# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done
set -x
if type "xrandr"; then
  for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    if [ $(xrandr --query | grep " connected" -c) -eq 2 ]; then
      if [ $m == 'HDMI1' ]; then
        TRAY_POS=right MONITOR=$m polybar --reload top &
      else
        MONITOR=$m polybar --reload top &
      fi
    else
      TRAY_POS=right MONITOR=$m polybar --reload top &
    fi
    MONITOR=$m polybar --reload bottom &
  done
else
  polybar --reload -l info top &
  polybar --reload -l info bottom &
fi
# Launch bar1 and bar2

echo "Bars launched..."
