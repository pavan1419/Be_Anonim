#!/bin/bash
# MAC
# change

function Change_Mac {
    clear
    echo -e "\n$GREEN*$BLUE Spoofing Mac Address...\n"
    sudo service NetworkManager stop
    sleep 1
    echo -e "$GREEN*$BLUE wlan0 MAC address:\n"$GREEN
    sleep 1
    sudo ifconfig wlan0 down
    sleep 1
    sudo macchanger -a wlan0
    sleep 1
    sudo ifconfig wlan0 up
    sleep 1
    sudo service NetworkManager start
    echo -e "\n$GREEN*$BLUE Mac Address Spoofing$GREEN [ON]"$RESETCOLOR
    sleep 1
    reset
    # notify "Mac Address Spoofing ON"
}


function Restor_Mac {
    clear
    echo -e "\n$GREEN*$BLUE Restoring Mac Address...\n"
    sudo service NetworkManager stop
    sleep 1
    echo -e "$GREEN*$BLUE wlan0 MAC address:\n"$GREEN
    sleep 1
    sudo ifconfig wlan0 down
    sleep 1
    sudo macchanger -p wlan0
    sleep 1
    sudo ifconfig wlan0 up
    sleep 1
    sudo service NetworkManager start
    sleep 1
    echo -e "\n$GREEN*$BLUE Mac Address Spoofing$RED [OFF]"$RESETCOLOR
    sleep 1
    reset
    
    # notify "Mac Address Spoofing OFF"
}


function Mac_Status {
    clear
    echo -e "\n$GREEN*$BLUE Mac Adress Status:\n"
    sleep 1
    echo -e "$GREEN*$BLUE wlan0 Mac Adress:\n"$GREEN
    sleep 1
    macchanger wlan0
    sleep 1
}