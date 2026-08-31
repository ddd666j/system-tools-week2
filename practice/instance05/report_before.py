import os
from pathlib import Path


def summarize(path):
    text = Path(path).read_text(encoding="utf-8")
    return {"lines": len(text.splitlines()), "characters": len(text)}


if __name__ == "__main__":
    print(summarize("sample.txt"))
