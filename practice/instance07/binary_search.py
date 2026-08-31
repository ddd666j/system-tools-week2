def binary_search(values, target):
    low = 0
    high = len(values) - 1
    while low <= high:
        middle = (low + high) // 2
        if values[middle] < target:
            low = middle + 1
        elif values[middle] > target:
            high = middle - 1
        else:
            return middle
    return -1


if __name__ == "__main__":
    print(binary_search([2, 4, 6, 8, 10], 10))
