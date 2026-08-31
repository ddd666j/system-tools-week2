#!/usr/bin/env bash
set -euo pipefail
rm -rf __pycache__
rm -f profile_original.txt benchmark_result.txt code_change.diff experiment.log
{
    echo 'INSTANCE08: profile and optimize recursive Fibonacci'
    echo '--- cProfile ordered by cumulative time ---'
    ../../.venv/bin/python -m cProfile -s cumulative fib_original.py >profile_original.txt
    sed -n '1,18p' profile_original.txt
    echo '--- optimization diff ---'
    diff -u fib_original.py fib_optimized.py >code_change.diff || true
    cat code_change.diff
    echo '--- repeated timing and correctness ---'
    ../../.venv/bin/python benchmark.py | tee benchmark_result.txt
    grep -q 'same_results=True' benchmark_result.txt
    grep -q 'result=2178309' benchmark_result.txt
    echo 'VERIFICATION=passed'
} | tee experiment.log
rm -rf __pycache__
