from sys.info import simdwidthof
from random import rand
import math

alias element_type = DType.int32
alias group_size = simdwidthof[element_type]()


fn main():
    var numbers: SIMD[element_type, group_size]
    # initialize numbers:
    numbers = math.iota[element_type, group_size](0)
    print(numbers)  # => [0, 1, 2, 3, 4, 5, 6, 7]
