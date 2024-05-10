#!/bin/bash
# MAC
# change

export BLUE='\033[1;94m'
export GREEN='\033[1;92m'
export RED='\033[1;91m'
export RESETCOLOR='\033[1;00m'
export notify


if [ $(id -u) != 0 ]; then
    echo "This script requires root privileges. Please run with sudo."
    exit 1
fi

echo -e "${BLUE}Select the Activity you want:"
echo -e "${BLUE}1.${RED} MAC Change"
echo -e "${BLUE}2.${RED} MAC Restore"
echo -e "${BLUE}3.${RED} MAC Status ${RESETCOLOR}"
read -r -p "Enter your choice [1-3]: " choice


case $choice in
    1) echo -e "\n$GREEN*$BLUE Spoofing Mac Address...\n"
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
        # notify "Mac Address Spoofing ON"
        
    ;;
    
    # restore ####
    2)echo -e "\n$GREEN*$BLUE Restoring Mac Address...\n"
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
        
        # notify "Mac Address Spoofing OFF"
        
    ;;
    
    # status ####
    3) echo -e "\n$GREEN*$BLUE Mac Adress Status:\n"
        sleep 1
        echo -e "$GREEN*$BLUE wlan0 Mac Adress:\n"$GREEN
        sleep 1
        macchanger wlan0
        sleep 1
        
    ;;
    *)
        echo -e "\n$GREEN*$RED Wrong Choice "
        exit
        
        
esac


