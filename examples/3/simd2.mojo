fn main():
    # Make a vector of 4 floats.
    let small_vec = SIMD[DType.float32, 4](1.0, 2.0, 3.0, 4.0)

    # Make a big vector containing 1.0 in float16 format.
    let big_vec = SIMD[DType.float16, 32].splat(1.0)

    # Do some math and convert the elements to float32.
    let bigger_vec = (big_vec + big_vec).cast[DType.float32]()

    # You can write types out explicitly if you want of course.
    let bigger_vec2 : SIMD[DType.float32, 32] = bigger_vec

    print('small_vec type:', small_vec.element_type, 'length:', len(small_vec))
    # => small_vec type: float32 length: 4
    print('bigger_vec2 type:', bigger_vec2.element_type, 'length:', len(bigger_vec2))
    # => bigger_vec2 type: float32 length: 32