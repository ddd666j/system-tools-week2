#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

if command -v latexmk >/dev/null 2>&1; then
    latexmk -xelatex -interaction=nonstopmode -halt-on-error "第二周实验报告_杜铭昊_25020007021.tex"
elif command -v xelatex >/dev/null 2>&1; then
    xelatex -interaction=nonstopmode -halt-on-error "第二周实验报告_杜铭昊_25020007021.tex"
    xelatex -interaction=nonstopmode -halt-on-error "第二周实验报告_杜铭昊_25020007021.tex"
elif command -v tectonic >/dev/null 2>&1; then
    tectonic "第二周实验报告_杜铭昊_25020007021.tex"
else
    echo "未找到 latexmk、xelatex 或 tectonic，请先安装 TeX Live。" >&2
    exit 1
fi

echo "已生成：第二周实验报告_杜铭昊_25020007021.pdf"
