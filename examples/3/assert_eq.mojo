from testing import assert_equal

fn main() raises:
    var a = 1
    # var b = 2   # 2
    var b = a     # 3

    assert_equal(a, b)  

# =>
# Unhandled exception caught during execution: AssertionError: `left == right` comparison failed:
#   left: 1
#   right: 2
