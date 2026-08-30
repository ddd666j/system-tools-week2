#!/usr/bin/env bash
set -euo pipefail
week_root="$(cd "$(dirname "$0")/.." && pwd)"
cd "$(dirname "$0")"
set +e
"$week_root/.venv/bin/python" merge_sort_buggy.py > buggy_stdout.txt 2>buggy_stderr.txt
buggy_rc=$?
set -e
printf '%s\n' "$buggy_rc" > buggy_exit_code.txt
"$week_root/.venv/bin/python" -m pdb merge_sort_buggy.py < pdb_commands.txt > pdb_session.txt 2>&1 || true
diff -u merge_sort_buggy.py merge_sort.py > minimal_fix.diff || true
"$week_root/.venv/bin/python" merge_sort.py | tee fixed_output.txt
"$week_root/.venv/bin/pytest" -q | tee pytest_final.txt
