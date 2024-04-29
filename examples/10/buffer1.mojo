from buffer import Buffer
from memory.unsafe import DTypePointer

fn main():
    var p = DTypePointer[DType.uint8].alloc(8)  
    var x = Buffer[DType.uint8, 8](p)           # 1
    x.zero()
    print(x.load[width=8](0))                    # 2
    # => [0, 0, 0, 0, 0, 0, 0, 0]
    for i in range(len(x)):                     # 3
        x[i] = i
    print(x.load[width=8](0))                    # 4
    # => [0, 1, 2, 3, 4, 5, 6, 7]
    var y = x
    y.dynamic_size = 4
    for i in range(y.dynamic_size):
        y[i] *= 10 
    print(y.load[width=4](0)) # => [0, 10, 20, 30]
    print(x.load[width=8](0))                    # 5
    # => [0, 10, 20, 30, 4, 5, 6, 7]    

    # SIMD:
    var first_half = x.load[width=4](0) * 2
    var second_half = x.load[width=4](4) * 10

    x.store(0, first_half)
    x.store(4, second_half)
    print(x.load[width=8](0))
    # => [0, 20, 40, 60, 40, 50, 60, 70]        # 6
    
    x.simd_nt_store(0, second_half)
    print(x.load[width=8](0))
    # => [40, 50, 60, 70, 40, 50, 60, 70]       # 7
    x.fill(10)
    print(x.load[width=8](0))
    # => [10, 10, 10, 10, 10, 10, 10, 10]
    var z = x.stack_allocation()
    print(x.load[width=8](0))
    # => [10, 10, 10, 10, 10, 10, 10, 10]
    print(x.bytecount())  # => 8
   