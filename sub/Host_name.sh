#!/bin/bash
# hostname
# change

function Change_Hostname {
    clear
    echo -e -n "\n $GREEN Your hostname is$RED $(echo -e "$(hostname)" | tr '[:lower:]' '[:upper:]')"
    echo -e -n "\n $GREEN Wait I am Workign for your Host name..."
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
    echo -e -n "\n $GREEN Your New hostname is$RED $(echo -e "$(hostname)" | tr '[:lower:]' '[:upper:]')"
    #notify "hostname spoofed"
}


function Restore_Hostnam {
    clear
    echo -e -n "\n $GREEN Your hostname is$RED $(echo -e "$(hostname)" | tr '[:lower:]' '[:upper:]')"
    echo -e -n "\n $GREEN Wait I am Restoring on your Host name..."
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
    echo -e -n "\n $GREEN Your Old hostname is$RED $(echo -e "$(hostname)" | tr '[:lower:]' '[:upper:]')"
    #notify "hostname restored"
}
