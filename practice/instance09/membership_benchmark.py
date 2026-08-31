import random
import statistics
import timeit


random.seed(20260831)
allowed_list = list(range(5000))
allowed_set = set(allowed_list)
queries = [random.randrange(8000) for _ in range(20000)]


def count_with_list():
    return sum(value in allowed_list for value in queries)


def count_with_set():
    return sum(value in allowed_set for value in queries)


list_result = count_with_list()
set_result = count_with_set()
list_times = timeit.repeat(count_with_list, number=1, repeat=3)
set_times = timeit.repeat(count_with_set, number=1, repeat=3)
list_median = statistics.median(list_times)
set_median = statistics.median(set_times)

print("query_count=" + str(len(queries)))
print("allowed_count=" + str(len(allowed_list)))
print("list_result=" + str(list_result))
print("set_result=" + str(set_result))
print("same_results=" + str(list_result == set_result))
print("list_times=" + repr([round(value, 6) for value in list_times]))
print("set_times=" + repr([round(value, 6) for value in set_times]))
print("list_median={:.6f}s".format(list_median))
print("set_median={:.6f}s".format(set_median))
print("speedup={:.2f}x".format(list_median / set_median))
