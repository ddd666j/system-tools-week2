#!/usr/bin/env bash
set -euo pipefail
week_root="$(cd "$(dirname "$0")/.." && pwd)"
python="$week_root/.venv/bin/python"
cd "$(dirname "$0")"
"$python" generate_words.py
sha256sum words.txt > words_sha256.txt
TIMEFORMAT='%R'
{ time "$python" wordfreq_original.py > before_output_1.txt; } 2> before_time_1.txt
{ time "$python" wordfreq_original.py > before_output_2.txt; } 2> before_time_2.txt
"$python" -m cProfile -s cumulative wordfreq_original.py > profile_original.txt
{ time "$python" wordfreq_optimized.py > after_output_1.txt; } 2> after_time_1.txt
{ time "$python" wordfreq_optimized.py > after_output_2.txt; } 2> after_time_2.txt
"$python" calculate_performance.py | tee performance_summary.txt
diff -u before_output_1.txt after_output_1.txt > output_comparison.diff || true
