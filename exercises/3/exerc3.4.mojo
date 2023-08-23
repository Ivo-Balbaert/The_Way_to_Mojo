from DType import DType                 

fn main():
    var a = 0
    var b = 0
    var c = 0
    var d = 0
    for i in range(4):
        if i == 0: 
                a = 1
                n = SIMD[DType.uint8, 4](a, b, c, d)
        if i == 1: 
                a = 0
                b = 1
                n = SIMD[DType.uint8, 4](a, b, c, d)
        if i == 2:
                b = 0
                c = 1
                n = SIMD[DType.uint8, 4](a, b, c, d)
        if i == 3: 
                c = 0
                d = 1
                n = SIMD[DType.uint8, 4](a, b, c, d)
        print(n)

        # much more elegant solution:
        for i in range(4):
            simd = SIMD[DType.uint8, 4](0)
            simd[i] = 1
            print(simd)




# =>
# [1, 0, 0, 0]
# [0, 1, 0, 0]
# [0, 0, 1, 0]
# [0, 0, 0, 1]