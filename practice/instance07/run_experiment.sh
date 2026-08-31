#!/usr/bin/env bash
set -euo pipefail
rm -rf .pytest_cache __pycache__
rm -f buggy_output.txt pdb_session.txt minimal_fix.diff pytest_final.txt experiment.log
cp binary_search_buggy.py binary_search.py
{
    echo 'INSTANCE07: PDB locates binary-search boundary defect'
    ../../.venv/bin/python binary_search.py | tee buggy_output.txt
    echo 'EXPECTED_INDEX=4'
    echo '--- pdb observation ---'
    ../../.venv/bin/python -m pdb binary_search.py <pdb_commands.txt >pdb_session.txt 2>&1 || true
    cat pdb_session.txt
    cp binary_search.py binary_search_actual_buggy.tmp
    sed -i 's/while low < high:/while low <= high:/' binary_search.py
    diff -u binary_search_actual_buggy.tmp binary_search.py >minimal_fix.diff || true
    rm binary_search_actual_buggy.tmp
    echo '--- minimal fix ---'
    cat minimal_fix.diff
    echo '--- final tests ---'
    ../../.venv/bin/pytest -q | tee pytest_final.txt
    grep -q '5 passed' pytest_final.txt
    echo 'VERIFICATION=passed'
} | tee experiment.log
rm -rf .pytest_cache __pycache__
