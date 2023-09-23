from utils.list import DimList
from memory.unsafe import DTypePointer
from memory.buffer import NDBuffer
from memory import memset_zero
from utils.list import VariadicList, DimList
from algorithm.functional import unroll


struct Tensor[rank: Int, shape: DimList, type: DType]:  # 1
    var data: DTypePointer[type]
    var buffer: NDBuffer[rank, shape, type]

    fn __init__(inout self):
        let size = shape.product[rank]().get()
        self.data = DTypePointer[type].alloc(size)
        memset_zero(self.data, size)
        self.buffer = NDBuffer[rank, shape, type](self.data)

    fn __del__(owned self):
        self.data.free()

    fn __getitem__(self, *idx: Int) raises -> SIMD[type, 1]:  # 8
        for i in range(rank):
            if idx[i] >= shape.value[i].get():
                raise Error("index out of bounds")
        return self.buffer.simd_load[1](VariadicList[Int](idx))

    fn get[*idx: Int](self) -> SIMD[type, 1]:  # 10
        @parameter
        fn check_dim[i: Int]():
            constrained[idx[i] < shape.value[i].get()]()

        unroll[rank, check_dim]()

        return self.buffer.simd_load[1](VariadicList[Int](idx))


fn main() raises:
    let x = Tensor[3, DimList(2, 2, 2), DType.uint8]()  # 2
    x.data.simd_store(0, SIMD[DType.uint8, 8](1, 2, 3, 4, 5, 6, 7, 8))
    print(x.buffer.num_elements())  # 3  => 8

    print(x.buffer[0, 0, 0])  # 4  => 1
    print(x.buffer[1, 0, 0])  # 5  => 5
    print(x.buffer[1, 1, 0])  # 6  => 7

    x.buffer[StaticIntTuple[3](1, 1, 1)] = 50
    print(x.buffer[1, 1, 1])  # => 50
    print(x.buffer[1, 1, 2])  # 7 => 88

    let x2 = Tensor[3, DimList(2, 2, 2), DType.uint64]()
    x2.data.simd_store(0, SIMD[DType.uint64, 8](0, 1, 2, 3, 4, 5, 6, 7))
    # print(x2[0, 2, 0])              # 9
    # => Unhandled exception caught during execution: index out of bounds
    # print(x.get[1, 1, 2]())         # 11
    # => note:                             constraint failed: param assertion failed
    #        constrained[idx[i] < shape.value[i].get()]()

    print(x.buffer.simd_load[4](0, 0, 0))  # => [1, 2, 3, 4]
    print(x.buffer.simd_load[4](1, 0, 0))  # => [5, 6, 7, 50]
    print(x.buffer.simd_load[2](1, 1, 0))  # => [0, 0]

    print(x.buffer.dynamic_shape)  # => (2, 2, 2)
    print(x.buffer.dynamic_stride)  # => (4, 2, 1)
    print(x.buffer.is_contiguous)  # => True

    print(x.buffer.bytecount())  # => 8
    print(x.buffer.dim[0]())  # => 2
    print(x.buffer[1, 1, 1])  # => 0
    let y = x.buffer.flatten()
    print(y[7])  # => 50
    print(x.buffer.get_nd_index(5))  # => (1, 0, 1)
    print(x.buffer.get_rank())  # => 3
    print(x.buffer.get_shape())  # => (2, 2, 2)
    print(x.buffer.size())  # => 8
    let new = x.buffer.stack_allocation()
    print(new.size())  # => 8
    print(x.buffer.stride(0))  # => 4
    print(x.buffer.get_nd_index(4))  # => (1, 0, 0)
    x.buffer.zero()
    print(x.get[0, 0, 0]())  # => 0
