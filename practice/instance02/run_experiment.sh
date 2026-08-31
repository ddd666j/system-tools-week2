#!/usr/bin/env bash
set -euo pipefail
rm -f worker.log worker.stderr experiment.log
{
    echo 'INSTANCE02: inspect and adjust process priority'
    nice -n 10 python3 cpu_worker.py >worker.log 2>worker.stderr &
    worker_pid=$!
    echo "PID_FROM_SHELL=$worker_pid"
    sleep 2
    echo '--- initial process state ---'
    ps -o pid,ppid,ni,pri,stat,pcpu,etime,cmd -p "$worker_pid"
    echo '--- adjust niceness 10 -> 15 ---'
    renice 15 -p "$worker_pid"
    ps -o pid,ni,pri,stat,pcpu,etime,cmd -p "$worker_pid"
    kill -TERM "$worker_pid"
    wait "$worker_pid"
    echo "WAIT_EXIT=$?"
    echo '--- worker output ---'
    cat worker.log
    echo "STDERR_BYTES=$(wc -c < worker.stderr)"
    if kill -0 "$worker_pid" 2>/dev/null; then
        echo 'PROCESS_ALIVE=yes'
        exit 1
    fi
    echo 'PROCESS_ALIVE=no'
} | tee experiment.log
