#!/usr/bin/env bash
set -euo pipefail
rm -rf .ruff_cache __pycache__
rm -f report.py ruff_before.txt ruff_before_exit.txt ruff_fix.txt ruff_final.txt fix.diff program_output.txt experiment.log
cp report_before.py report.py
{
    echo 'INSTANCE05: Ruff feedback and automatic fix'
    echo '--- initial check (expected failure) ---'
    set +e
    ../../.venv/bin/ruff check report.py >ruff_before.txt 2>&1
    before_exit=$?
    set -e
    cat ruff_before.txt
    echo "$before_exit" >ruff_before_exit.txt
    echo "RUFF_BEFORE_EXIT=$before_exit"

    echo '--- apply safe fix ---'
    ../../.venv/bin/ruff check --fix report.py | tee ruff_fix.txt
    diff -u report_before.py report.py >fix.diff || true
    cat fix.diff

    echo '--- final verification ---'
    ../../.venv/bin/ruff check report.py | tee ruff_final.txt
    ../../.venv/bin/python report.py | tee program_output.txt
    test "$before_exit" -ne 0
    grep -q '^All checks passed!' ruff_final.txt
    echo 'VERIFICATION=passed'
} | tee experiment.log
rm -rf .ruff_cache __pycache__
