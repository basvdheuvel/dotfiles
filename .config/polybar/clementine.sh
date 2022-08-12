#!/bin/bash

zscroll -l 50 \
	--delay 0.2 \
	--scroll-padding "  *  " \
	--match-command "playerctl status" \
    --match-text "Stopped" "--before-text \"    not playing \"" \
	--match-text "Playing" "--before-text \"    \"" \
	--match-text "Paused" "--before-text \"    \"" \
	--update-check true "playerctl -s metadata --format '{{ artist }} - {{ album }} - {{ title }}'" &

wait
