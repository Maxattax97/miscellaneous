#!/bin/sh

check_dns() {
    domain=$1
    authority=$2
    nameserver=$3

    printf "[1;34m%s[0m" "${authority}"
    dig "$domain" "@${nameserver}"
}

domain="www.maxocull.com"

check_dns "$domain" "Namecheap Free DNS" "dns1.registrar-servers.com"
check_dns "$domain" "Namecheap Premium DNS" "pdns1.registrar-servers.com"
check_dns "$domain" "Google" "8.8.8.8"
check_dns "$domain" "Quad9" "9.9.9.9"
check_dns "$domain" "Cloudflare" "1.1.1.1"
check_dns "$domain" "DuckDNS" "ns1.duckdns.org"
