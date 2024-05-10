#!/bin/bash

## Function to wipe cache, RAM, and swap space
function wipe {
    
    echo -e "\n$GREEN*$BLUE Killing dangerous applications and cleaning some cache elements...\n"$RESETCOLOR
    sleep 1
    killall -q chrome dropbox iceweasel skype icedove thunderbird firefox-esr firefox chromium xchat transmission kvirc pidgin hexchat # feel free to add your own internet connected app
    sleep 1
    bleachbit -c adobe_reader.cache chromium.cache chromium.current_session chromium.history elinks.history emesene.cache epiphany.cache firefox.url_history flash.cache flash.cookies google_chrome.cache google_chrome.history  links2.history opera.cache opera.search_history opera.url_history &> /dev/null
    sleep 1
    echo -e "$GREEN*$BLUE Dangerous applications$GREEN [KILLED]\n"
    sleep 1
    
    
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








