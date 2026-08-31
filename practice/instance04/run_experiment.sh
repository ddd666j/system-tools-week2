#!/usr/bin/env bash
set -euo pipefail
rm -rf .demo_venv
rm -f experiment.log test_output.txt
{
    echo 'INSTANCE04: isolated Python virtual environment'
    echo "SYSTEM_PYTHON=$(command -v python3)"
    python3 --version
    ../../.venv/bin/python -m venv .demo_venv
    source .demo_venv/bin/activate
    echo "VENV_PYTHON=$(command -v python)"
    python --version
    python -c 'import sys; print("PREFIX=" + sys.prefix); print("BASE_PREFIX=" + sys.base_prefix); print("ISOLATED=" + str(sys.prefix != sys.base_prefix))'
    python -m unittest -v 2>&1 | tee test_output.txt
    deactivate
    echo "AFTER_DEACTIVATE=$(command -v python3)"
    rm -rf .demo_venv
    echo 'TEMP_VENV_REMOVED=yes'
} | tee experiment.log
