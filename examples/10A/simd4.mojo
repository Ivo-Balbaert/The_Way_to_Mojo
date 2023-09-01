fn concat[ty: DType, len1: Int, len2: Int](
        lhs: SIMD[ty, len1], rhs: SIMD[ty, len2]) -> SIMD[ty, len1+len2]:

    var result = SIMD[ty, len1 + len2]()
    for i in range(len1):
        result[i] = SIMD[ty, 1](lhs[i])
    for j in range(len2):
        result[len1 + j] = SIMD[ty, 1](rhs[j])
    return result

fn main():
    let a = SIMD[DType.float32, 2](1, 2)
    let x = concat[DType.float32, 2, 2](a, a)

    print('result type:', x.element_type, 'length:', len(x))
    # => result type: float32 length: 4