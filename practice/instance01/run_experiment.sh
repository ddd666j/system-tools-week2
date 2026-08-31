#!/usr/bin/env bash
set -euo pipefail
rm -f heartbeat.log monitor.stderr cleanup.log experiment.log
{
    echo 'INSTANCE01: signal-aware background monitor'
    chmod 750 monitor.sh
    ./monitor.sh >heartbeat.log 2>monitor.stderr &
    monitor_pid=$!
    echo "PID_FROM_SHELL=$monitor_pid"
    sleep 3
    ps -o pid,ppid,stat,etime,cmd -p "$monitor_pid"
    kill -TERM "$monitor_pid"
    wait "$monitor_pid"
    echo "WAIT_EXIT=$?"
    echo '--- cleanup.log ---'
    cat cleanup.log
    echo '--- heartbeat tail ---'
    tail -n 3 heartbeat.log
    echo "STDERR_BYTES=$(wc -c < monitor.stderr)"
    if kill -0 "$monitor_pid" 2>/dev/null; then
        echo 'PROCESS_ALIVE=yes'
        exit 1
    fi
    echo 'PROCESS_ALIVE=no'
} | tee experiment.log
