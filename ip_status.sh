#!/bin/bash

# Define colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

function get_ip_info {
    # Fetch IP address details
    IP=$1
    echo -e "\n${GREEN}*${BLUE} Additional IP Address Information:${NC}"
    
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
    echo -e "${GREEN}Geolocation:${NC} ${city}, ${region}, ${country}, ${postal}"
    echo -e "${GREEN}Latitude:${NC} ${latitude}, ${GREEN}Longitude:${NC} ${longitude}"
    echo -e "${GREEN}ISP:${NC} ${isp}"
    echo -e "${GREEN}Organization:${NC} ${organization}"
}

function status_ip {
    
    echo -e "${BLUE}Select the status you want to check:"
    echo -e "${YELLOW}1.${NC}  IP"
    read -p  "Enter your choice [1-2]: " choice
    
    case $choice in
        1)
            if pgrep tor >/dev/null 2>&1; then
                echo "${GREEN}Tor is enabled"
                echo -e "\n${RED}*${BLUE} Current Tor iP:${RED}"
                # Fetch the current Tor IP using torsocks with curl
                IP=$(torsocks curl -s ifconfig.me)
                echo -e "${RED}${IP}${NC}"
            else
                RED='\033[0;31m'
                echo -e "\n${RED}Tor is disabled"
            fi
            
            echo -e "\n${RED}*${BLUE} Additional IP Info:${RED}"
            info=$(curl -s ipinfo.io/$(echo ${IP})/json)
            echo -e "${RED}${info}${NC}"
        ;;
        *)
            echo -e "${RED}Invalid choice.${NC}"
            return 1
        ;;
    esac
}


status_ip

