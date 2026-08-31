def safe_divide(left, right):
    if right == 0:
        raise ValueError("right operand must not be zero")
    return left / right
