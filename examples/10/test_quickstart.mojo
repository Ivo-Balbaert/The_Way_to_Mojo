from testing import assert_equal

def inc(n: Int) -> Int:
    return n + 1

def test_inc_zero():
    # This test contains an intentional logical error to show an example of
    # what a test failure looks like at runtime.
    assert_equal(inc(0), 0)

def test_inc_one():
    assert_equal(inc(1), 2)
