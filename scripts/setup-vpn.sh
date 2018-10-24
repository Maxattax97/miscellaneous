#!/bin/bash

# Written from instruction found here: http://tldp.org/HOWTO/Adv-Routing-HOWTO/lartc.rpdb.multiple-links.html

## Add these fields to the .ovpn file:
#dev your_tunnel_name_here
#dev-type tun
# Only open a tunnel, do not redirect all traffic.
#pull-filter ignore redirect-gateway
#mute-replay-warnings
#auth-user-pass /home/max/.vpn/login.txt
#script-security 2
#up /home/max/.vpn/setup_vpn.sh
#up-restart

table="nord"
tunnel="$1"
ip_addr="$4"
net_span="${ip_addr}/24"
gateway="$(echo "$ip_addr" | awk -F'[.]' '{ print $1 "." $2 "." $3 "." 1 }')"

echo "Forwarding $ip_addr on $net_span via $gateway ..."

ip route add "$net_span" dev "$tunnel" src "$ip_addr" table "$table" > /dev/null 2>&1
ip route add default via "$gateway" table "$table" > /dev/null 2>&1
ip route add "$net_span" dev "$tunnel" src "$ip_addr" > /dev/null 2>&1
ip rule add from "$ip_addr" table "$table" > /dev/null 2>&1

echo "Routing of table $table complete!"
