from DType import DType                 # 1

y = SIMD[DType.uint8, 4](1, 2, 3, 4)    # 2
print(y)  # => [1, 2, 3, 4]

y *= 10                                 # 3
print(y)  # => [10, 20, 30, 40]

z = SIMD[DType.uint8, 4](1)             # 4
print(z)  # => [1, 1, 1, 1]

from TargetInfo import simdbitwidth
print(simdbitwidth())  # => 512         # 5