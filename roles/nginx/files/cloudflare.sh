#!/bin/sh

## Parsing args
##

OUTPUT=$1; shift

if [ -z "$OUTPUT" ]; then
    printf "Usage: %s path/to/cloudflare.conf\\n" "$0" >&2
    exit 1
fi


## Sanity check
##

if [ -x "$(command -v curl)" ]; then
    fetch_url() {
        curl -sfL -o - "$1"
    }
elif [ -x "$(command -v fetch)" ]; then
    fetch_url() {
        fetch -qo - "$1"
    }
else
    printf "%s: expected either fetch or curl to be installed.\\n" "$0" >&2
    exit 1
fi


## Main
##

tmp_dl=$(mktemp)
tmp_conf=$(mktemp)
trap 'rm -f $tmp_dl $tmp_conf' 0 1 2 3 6 14 15

if ! fetch_url "https://www.cloudflare.com/ips-v4" >> "$tmp_dl"; then
    printf "%s: could not fetch cloudflare ipv4 list.\\n" "$0" >&2
    exit 1
fi

printf "\\n" >> "$tmp_dl"

if ! fetch_url "https://www.cloudflare.com/ips-v6" >> "$tmp_dl"; then
    printf "%s: could not fetch cloudflare ipv6 list.\\n" "$0" >&2
    exit 1
fi

printf "\\n" >> "$tmp_dl"

sort -u < "$tmp_dl" | awk '{ print "set_real_ip_from " $1 ";" }' > "$tmp_conf"
printf "real_ip_header CF-Connecting-IP;\\n" >> "$tmp_conf"
mv "$tmp_conf" "$OUTPUT"
chmod 644 "$OUTPUT"
