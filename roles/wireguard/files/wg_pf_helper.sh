#!/bin/sh
# A simple script to setup pf pass rule for dynamically created network
# interfaces such as wg using pf anchor.
set -e

hook_up() {
    printf "\
icmp6_types=\"{ 128, 133, 134, 135, 136, 137 }\"
pass in on %s inet all
pass in on %s inet6 all
pass in on %s inet6 proto icmp6 all icmp6-type \$icmp6_types keep state
" \
        "$1" "$1" "$1" | pfctl -a "wireguard/$1" -f -
    logger -t "wireguard" "Added pf anchor for $1."
}

hook_down() {
    pfctl -a "wireguard/$1" -F rules
    logger -t "wireguard" "Removed pf anchor for $1."
}

case "$2" in
up) hook_up "$1" ;;
down) hook_down "$1" ;;
*)
    logger -t "wireguard" "Oink. I don't know what to do with $2 on $1."
    exit 1
    ;;
esac
