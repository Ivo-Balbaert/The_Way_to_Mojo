from math import rsqrt
alias dtype = DType.float32


fn main():
    var a = SIMD[dtype].splat(0.5)  # 1
    print("SIMD a:", a)  # => SIMD a: [0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5]

    var big_vec = SIMD[DType.float16, 32].splat(1.0)  # 2
    var bigger_vec = (big_vec + big_vec).cast[DType.float32]()  # 3
    print(bigger_vec)
    # [2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0]

    var b = SIMD[dtype].splat(2.5)
    print("SIMD a.join(b):", a.join(b))   # 4
    # => SIMD a.join(b): 
    # [0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5]

    print(rsqrt[DType.float16, 4](42))    # 5
    # => [0.154296875, 0.154296875, 0.154296875, 0.154296875]

    var d = SIMD[DType.int8, 4](42, 108, 7, 13)
    print(d.shuffle[1, 3, 2, 0]())  # 6  => [108, 13, 7, 42]

    var e = a.interleave(b)   # 7
    print(e)  # => [0.5, 2.5, 0.5, 2.5, 0.5, 2.5, 0.5, 2.5, 0.5, 2.5, 0.5, 2.5, 0.5, 2.5, 0.5, 2.5]
   