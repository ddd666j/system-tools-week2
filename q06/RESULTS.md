# 实验结果与反思

- Python 3.12.13、pylsp 1.15.0、ruff 0.16.5、pytest 9.1.1。
- LSP 跳转到 `math_utils.py` 的定义，查找到 5 处定义/引用位置。
- Rename Symbol 生成 3 个文档编辑，同步把定义、app 和测试改为 `calculate_total`。
- ruff 首先报告 `import os` 未使用，删除后最终检查通过；pytest 为 `1 passed`；app 输出 `50.0`。
- 错误反思：LSP 的 WorkspaceEdit 可能使用 `documentChanges` 而非 `changes`；语义重构必须应用服务器返回的全部编辑，不能只做字符串替换。
