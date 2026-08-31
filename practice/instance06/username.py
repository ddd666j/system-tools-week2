def normalize_username(value):
    if not value.strip():
        raise ValueError("username must not be blank")
    return value.strip().lower()
