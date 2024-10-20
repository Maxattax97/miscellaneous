#!/bin/sh

if [ "$(id -u)" -ne 0 ]; then
    exec sudo "$0" "$@"
fi

info() {
    message=$1

    printf "[0;34m%s[0m\n" "${message}"
}

info "Does a deep DNS entry resolve?"
dig www.maxocull.com @9.9.9.9 +tries=1

info "Can we ping it?"
ping -c1 www.maxocull.com

info "Does it supply DNS?"
dig www.maxocull.com @maxocull.com

info "These TCP services should be [1;32mOPEN:"
nmap -sS -p 22,80,443 maxocull.com --dns-servers 9.9.9.9

info "These UDP services should be [1;32mOPEN:"
nmap -sU -p 443,1194,51820 maxocull.com --dns-servers 9.9.9.9

info "These TCP services should be [1;31mCLOSED:"
nmap -sS -p 81,5432 maxocull.com --dns-servers 9.9.9.9
nmap -sU -p 5432 maxocull.com --dns-servers 9.9.9.9

info "Is it serving my webpage?"
curl -L 'https://maxocull.com' | grep '<title>' | head -n1

info "Does SSH on 22/tcp reach Entourage?"
ssh entourage "hostname"

info "Does SSH on 2212/tcp reach git.alanocull.com?"
ssh git.alanocull.com "hostname"

info "Does the router supply NTP?"
chronyc ntpdata -s maxocull.com

# TODO: Does the router supply NTS?
# ...
