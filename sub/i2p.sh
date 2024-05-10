#!/bin/bash


function starti2p {
    echo -e -n " $GREEN*$BLUE starting I2P services$RESETCOLOR\n"
    service tor stop
    
    # Modify DNS settings
    if [ "$resolvconf_support" = false ]
    then
        cp /etc/resolv.conf /etc/resolv.conf.bak;
        touch /etc/resolv.conf;
        echo -e 'nameserver 127.0.0.1\nnameserver 209.222.18.222\nnameserver 209.222.18.218' > /etc/resolv.conf;
        echo -e " $GREEN*$BLUE Modified resolv.conf to use localhost and Private Internet Access DNS$RESETCOLOR\n";
    else
        cp /etc/resolvconf/resolv.conf.d/head{,.bak};
        echo -e 'nameserver 127.0.0.1\nnameserver 209.222.18.222\nnameserver 209.222.18.218' >> /etc/resolvconf/resolv.conf.d/head;
        echo -e " $GREEN*$BLUE Modified resolvconf to use localhost and Private Internet Access DNS$RESETCOLOR\n";
        resolvconf -u;
    fi
    sudo -u i2psvc i2prouter start
    sleep 2
    xdg-open 'http://127.0.0.1:7657/home'
}

function stopi2p {
    echo -e -n " $GREEN*$BLUE stopping I2P services\n$RESETCOLOR"
    sudo -u i2psvc i2prouter stop
    
    # restore DNS settings
    if [ "$resolvconf_support" = false ]
    then
        if [ -e /etc/resolv.conf.bak ]; then
            rm /etc/resolv.conf
            cp /etc/resolv.conf.bak /etc/resolv.conf
        fi
    else
        mv /etc/resolvconf/resolv.conf.d/head{.bak,}
        resolvconf -u
    fi
}


function ip_I2P {
    
    echo -e "\nMy ip is:\n"
    sleep 1
    curl "https://ipinfo.io" # Had a few issues with FrozenBox giving me the wrong IP address
    echo -e "\n\n----------------------------------------------------------------------"
}