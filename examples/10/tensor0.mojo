from tensor import Tensor

fn main():
    let t = Tensor[DType.int32](2, 2)
    print(t.simd_load[4](0, 1, 2, 3)) # => [0, 32, 0, 113] - undefined last value
