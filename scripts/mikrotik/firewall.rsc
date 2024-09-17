##################
# RESET FIREWALL #
##################
/ip firewall filter remove [find]
/ip firewall nat remove [find]
/ip firewall mangle remove [find]
/ip firewall raw remove [find]

##########
# FILTER #
##########
/ip/firewall/filter

# TODO: Label ether1 as WAN.

add chain=forward in-interface=ether1 connection-state=new connection-nat-state=dstnat action=accept comment="Accept new forwarding connections from WAN"
add chain=input in-interface=ether1 connection-state=new connection-nat-state=dstnat action=accept comment="Accept new input connections from WAN"
add chain=input in-interface=ether1 connection-state=established,related,untracked action=accept comment="Accept established, related, and untracked input connections from WAN"
add chain=input connection-state=invalid action=drop comment="Drop invalid input connections"

add chain=input protocol=icmp in-interface=ether1 action=accept comment="Allow ICMP"
add chain=input protocol=tcp in-interface=ether1 any-port=8291 action=accept comment="Allow Winbox"
add chain=input protocol=udp dst-port=123 action=accept comment="Allow NTP"
add chain=input in-interface=ether1 action=drop comment="Drop all other input traffic"

# TODO: Move this rule near top?
add chain=forward connection-state=established,related action=fasttrack-connection hw-offload=yes comment="Fasttrack established and related connections"

add chain=forward connection-state=established,related action=accept comment="Accept established and related forwarding connections"
add chain=forward connection-state=invalid action=drop comment="Drop invalid forwarding connections"
add chain=forward in-interface=ether1 connection-state=new connection-nat-state=!dstnat action=drop comment="Drop new forwarding connections from WAN"

# Guidelines
# - Skip IPv6
# - Restrict TCP/UDP ports specifically (one or the other, not both)
# - Sort them
# - Create separate chains for each host?
#
# 22/tcp; SSH
# 80/tcp; HTTP
# 443/tcp; HTTPS
# 443/udp; HTTP/3
# 1194/udp; OpenVPN
# 25565/tcp; Minecraft Server 1
# 25566/tcp; Minecraft Server 2
# 27015/tcp; Valve
# 27015/udp; Valve
# 51820/udp; WireGuard
#
# Private:
# 81/tcp; SWAG Dashboard
# 5432/tcp; PostgreSQL
# 5432/udp; PostgreSQL
#
# Unknown, TCP or UDP:
# 6881/tcp; BitTorrent
# 111/tcp; NFSv3 (private)
# 2049/tcp; NFSv3 (private)
#
# Unknown:
# 18080/tcp; Service 18080
# 18081/tcp; Service 18081
# 8443/tcp; HTTPS Alt
# 2049/tcp; NFS
# 32765/tcp; RPC
# 32767/tcp; RPC

# Allow SSH (IPv4)
add chain=input protocol=tcp dst-port=22 action=accept comment="Allow SSH"

# Allow mDNS (IPv4)
add chain=input protocol=udp dst-address=224.0.0.251 dst-port=5353 action=accept comment="Allow mDNS"

# Limit SSH (IPv4)
add chain=input protocol=tcp dst-port=22 connection-state=new action=jump jump-target=limit-ssh
add chain=limit-ssh connection-state=new action=add-src-to-address-list address-list=ssh_blacklist address-list-timeout=1d
add chain=limit-ssh connection-state=new src-address-list=ssh_blacklist action=drop

# Allow specific ports (IPv4)
add chain=input protocol=tcp dst-port=25 action=accept comment="Allow SMTP"
add chain=input protocol=udp dst-port=53 action=accept comment="Allow DNS"
add chain=input protocol=udp dst-port=67 action=accept comment="Allow DHCP"
add chain=input protocol=tcp dst-port=80 action=accept comment="Allow HTTP"
add chain=input protocol=tcp dst-port=443 action=accept comment="Allow HTTPS"
add chain=input protocol=udp dst-port=1194 action=accept comment="Allow OpenVPN"
add chain=input protocol=tcp dst-port=6881 action=accept comment="Allow BitTorrent"
add chain=input protocol=tcp dst-port=25565 action=accept comment="Allow Minecraft Server 1"
add chain=input protocol=tcp dst-port=25566 action=accept comment="Allow Minecraft Server 2"
add chain=input protocol=tcp dst-port=27015 action=accept comment="Allow Game Server"
add chain=input protocol=udp dst-port=51820 action=accept comment="Allow WireGuard"
add chain=input protocol=tcp dst-port=18080 action=accept comment="Allow Service 18080"
add chain=input protocol=tcp dst-port=18081 action=accept comment="Allow Service 18081"
add chain=input protocol=tcp dst-port=8443 action=accept comment="Allow HTTPS Alt"
add chain=input protocol=tcp dst-port=5432 action=accept comment="Allow PostgreSQL"
add chain=input protocol=tcp dst-port=2049 action=accept comment="Allow NFS"
add chain=input protocol=tcp dst-port=111 action=accept comment="Allow Portmapper"
add chain=input protocol=tcp dst-port=32765 action=accept comment="Allow RPC"
add chain=input protocol=tcp dst-port=32767 action=accept comment="Allow RPC"
add chain=input protocol=tcp dst-port=81 action=accept comment="Allow HTTP Alt"

