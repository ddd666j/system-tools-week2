# 第5题：控制一个可清理的后台任务

严格按照题目要求在交互式 PTY 中完成：前台启动并分别重定向 stdout/stderr，发送 Ctrl-Z 挂起，使用 `bg` 恢复后台运行，使用 `jobs` 检查状态，通过 `jobs -p` 自动取得 PID，发送 SIGTERM 并 `wait`，最后检查 `cleanup.log` 和任务列表。未使用 `kill -9`。
