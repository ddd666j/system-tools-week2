# 实验结果与反思

- 前台任务的 stdout、stderr 分别写入 `stdout.log` 和 `stderr.log`。
- 通过真实 Ctrl-Z 将任务置为 Stopped，`bg` 后状态变为 Running。
- PID 由 `jobs -p` 自动获得，未手工抄写；发送 SIGTERM 后 `wait` 返回 0。
- `cleanup.log` 出现 `CLEAN_EXIT`，最终 `jobs` 为空，`stderr.log` 为 0 字节。
- 错误反思：不能使用 `kill -9`，因为 SIGKILL 无法被 trap 捕获，会跳过清理逻辑；PID 也不应根据终端显示手工填写。
