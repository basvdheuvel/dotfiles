#!/bin/bash

zscroll -l 50 \
	--delay 0.2 \
	--scroll-padding "  *  " \
	--match-command "playerctl metadata clementine --format '{{ status }}'" \
	--match-text "Playing" "--before-text \"    \"" \
	--match-text "Paused" "--before-text \"    \"" \
	--update-check true "playerctl metadata clementine --format '{{ artist }} - {{ album }} - {{ title }}'" &

wait
