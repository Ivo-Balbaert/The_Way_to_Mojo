from testing import assert_equal

def main():
    a = Scalar[DType.int32](42)
    b = SIMD[DType.int32, 1](42)
    assert_equal(a, b) 