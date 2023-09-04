fn main():
    let left = Float64(2.0)
    let right = SIMD[DType.float64, 1](2.0)
    print(right)        # => 2.0
    print(left * right) # => 4.0

    # my solution:
    let f1 = SIMD[DType.float64, 1](2.0)   # <= without let, this is a vector of 4!          
    print(f1)  # => 2.0
    let f2 = SIMD[DType.float64, 1](2.0)
    print(f1 * f2)  # => 4.0
    
    # short alias version:
    let f3 = Float64(2.0)
    print(f1 * f3)  # => 4.0