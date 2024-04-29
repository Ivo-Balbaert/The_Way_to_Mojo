from testing import assert_equal

def main():
    a = Int32(42)
    b = Scalar[DType.int32](42)
    assert_equal(a, b) #  # Int32 is Scalar[DType.int32]