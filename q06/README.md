# 第6题：语义重构与本地开发反馈

使用 `python-lsp-server` 的 LSP 协议依次完成跳转到定义、查找引用和 Rename Symbol。重命名由语言服务器返回的 WorkspaceEdit 同步应用到定义、app 和测试文件。随后临时添加 `import os`，保存 ruff 检测结果并自动修复，最后运行 ruff、pytest 和 app。
