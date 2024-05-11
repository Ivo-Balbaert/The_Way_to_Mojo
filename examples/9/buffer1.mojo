from buffer import Buffer
from memory.unsafe import DTypePointer

fn main():
    var p = DTypePointer[DType.uint8].alloc(8)  
    var buf = Buffer[DType.uint8, 8](p)           # 1
    buf.zero()                                    # 1B
    print(buf.load[width=8](0))                   # 2
    # => [0, 0, 0, 0, 0, 0, 0, 0]
    for i in range(len(buf)):                     # 3
        buf[i] = i
    print(buf.load[width=8](0))                   # 4
    # => [0, 1, 2, 3, 4, 5, 6, 7]

    var buf2 = buf
    buf2.dynamic_size = 4
    for i in range(buf2.dynamic_size):
        buf2[i] *= 10 
    print(buf2.load[width=4](0)) # => [0, 10, 20, 30]
    print(buf.load[width=8](0))                   # 5
    # => [0, 10, 20, 30, 4, 5, 6, 7]    

    # SIMD:
    var first_half = buf.load[width=4](0) * 2
    var second_half = buf.load[width=4](4) * 10

    buf.store(0, first_half)
    buf.store(4, second_half)
    print(buf.load[width=8](0))
    # => [0, 20, 40, 60, 40, 50, 60, 70]        # 6
    
    buf.simd_nt_store(0, second_half)
    print(buf.load[width=8](0))
    # => [40, 50, 60, 70, 40, 50, 60, 70]       # 7
    buf.fill(10)
    print(buf.load[width=8](0))
    # => [10, 10, 10, 10, 10, 10, 10, 10]
    var z = buf.stack_allocation()
    print(buf.load[width=8](0))
    # => [10, 10, 10, 10, 10, 10, 10, 10]
    print(buf.bytecount())  # => 8
   