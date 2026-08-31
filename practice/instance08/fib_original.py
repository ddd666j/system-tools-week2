def fib(number):
    if number < 2:
        return number
    return fib(number - 1) + fib(number - 2)


if __name__ == "__main__":
    print(fib(32))
