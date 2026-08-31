#!/usr/bin/env bash
set -euo pipefail
rm -rf .pytest_cache __pycache__
rm -f pytest_before.txt pytest_before_exit.txt pytest_final.txt minimal_fix.diff experiment.log
cp username_buggy.py username.py
{
    echo 'INSTANCE06: parameterized pytest and minimal boundary fix'
    echo '--- reproduce failure ---'
    set +e
    ../../.venv/bin/pytest -q >pytest_before.txt 2>&1
    before_exit=$?
    set -e
    cat pytest_before.txt
    echo "$before_exit" >pytest_before_exit.txt
    echo "PYTEST_BEFORE_EXIT=$before_exit"

    echo '--- apply minimal fix ---'
    cp username_buggy.py username_actual_buggy.tmp
    sed -i 's/if value == "":/if not value.strip():/' username.py
    diff -u username_actual_buggy.tmp username.py >minimal_fix.diff || true
    rm username_actual_buggy.tmp
    cat minimal_fix.diff

    echo '--- final test run ---'
    ../../.venv/bin/pytest -q | tee pytest_final.txt
    test "$before_exit" -ne 0
    grep -q '6 passed' pytest_final.txt
    echo 'VERIFICATION=passed'
} | tee experiment.log
rm -rf .pytest_cache __pycache__
