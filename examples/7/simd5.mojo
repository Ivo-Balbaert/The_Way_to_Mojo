import math
fn main():
    var numbers = SIMD[DType.uint8,8]()
    print(numbers) # => [0, 0, 0, 0, 0, 0, 0, 0]
    # fill them whith numbers from 0 to 7
    numbers = math.iota[DType.uint8,8](0)
    print(numbers) # => [0, 1, 2, 3, 4, 5, 6, 7]
    numbers *= numbers   # # b. x*x for each number using one SIMD instructions:
    print(numbers) # => [0, 1, 4, 9, 16, 25, 36, 49]