#!/bin/bash

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Set colors
export BAR_FG_ALT="#666"
export BAR_ETH_LABEL="%{F$BAR_FG_ALT}%{F-} %upspeed% %{F$BAR_FG_ALT}%{F-} %downspeed%"

# Launch Polybar, using default config location ~/.config/polybar/config
polybar left &
polybar right &
