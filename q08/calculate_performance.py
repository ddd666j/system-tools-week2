from pathlib import Path
from statistics import median


def read_times(prefix):
    return [float(Path(f"{prefix}_{i}.txt").read_text().strip()) for i in (1, 2)]


before = read_times("before_time")
after = read_times("after_time")
before_median = median(before)
after_median = median(after)
speedup = before_median / after_median
print(f"before_runs={before}")
print(f"after_runs={after}")
print(f"before_median={before_median:.6f}s")
print(f"after_median={after_median:.6f}s")
print(f"speedup={speedup:.2f}x")
