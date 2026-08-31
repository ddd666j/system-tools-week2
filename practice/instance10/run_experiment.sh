#!/usr/bin/env bash
set -euo pipefail
rm -rf __pycache__
rm -f numbers.txt numbers_info.txt memory_result.txt experiment.log
{
    echo 'INSTANCE10: tracemalloc read-all versus streaming'
    ../../.venv/bin/python generate_numbers.py
    wc -l -c numbers.txt | tee numbers_info.txt
    echo '--- source comparison ---'
    sed -n '1,120p' memory_profile.py
    echo '--- measured time and peak memory ---'
    ../../.venv/bin/python memory_profile.py | tee memory_result.txt
    grep -q 'same_results=True' memory_result.txt
    grep -q 'read_all_count=200000' memory_result.txt
    echo 'VERIFICATION=passed'
} | tee experiment.log
rm -rf __pycache__
