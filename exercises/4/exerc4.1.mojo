fn main():
    var left = Float64(2.0) # short alias 
    var right = SIMD[DType.float64, 1](2.0)
    print(right)        # => 2.0
    print(left * right) # => 4.0

    # alternative:
    var f1 = SIMD[DType.float64, 1](2.0)           
    print(f1)  # => 2.0
    var f2 = SIMD[DType.float64, 1](2.0)
    print(f1 * f2)  # => 4.0