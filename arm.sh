#!/bin/bash

function start_arm {
		echo -e "\n$GREEN*$BLUE Starting Anonymizing Relay Monitor (arm)..." $RESETCOLOR
		xhost +
		sleep 1
		DISPLAY=:0.0 gnome-terminal -e "sudo arm"
		sleep 1
}
