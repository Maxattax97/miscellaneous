#!/bin/sh

if [ "$(id -u)" -ne 0 ]; then
    exec sudo "$0" "$@"
fi

info() {
    message=$1

    printf "[0;34m%s[0m\n" "${message}"
}

info "Does a deep DNS entry resolve?"
dig www.maxocull.com @192.168.1.1 +tries=1

info "Can we ping it?"
ping -c1 www.maxocull.com

info "Does the router supply DNS?"
dig dns.quad9.net @192.168.1.1

info "Do local DNS entries resolve?"
dig leviathan @192.168.1.1

info "These Mikrotik TCP services should be [1;32mOPEN:"
nmap -sS -p 22,80 192.168.1.1

info "These Entourage TCP services should be [1;32mOPEN:"
nmap -sS -p 22,80,443 192.168.1.10

info "Is it serving my webpage?"
curl -L 'https://maxocull.com' | grep '<title>' | head -n1

info "Does SSH on 22/tcp reach Entourage?"
ssh entourage "hostname"

info "Does SSH on 2212/tcp reach git.alanocull.com?"
ssh git.alanocull.com "hostname"

info "Does the router supply NTP?"
chronyc ntpdata 192.168.1.1

# TODO: Does the router supply NTS?
# ...
