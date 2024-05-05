fn slice[ty: DType, new_size: Int, size: Int](
        x: SIMD[ty, size], offset: Int) -> SIMD[ty, new_size]:
    var result = SIMD[ty, new_size]()
    for i in range(new_size):
        result[i] = SIMD[ty, 1](x[i + offset])
    return result

fn reduce_add[ty: DType, size: Int](x: SIMD[ty, size]) -> Int:
    @parameter
    if size == 1:
        return int(x[0])
    elif size == 2:
        return int(x[0]) + int(x[1])

    # Extract the top/bottom halves, add them, sum the elements.
    alias half_size = size // 2
    var lhs = slice[ty, half_size, size](x, 0)
    var rhs = slice[ty, half_size, size](x, half_size)
    return reduce_add[ty, half_size](lhs + rhs)
    
fn main():
    var x = SIMD[DType.index, 4](1, 2, 3, 4)
    print(x) # => [1, 2, 3, 4]
    print("Elements sum:", reduce_add[DType.index, 4](x))
    # => Elements sum: 10