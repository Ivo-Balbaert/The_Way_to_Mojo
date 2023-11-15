fn main():
    alias dtype = DType.float32
    alias simd_width = simdwidthof[DType.float32]()

    let a = SIMD[dtype].splat(0.5)
    let b = SIMD[dtype].splat(2.5)

    print("SIMD a:", a)  # => SIMD a: [0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5]
    print("SIMD b:", b)  # => SIMD b: [2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5]
    print()

    print("SIMD a.join(b):", a.join(b))


# => SIMD a.join(b): [0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5]
