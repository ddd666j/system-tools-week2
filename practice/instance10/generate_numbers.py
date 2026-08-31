with open("numbers.txt", "w", encoding="utf-8") as stream:
    for number in range(200000):
        stream.write(str((number * 37) % 10000) + "\n")
