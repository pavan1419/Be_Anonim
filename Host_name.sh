#!/bin/bash
# hostname
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
echo -e "${BLUE}1.${RED} Hostname Change"
echo -e "${BLUE}2.${RED} Hostname Restore"
echo -e "${BLUE}3.${RED} Hostname Status ${RESETCOLOR}"
read -r -p "Enter your choice [1-3]: " choice


case $choice in
    1)
        cp /etc/hostname /etc/hostname.bak
        cp /etc/hosts /etc/hosts.bak
        service NetworkManager stop
        dhclient -r
        rm -f /var/lib/dhcp/dhclient*
        RANDOM_HOSTNAME=$(shuf -n 1 /etc/dictionaries-common/words | sed -r 's/[^a-zA-Z]//g' | awk '{print tolower($0)}')
        NEW_HOSTNAME=${1:-$RANDOM_HOSTNAME}
        echo "$NEW_HOSTNAME" > /etc/hostname
        sudo sed -i 's/127.0.1.1.*/127.0.1.1\t'"$NEW_HOSTNAME"'/g' /etc/hosts
        service NetworkManager start
        sleep 5
        echo -e -n "\n $GREEN Your hostname is$RED $(echo -e "$(hostname)" | tr '[:lower:]' '[:upper:]')"
        #notify "hostname spoofed"
    ;;
    
    # restore ####
    2)
        service NetworkManager stop
        dhclient -r
        sudo rm -f /var/lib/dhcp/dhclient*
        if [ -e /etc/hostname.bak ]; then
            sudo rm /etc/hostname
            sudo cp /etc/hostname.bak /etc/hostname
        fi
        if [ -e /etc/hosts.bak ]; then
            sudo rm /etc/hosts
            sudo cp /etc/hosts.bak /etc/hosts
        fi
        service NetworkManager start
        sleep 5
        echo -e -n "\n $GREEN Your hostname is$RED $(echo -e "$(hostname)" | tr '[:lower:]' '[:upper:]')"
        #notify "hostname restored"
    ;;
    
    # status ####
    3)
        echo -e -n "\n $GREEN Your hostname is$RED $(echo -e "$(hostname)" | tr '[:lower:]' '[:upper:]')"
        exit
    ;;
    *)
        echo -e "\n$GREEN*$RED Wrong Choice "
        exit
        
        
esac
