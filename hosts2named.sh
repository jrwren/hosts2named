#!/bin/bash

if [[ "$1" == "setup" ]]; then
    echo "setup will create the right files and change their ownership and append to"
    echo "/etc/bind/named.conf.local"
    sudo touch /etc/bind/named.conf.mvps
    echo 'include "/etc/bind/named.conf.mvps";' | sudo tee -a /etc/bind/named.conf.local
    exit 0
fi

if [[ "$(curl http://winhelp2002.mvps.org/hosts.zip -z hosts.zip -o hosts.zip -s -L -w %{http_code})" == "200" ]]; then
  unzip hosts.zip
fi

cat HOSTS | awk '
/^127.0.0.1/ {
    gsub(//,"", $2)
    if($2=="localhost") next;
    print "zone "$2" { type master; file \"/etc/bind/db.local\";};"
}' > /etc/bind/named.conf.mvps

sudo rndc reload
