import pytest

from binary_search import binary_search


@pytest.mark.parametrize(
    ("target", "expected"),
    [(2, 0), (6, 2), (10, 4), (7, -1)],
)
def test_binary_search_boundaries(target, expected):
    assert binary_search([2, 4, 6, 8, 10], target) == expected


def test_empty_list():
    assert binary_search([], 1) == -1
