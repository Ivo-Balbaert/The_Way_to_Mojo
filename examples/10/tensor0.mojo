from tensor import Tensor


fn main():
    var t = Tensor[DType.int32](2, 2)
    print(t.load[width=4](0, 1, 2, 3))  # => [0, 32, 0, 4113]
    t.store[4](0, 1)  # 4 values from start get value 1
    print(t)
    # =>
    # Tensor([[1, 1], [1, 1]], dtype=int32, shape=2x2)
