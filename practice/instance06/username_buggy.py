def normalize_username(value):
    if value == "":
        raise ValueError("username must not be blank")
    return value.strip().lower()
