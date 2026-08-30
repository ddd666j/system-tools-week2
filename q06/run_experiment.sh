#!/usr/bin/env bash
set -euo pipefail
week_root="$(cd "$(dirname "$0")/.." && pwd)"
cd "$(dirname "$0")"
cp math_utils.py math_utils_before.txt
cp app.py app_before.txt
cp test_math_utils.py test_math_utils_before.txt
"$week_root/.venv/bin/python" lsp_demo.py | tee lsp_actions.txt
printf 'import os\n%s\n' "$(cat app.py)" > app_with_unused_import.txt
cp app_with_unused_import.txt app.py
set +e
"$week_root/.venv/bin/ruff" check app.py > ruff_before.txt 2>&1
ruff_rc=$?
set -e
printf '%s\n' "$ruff_rc" > ruff_before_exit.txt
"$week_root/.venv/bin/ruff" check --fix app.py > ruff_fix.txt 2>&1
"$week_root/.venv/bin/ruff" check math_utils.py app.py test_math_utils.py | tee ruff_final.txt
"$week_root/.venv/bin/pytest" -q | tee pytest_final.txt
"$week_root/.venv/bin/python" app.py | tee app_output.txt
diff -u math_utils_before.txt math_utils.py > semantic_rename_math.diff || true
diff -u app_before.txt app.py > semantic_rename_app.diff || true
