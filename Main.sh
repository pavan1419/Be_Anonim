#!/bin/bash

source sub/i2p.sh
source sub/ip_status.sh
source sub/wipe.sh
source sub/tor
source sub/Mac.sh
source sub/Host_name.sh

export BLUE='\033[1;94m'
export GREEN='\033[1;92m'
export RED='\033[1;91m'
export RESETCOLOR='\033[1;00m'
export notify

# Destinations you don't want routed through Tor
TOR_EXCLUDE="192.168.0.0/16 172.16.0.0/12 10.0.0.0/8"

# The UID Tor runs as
# change it if, starting tor, the command 'ps -e | grep tor' returns a different UID
TOR_UID="debian-tor"

# Tor's TransPort
TOR_PORT="9040"


if [ $(id -u) != 0 ]; then
    echo "This script requires root privileges. Please run with sudo."
    exit 1
fi


function reset {
    echo -e "\n${RED}$(echo -e "|--$(hostname)--|" | tr '[:lower:]' '[:upper:]')${GREEN} Are you sure you want to continue? (y/N)"
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
    echo -e "${BLUE}4.${RED} tor"
    echo -e "${BLUE}5.${RED} I2P Proxy"
    echo -e "${BLUE}6.${RED} Wipe"
    echo -e "${BLUE}0.${RED} Exit  ${RESETCOLOR}"
    
    read -r -p "Enter your choice [1-3]: " choice
    
    
    case $choice in
        1)
            
            IP_Status
            reset
            
            
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
                1)
                    
                    Change_Mac
                    reset
                ;;
                
                # restore ####
                2)
                    Restor_Mac
                    reset
                ;;
                
                # status ####
                3)
                    
                    
                    Mac_Status
                    reset
                    
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
                    
                    Change_Hostname
                    reset
                ;;
                
                # restore ####
                2)
                    
                    Restore_Hostnam
                    reset
                ;;
                
                # status ####
                3)
                    clear
                    echo -e -n "\n $GREEN Your hostname is$RED $(echo -e "$(hostname)" | tr '[:lower:]' '[:upper:]')"
                    reset
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
        #tor
        4)
            
            clear
            echo -e "${BLUE}Select the Activity you want:"
            echo -e "${BLUE}1.${RED} TOR Start"
            echo -e "${BLUE}2.${RED} TOR Stop"
            echo -e "${BLUE}3.${RED} TOR Change "
            echo -e "${BLUE}4.${RED} TOR Status "
            echo -e "${BLUE}0.${RED} Back ${RESETCOLOR}"
            read -r -p "Enter your choice [1-3]: " choice
            
            
            case $choice in
                1)
                    tor_start
                    reset
                ;;
                2)
                    Tor_stop
                    reset
                ;;
                3)
                    tor_change
                    reset
                ;;
                4)
                    IP_Status
                    reset
                ;;
                0)
                    main
                ;;
            esac
        ;;
        #I2P
        5)
            clear
            echo -e "${BLUE}Select the Activity you want:"
            echo -e "${BLUE}1.${RED} I2P Start"
            echo -e "${BLUE}2.${RED} I2P Stop"
            echo -e "${BLUE}3.${RED} I2P Status "
            echo -e "${BLUE}0.${RED} Back ${RESETCOLOR}"
            read -r -p "Enter your choice [1-3]: " choice
            
            
            case $choice in
                1)
                    starti2p
                    reset
                ;;
                2)
                    stopi2p
                    reset
                ;;
                3)
                    IP_Status
                    reset
                ;;
                0)
                    main
                ;;
            esac
        ;;
        6)
            
            echo "**WARNING:** This script aggressively wipes cache, RAM, and swap space."
            read -r -p "Are you sure you want to continue? (y/N) " response
            case "$response" in
                [yY])
                    
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