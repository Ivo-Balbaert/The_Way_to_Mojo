import math

fn main():
    var a = SIMD[DType.uint8, 4](1, 2, 3, 4)  # 1
    print(a)  # => [1, 2, 3, 4]
    print(a.element_type) # => uint8
    print(len(a)) # => 4

    a *= 10                                   # 2
    print(a)  # => [10, 20, 30, 40]

    var zeros = SIMD[DType.uint8, 4]()        # 3A
    print(zeros)  # => [0, 0, 0, 0]
    var ones = SIMD[DType.uint8, 4](1)        # 3B
    print(ones)  # => [1, 1, 1, 1]

    var vec1 = SIMD[DType.int8, 4](2, 3, 5, 7)
    var vec2 = SIMD[DType.int8, 4](1, 2, 3, 4)
    var product = vec1 * vec2                 # 3C
    print(product) # => [2, 6, 15, 28]

    var numbers = SIMD[DType.uint8, 8]()
    print(numbers) # => [0, 0, 0, 0, 0, 0, 0, 0]
    # fill them with numbers from 0 to 7
    numbers = math.iota[DType.uint8, 8](0)    # 4
    print(numbers) # => [0, 1, 2, 3, 4, 5, 6, 7]
    numbers *= numbers   # 5     
    print(numbers) # => [0, 1, 4, 9, 16, 25, 36, 49]