# Allow specific ports (IPv6)
add chain=input protocol=tcp dst-port=22 action=accept comment="Allow SSH (v6)"
add chain=input protocol=udp dst-address=ff02::fb dst-port=5353 action=accept comment="Allow mDNS (v6)"
add chain=input protocol=tcp dst-port=25 action=accept comment="Allow SMTP (v6)"
add chain=input=protocol=udp dst-port=53 action=accept comment="Allow DNS (v6)"
add chain=input protocol=udp dst-port=67 action=accept comment="Allow DHCP (v6)"
add chain=input protocol=tcp dst-port=80 action=accept comment="Allow HTTP (v6)"
add chain=input protocol=tcp dst-port=443 action=accept comment="Allow HTTPS (v6)"
add chain=input protocol=udp dst-port=1194 action=accept comment="Allow OpenVPN (v6)"
add chain=input protocol=tcp dst-port=6881 action=accept comment="Allow BitTorrent (v6)"
add chain=input protocol=tcp dst-port=25565 action=accept comment="Allow Minecraft Server 1 (v6)"
add chain=input protocol=tcp dst-port=25566 action=accept comment="Allow Minecraft Server 2 (v6)"
add chain=input protocol=tcp dst-port=27015 action=accept comment="Allow Game Server (v6)"
add chain=input protocol=udp dst-port=51820 action=accept comment="Allow WireGuard (v6)"
add chain=input protocol=tcp dst-port=18080 action=accept comment="Allow Service 18080 (v6)"
add chain=input protocol=tcp dst-port=18081 action=accept comment="Allow Service 18081 (v6)"
add chain=input protocol=tcp dst-port=8443 action=accept comment="Allow HTTPS Alt (v6)"
add chain=input protocol=tcp dst-port=5432 action=accept comment="Allow PostgreSQL (v6)"
add chain=input protocol=tcp dst-port=2049 action=accept comment="Allow NFS (v6)"
add chain=input protocol=tcp dst-port=111 action=accept comment="Allow Portmapper (v6)"
add chain=input protocol=tcp dst-port=32765 action=accept comment="Allow RPC (v6)"
add chain=input protocol=tcp dst-port=32767 action=accept comment="Allow RPC (v6)"
add chain=input protocol=tcp dst-port=81 action=accept comment="Allow HTTP Alt (v6)"

# Drop everything else
add chain=input action=drop comment="Drop all other traffic"

# TODO: What traffic might I want to log?

#####################################
# NETWORK ADDRESS TRANSLATION (NAT) #
#####################################
/ip/firewall/nat

# TODO: These should probably be input rules way sooner.
add chain=dstnat protocol=udp dst-port=123 action=accept comment="Allow NTP"
add chain=dstnat protocol=tcp dst-port=4460 action=accept comment="Allow NTS"

# TODO: Shouldn't this be using
add chain=srcnat src-address-list=list_wireguard out-interface=ether1 action=masquerade comment="Masquerade WireGuard traffic"

# TODO: This seems wrong...
add chain=srcnat out-interface=ether1 action=masquerade comment="Masquerade all other traffic"

# TODO: point this to Alan's local port 22?
# to-ports=22
add chain=dstnat protocol=tcp dst-port=2212 in-interface=ether1 action=dst-nat to-addresses=192.168.1.12 comment="Redirect 2212 to git.alanocull.com for SSH"

# TODO: Get rid of these port ignores...
add chain=dstnat protocol=udp dst-port=!123,13221-13230 in-interface=ether1 action=dst-nat to-addresses=192.168.1.10 comment="Redirect all other UDP traffic to default device (maxocull.com)"
add chain=dstnat protocol=tcp dst-port=!4460 in-interface=ether1 action=dst-nat to-addresses=192.168.1.10 comment="Redirect all other TCP traffic to default device (maxocull.com)"

##########
# MANGLE #
##########

#######
# RAW #
#######
