#!/usr/bin/env bash
set -euo pipefail
rm -rf __pycache__
rm -f benchmark_result.txt experiment.log
{
    echo 'INSTANCE09: timeit list versus set membership'
    echo '--- benchmark source ---'
    sed -n '1,120p' membership_benchmark.py
    echo '--- repeated measurements ---'
    ../../.venv/bin/python membership_benchmark.py | tee benchmark_result.txt
    grep -q 'same_results=True' benchmark_result.txt
    echo 'VERIFICATION=passed'
} | tee experiment.log
rm -rf __pycache__
