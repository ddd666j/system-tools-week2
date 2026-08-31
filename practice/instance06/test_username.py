import pytest

from username import normalize_username


@pytest.mark.parametrize(
    ("raw", "expected"),
    [("Alice", "alice"), ("  Bob  ", "bob"), ("CAROL", "carol")],
)
def test_normalize_valid_names(raw, expected):
    assert normalize_username(raw) == expected


@pytest.mark.parametrize("raw", ["", " ", "\t\n"])
def test_reject_blank_names(raw):
    with pytest.raises(ValueError, match="must not be blank"):
        normalize_username(raw)
