#!/bin/bash

export BLUE='\033[1;94m'
export GREEN='\033[1;92m'
export RED='\033[1;91m'
export RESETCOLOR='\033[1;00m'
export notify


if [ $(id -u) != 0 ]; then
    echo "This script requires root privileges. Please run with sudo."
    exit 1
fi


function reset {
    echo -e "${RED}$(echo -e "|--$(hostname)--|" | tr '[:lower:]' '[:upper:]')${GREEN} Are you sure you want to continue? (y/N)"
    read -r -p "" response
    case "$response" in
        [Yy])
            main
        ;;
        [Nn])
            clear
            exit
        ;;
    esac
}

host=$(hostname)


function main  {
    host
    
    clear
    echo -e "${BLUE}Select the Activity you want:"
    echo -e "${BLUE}1.${RED} IP Status"
    echo -e "${BLUE}2.${RED} Mac Address"
    echo -e "${BLUE}3.${RED} Host Name"
    echo -e "${BLUE}4.${RED} Proxy(tor,i2p)"
    echo -e "${BLUE}5.${RED} Wipe"
    echo -e "${BLUE}0.${RED} Exit  ${RESETCOLOR}"
    
    read -r -p "Enter your choice [1-3]: " choice
    
    
    case $choice in
        1)
            clear
            function get_ip_info {
                # Fetch IP address details
                IP=$1
                echo -e "\n${GREEN}*${BLUE} Additional IP Address Information:${RESETCOLOR}"
                
                # Fetch geolocation information
                geo=$(curl -s "https://ipapi.co/${IP}/json/")
                country=$(echo "$geo" | jq -r '.country_name')
                city=$(echo "$geo" | jq -r '.city')
                region=$(echo "$geo" | jq -r '.region')
                postal=$(echo "$geo" | jq -r '.postal')
                latitude=$(echo "$geo" | jq -r '.latitude')
                longitude=$(echo "$geo" | jq -r '.longitude')
                
                # Fetch ISP and Organization information
                whois=$(whois "$IP")
                isp=$(echo "$whois" | grep -i "OrgName" | awk -F':' '{print $2}' | sed 's/^ *//g')
                organization=$(echo "$whois" | grep -i "ISP" | awk -F':' '{print $2}' | sed 's/^ *//g')
                
                # Display gathered information
                echo -e "${GREEN}Geolocation:${RESETCOLOR} ${city}, ${region}, ${country}, ${postal}"
                echo -e "${GREEN}Latitude:${RESETCOLOR} ${latitude}, ${GREEN}Longitude:${RESETCOLOR} ${longitude}"
                echo -e "${GREEN}ISP:${RESETCOLOR} ${isp}"
                echo -e "${GREEN}Organization:${RESETCOLOR} ${organization}"
            }
            
            if pgrep tor >/dev/null 2>&1; then
                clear
                echo "${GREEN}Tor is enabled"
                echo -e "\n${RED}*${BLUE} Current Tor iP:${RED}"
                # Fetch the current Tor IP using torsocks with curl
                IP=$(torsocks curl -s ifconfig.me)
                echo -e "${RED}${IP}${RESETCOLOR}"
            else
                clear
                echo -e "\n${RED}| |----Tor is disabled----| |"
                echo -e "${RED}|___________________________|"
                
                
                echo -e "\n${RED}-${BLUE} Additional IP Info:${RED}"
                info=$(curl -s ipinfo.io/$(echo ${IP})/json)
                echo -e "${GREEN}$info${RESETCOLOR}${RED}"
                reset
            fi
            
            
        ;;
        2)
            clear
            echo -e "${BLUE}Select the Activity you want:"
            echo -e "${BLUE}1.${RED} MAC Change"
            echo -e "${BLUE}2.${RED} MAC Restore"
            echo -e "${BLUE}3.${RED} MAC Status "
            echo -e "${BLUE}4.${RED} Back ${RESETCOLOR}"
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
                    reset
                    # notify "Mac Address Spoofing ON"
                    
                ;;
                
                # restore ####
                2)
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
                    
                ;;
                
                # status ####
                3)
                    clear
                    echo -e "\n$GREEN*$BLUE Mac Adress Status:\n"
                    sleep 1
                    echo -e "$GREEN*$BLUE wlan0 Mac Adress:\n"$GREEN
                    sleep 1
                    macchanger wlan0
                    sleep 1
                    
                ;;
                4)
                    main
                ;;
                *)
                    clear
                    echo -e "\n$GREEN*$RED Wrong Choice ${RESETCOLOR} "
                    reset
                    
                    
            esac
            
            
        ;;
        
        #host Name
        3)
            clear
            echo -e "${BLUE}Select the Activity you want:"
            echo -e "${BLUE}1.${RED} Hostname Change"
            echo -e "${BLUE}2.${RED} Hostname Restore"
            echo -e "${BLUE}3.${RED} Hostname Status "
            echo -e "${BLUE}4.${RED} Back ${RESETCOLOR}"
            read -r -p "Enter your choice [1-3]: " choice
            
            
            case $choice in
                1)
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
                ;;
                
                # restore ####
                2)
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
                ;;
                
                # status ####
                3)
                    clear
                    echo -e -n "\n $GREEN Your hostname is$RED $(echo -e "$(hostname)" | tr '[:lower:]' '[:upper:]')"
                    exit
                ;;
                4)
                    main
                ;;
                *)
                    clear
                    echo -e "\n$GREEN*$RED Wrong Choice ${RESETCOLOR} "
                    reset
                    
                    
            esac
            
        ;;
        #proxy(tor,i2p)
        4)
            
            
            
        ;;
        5)
            
            echo "**WARNING:** This script aggressively wipes cache, RAM, and swap space."
            read -r -p "Are you sure you want to continue? (y/N) " response
            case "$response" in
                [yY])
                    
                    ## Function to wipe cache, RAM, and swap space
                    function wipe {
                        # Get Memory Information
                        freemem_before=$(cat /proc/meminfo | grep MemFree | tr -s ' ' | cut -d ' ' -f2) && freemem_before=$(echo "$freemem_before/1024.0" | bc)
                        cachedmem_before=$(cat /proc/meminfo | grep "^Cached" | tr -s ' ' | cut -d ' ' -f2) && cachedmem_before=$(echo "$cachedmem_before/1024.0" | bc)
                        
                        # Output Information
                        echo  -e "\nAt the moment you have $cachedmem_before MiB cached and $freemem_before MiB free memory."
                        
                        
                        # Clear Filesystem Buffer using "sync" and Clear Caches
                        echo -e "now wiping cache, ram, & swap-space...\n"
                        echo "Started is dropping caches"
                        sleep 1
                        sync; echo 3 > /proc/sys/vm/drop_caches
                        echo 1024 > /proc/sys/vm/min_free_kbytes
                        echo 3  > /proc/sys/vm/drop_caches
                        echo 1  > /proc/sys/vm/oom_kill_allocating_task
                        echo 1  > /proc/sys/vm/overcommit_memory
                        echo 0  > /proc/sys/vm/oom_dump_tasks
                        swapoff -a && swapon -a
                        sleep 1
                        echo -e "Cache, ram & swap-space [CLEANED]"
                        freemem_after=$(cat /proc/meminfo | grep MemFree | tr -s ' ' | cut -d ' ' -f2) && freemem_after=$(echo "$freemem_after/1024.0" | bc)
                        
                        # Output Summary
                        echo -e "This freed $(echo "$freemem_after - $freemem_before" | bc) MiB, so now you have $freemem_after MiB of free RAM."
                        
                    }
                    wipe
                ;;
                *)
                    echo -e "${RED}Aborting..."
                    sleep 2
                    reset
                ;;
            esac
            
        ;;
        0)
            exit 0
            clear
            echo -e "${RED}Aborting..."
            sleep 2
            reset
        ;;
        *)
            clear
            echo -e "\n$GREEN*$RED Wrong Choice ${RESETCOLOR} "
            reset
            
            
    esac
}
main $host