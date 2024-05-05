#!/bin/bash

## Script to wipe cache, RAM, and swap space (Use with Caution)

# Check if the script is running with sudo privileges
if [ $(id -u) != 0 ]; then
  echo "This script requires root privileges. Please run with sudo."
  exit 1
fi

# Warning message
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
    echo "Aborting..."
    exit 0
    ;;
esac








