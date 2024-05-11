from tensor import Tensor


fn main():
    var t = Tensor[DType.int32](2, 2)  # shape = 2 x 2
    print(t.load[width=4]())  # => [0, 0, 0, 0]
    t.store[4](0, 1)  # stores value 1 on index 0
    t.store[4](2, 1)  # stores value 1 on index 2
    print(t)
    # =>
    # Tensor([[1, 0],[1, 0]], dtype=int32, shape=2x2)
