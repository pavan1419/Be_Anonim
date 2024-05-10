#!/bin/bash

# Define colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

clear
function IP_Status {
    
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
        get_ip_info
        
    else
        clear
        echo -e "\n${RED}| |----Tor is disabled----| |"
        echo -e "${RED}|___________________________|"
        
        
        echo -e "\n${RED}-${BLUE} Additional IP Info:${RED}"
        info=$(curl -s ipinfo.io/$(echo ${IP})/json)
        echo -e "${GREEN}$info${RESETCOLOR}${RED}"
        
    fi
}

