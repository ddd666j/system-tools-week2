# 实例 4：创建并验证独立 Python 虚拟环境

## 原理

虚拟环境通过独立的解释器入口和 `sys.prefix` 隔离项目环境。激活后 `sys.prefix` 与 `sys.base_prefix` 不同，说明当前 Python 位于虚拟环境；项目测试由虚拟环境解释器执行，不依赖系统 Python 的包状态。

## 步骤

1. 记录系统 `python3` 的路径和版本。
2. 使用课程环境中的 Python 创建临时 `.demo_venv`。
3. 激活环境，记录解释器路径、版本、`sys.prefix` 和 `sys.base_prefix`。
4. 使用标准库 `unittest` 运行正常除法与除零异常两个测试。
5. 退出环境并清理临时虚拟环境，只保留测试日志。

## 结果

`ISOLATED=True`，两个测试全部通过；退出后恢复系统解释器，临时环境已清理。
