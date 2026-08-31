import importlib
import statistics
import time


def measure(module_name):
    samples = []
    values = []
    for _ in range(3):
        module = importlib.import_module(module_name)
        if hasattr(module.fib, "cache_clear"):
            module.fib.cache_clear()
        started = time.perf_counter()
        values.append(module.fib(32))
        samples.append(time.perf_counter() - started)
    return samples, values


before, before_values = measure("fib_original")
after, after_values = measure("fib_optimized")
before_median = statistics.median(before)
after_median = statistics.median(after)

print("before_runs=" + repr([round(value, 6) for value in before]))
print("after_runs=" + repr([round(value, 6) for value in after]))
print("before_median={:.6f}s".format(before_median))
print("after_median={:.6f}s".format(after_median))
print("speedup={:.2f}x".format(before_median / after_median))
print("same_results=" + str(before_values == after_values))
print("result=" + str(before_values[0]))
