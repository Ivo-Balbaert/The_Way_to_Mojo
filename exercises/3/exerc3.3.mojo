from DType import DType                 

fn main():
    let left = Float64(2.0)
    let right = SIMD[DType.float64, 1](2.0)
    print(right)        # => 2.0
    print(left * right) # => 4.0

    # my solution:
    f1 = SIMD[DType.float64, 1](2.0)   # <= wihout let, this is a vector of 4!          
    print(f1)  # => [2.0, 2.0, 2.0, 2.0]
    f2 = SIMD[DType.float64, 1](2.0)
    print(f1 * f2)  # => [4.0, 4.0, 4.0, 4.0]
    # short alias version:
    f3 = Float64(2.0)
    print(f1 * f3)  # => [4.0, 4.0, 4.0, 4.0]