#!/usr/bin/env bash
set -u

cleanup() {
    printf 'CLEANUP pid=%s last_tick=%s\n' "$$" "$tick" >> cleanup.log
    exit 0
}

trap cleanup TERM INT
tick=0
while true; do
    tick=$((tick + 1))
    printf 'HEARTBEAT pid=%s tick=%s time=%s\n' "$$" "$tick" "$(date +%H:%M:%S)"
    sleep 1
done
