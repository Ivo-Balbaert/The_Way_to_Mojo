from math import sqrt

fn rsqrt[dt: DType, width: Int](x: SIMD[dt, width]) -> SIMD[dt, width]:
    return 1 / sqrt(x)

fn main():
    print(rsqrt[DType.float16, 4](42))
    # => [0.154296875, 0.154296875, 0.154296875, 0.154296875]