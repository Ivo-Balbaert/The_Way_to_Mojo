from sys.info import simdbitwidth

fn main():
    let zeros = SIMD[DType.uint8, 4]()       # 0
    print(zeros)  # => [0, 0, 0, 0]

    var y = SIMD[DType.uint8, 4](1, 2, 3, 4)  # 1
    print(y)  # => [1, 2, 3, 4]

    y *= 10                                 # 2
    print(y)  # => [10, 20, 30, 40]

    let z = SIMD[DType.uint8, 4](1)         # 3
    print(z)  # => [1, 1, 1, 1]

    print(simdbitwidth())  # => 256         # 4  