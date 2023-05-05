from src.sample import add, diff


def test_add():
    assert add(2, 3) == 5


def test_diff():
    assert diff(2, 3) == -1
