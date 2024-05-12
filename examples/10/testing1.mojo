# All assertion errors are commented out!
from testing import *


fn main() raises:
    var b1 = 3 < 5
    assert_true(b1, "This is false!")  # this is True, no output
    # assert_false(b1, "This is false!")
    # => AssertionError: This is false!
    var b2 = 3 > 5
    # assert_true(b2, "This is false!")
    # => AssertionError: This is false!
    assert_false(b2, "This is false!") # this is True, no output

    var n = 41
    var m = 42
    assert_not_equal(n, m)  # this is True, no output

    var p = SIMD[DType.float16, 4](1.0, 2.1, 3.2, 4.3)
    var q = SIMD[DType.float16, 4](1.0, 2.1, 3.2, 4.3)
    assert_equal(p, q)   # this is True, no output

    var q2 = SIMD[DType.float16, 4](1.1, 2.2, 3.3, 4.4)
    # assert_almost_equal(p, q2, atol = 0.1)
    # Unhandled exception caught during execution: 
    # At /home/ivo/mojo/test/testing1.mojo:24:24: 
    # AssertionError: [1.0, 2.099609375, 3.19921875, 4.30078125] is not close to 
    # [1.099609375, 2.19921875, 3.30078125, 4.3984375] with a diff of 
    # [0.099609375, 0.099609375, 0.1015625, 0.09765625]
    assert_almost_equal(p, q2, atol = 0.2)  # this is True, no output

# Good! Caught the raised error, test passes
    with assert_raises():
        raise "SomeError"

# Also good!
    with assert_raises(contains="Some"):
        raise "SomeError"

# This will assert, we didn't raise
    # with assert_raises():  # => AssertionError: Didn't raise
    #     pass

# This will let the underlying error propagate, failing the test
    # with assert_raises(contains="Some"):
    #     raise "OtherError"  # =>  OtherError