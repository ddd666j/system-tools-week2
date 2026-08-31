#!/usr/bin/env bash
set -u
rm -f default_count.txt pipefail_count.txt default.stderr pipefail.stderr experiment.log
{
    echo 'INSTANCE03: pipeline exit status and pipefail'
    chmod 750 producer.sh

    echo '--- default pipeline ---'
    set +o pipefail
    ./producer.sh 2>default.stderr | wc -l >default_count.txt
    default_status=$?
    echo "DEFAULT_PIPELINE_STATUS=$default_status"
    echo "DEFAULT_COUNT=$(cat default_count.txt)"
    echo "DEFAULT_STDERR=$(cat default.stderr)"

    echo '--- pipeline with pipefail ---'
    set -o pipefail
    ./producer.sh 2>pipefail.stderr | wc -l >pipefail_count.txt
    pipefail_status=$?
    set +o pipefail
    echo "PIPEFAIL_STATUS=$pipefail_status"
    echo "PIPEFAIL_COUNT=$(cat pipefail_count.txt)"
    echo "PIPEFAIL_STDERR=$(cat pipefail.stderr)"

    test "$default_status" -eq 0
    test "$pipefail_status" -eq 7
    echo 'VERIFICATION=passed'
} | tee experiment.log
