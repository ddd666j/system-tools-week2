from merge_sort import merge_sort


def test_given_input():
    values = [3, 1, 4, 1, 5, 9, 2, 6]
    assert merge_sort(values) == [1, 1, 2, 3, 4, 5, 6, 9]


def test_duplicate_elements():
    values = [4, 2, 4, 2, 1, 1]
    assert merge_sort(values) == [1, 1, 2, 2, 4, 4]
