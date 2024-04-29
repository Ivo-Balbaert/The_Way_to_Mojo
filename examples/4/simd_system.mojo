from sys.info import simdbitwidth, simdbytewidth, simdwidthof
import math


fn main():
    print(simdbitwidth())  # 1 => 256
    print(simdbytewidth())  # 2 => 32
    print(simdwidthof[DType.uint64]())  # 3 => 4
    print(simdwidthof[DType.float32]())  # 4 => 8

    var a = SIMD[DType.float32](42)  # 5
    print(len(a))  # 6 => 8
