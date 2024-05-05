#!/bin/bash

# Define colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

function get_ip_info {
    # Fetch IP address details
    ip=$1
    echo -e "\n${GREEN}*${BLUE} Additional IP Address Information:${NC}"

    # Fetch geolocation information
    geo=$(curl -s "https://ipapi.co/${ip}/json/")
    country=$(echo "$geo" | jq -r '.country_name')
    city=$(echo "$geo" | jq -r '.city')
    region=$(echo "$geo" | jq -r '.region')
    postal=$(echo "$geo" | jq -r '.postal')
    latitude=$(echo "$geo" | jq -r '.latitude')
    longitude=$(echo "$geo" | jq -r '.longitude')

    # Fetch ISP and Organization information
    whois=$(whois "$ip")
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
    echo -e "${YELLOW}1.${NC} Proxy IP"
    echo -e "${YELLOW}2.${NC} Tor IP"
    read -p "Enter your choice [1-2]: " choice

    case $choice in
        1)
            echo -e "\n${GREEN}*${BLUE} Current Proxy IP:${GREEN}"
            # Fetch the current proxy IP
            ip=$(curl -s icanhazip.com)
            echo -e "${GREEN}${ip}${NC}"
            ;;
        2)
            echo -e "\n${RED}*${BLUE} Current Tor IP:${RED}"
            # Fetch the current Tor IP using torsocks with curl
            ip=$(torsocks curl -s ifconfig.me)
            echo -e "${RED}${ip}${NC}"

            # Fetch additional information about the Tor IP
            echo -e "\n${RED}*${BLUE} Additional Tor IP Info:${RED}"
            # Fetch Tor IP info from ipinfo.io
            info=$(curl -s ipinfo.io/$(echo ${ip})/json)
            # Display relevant information (you can add more if needed)
            echo -e "${RED}${info}${NC}"
            ;;
        *)
            echo -e "${RED}Invalid choice.${NC}"
            return 1
            ;;
    esac
}

# Call the function

status_ip

