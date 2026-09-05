#!/bin/sh

print_usage() {
    echo "$(basename "$0") [IFACE] [inet|inet6|link]"
}

print_mrtg() {
    IFACE=$1; shift

    NET=$*
    NET_RECV=$(echo "${NET}" | jq '[.statistics.interface[]."received-bytes"] | add')
    NET_SENT=$(echo "${NET}" | jq '[.statistics.interface[]."sent-bytes"] | add')

    UP=$(uptime --libxo=json)
    UP_DAYS=$(echo "${UP}" | jq '."uptime-information".days')
    UP_HOURS=$(echo "${UP}" | jq '."uptime-information".hours')

    echo "${NET_RECV}"
    echo "${NET_SENT}"
    echo "${UP_DAYS} days ${UP_HOURS} hours"
    echo "${IFACE} Network Load"
}

query_inet() {
    IFACE=$1
    INET=$2
    print_mrtg "${IFACE}" "$(netstat -I "${IFACE}" -b -W -n -f "${INET}" --libxo=json)"
}

query_link() {
    IFACE=$1
    print_mrtg "${IFACE}" "$(netstat -I "${IFACE}" -b -W -n --libxo=json | grep Link)"
}

main() {
    if test $# -lt 1
    then
        print_usage
        exit 2
    fi

    IFACE=$1; shift
    INET=${1:-inet}

    case "${INET}" in
        inet | inet6 )
            query_inet "${IFACE}" "${INET}"
            ;;
        link )
            query_link "${IFACE}"
            ;;
        * )
            print_usage
            exit 1
            ;;
    esac
}

main "$@"
