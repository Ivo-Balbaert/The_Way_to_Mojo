from testing import *


fn main() raises:
    let b1 = 3 < 5
    print(assert_true(b1, "This is false!"))  # => None
    # print(assert_false(b1, "This is false!"))
    # => ASSERT ERROR: This is false!
    # => Error
    let b2 = 3 > 5
    # print(assert_true(b2, "This is false!"))
    # => ASSERT ERROR: This is false!
    # => None
    print(assert_false(b2, "This is false!"))
    # => None

    let n = 41
    let m = 42
    # print(assert_equal(n, m))  # => Error
    print(assert_not_equal(n, m))  # => None

    let p = SIMD[DType.float16, 4](1.0, 2.1, 3.2, 4.3)
    let q = SIMD[DType.float16, 4](1.0, 2.1, 3.2, 4.3)
    print(assert_equal(p, q))  # => None

    let p2 = SIMD[DType.float16, 4](1.0, 2.1, 3.2, 4.3)
    let q2 = SIMD[DType.float16, 4](1.1, 2.2, 3.3, 4.4)
    #print(assert_almost_equal(p2, q2))
    # => ASSERT ERROR: The input value [1.0, 2.099609375, 3.19921875, 4.30078125] is not close to
    # [1.099609375, 2.19921875, 3.30078125, 4.3984375] with a diff of
    # [0.099609375, 0.099609375, 0.1015625, 0.09765625]
    # False
