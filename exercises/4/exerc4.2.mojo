fn main():
    var a = 0
    var b = 0
    var c = 0
    var d = 0
    for i in range(4):
        a, b, c, d = (0, 0, 0, 0)
        if i == 0:  a = 1
        if i == 1:  b = 1
        if i == 2:  c = 1
        if i == 3:  d = 1
        var n = SIMD[DType.uint8, 4](a, b, c, d)
        print(n)

    print("")
    # much more elegant solution:
    for i in range(4):
        var simd = SIMD[DType.uint8, 4](0)
        simd[i] = 1
        print(simd)

# => 
# [1, 0, 0, 0]
# [0, 1, 0, 0]
# [0, 0, 1, 0]
# [0, 0, 0, 1]
# [1, 0, 0, 0]
# [0, 1, 0, 0]
# [0, 0, 1, 0]
# [0, 0, 0, 1]