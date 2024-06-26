from memory import DTypePointer, UnsafePointer
from random import rand
from memory import memset_zero


fn main():
    # Construct from an UnsafePointer:
    var uptr = UnsafePointer[Float64].alloc(10)
    var dptr = DTypePointer(uptr)

    var p1 = DTypePointer[DType.uint8].alloc(8)  # 1
    var p2 = DTypePointer[DType.uint8].alloc(8)

    # 2 - Operations:
    if p1:
        print("p1 is not null")
    print("p1 is at a lower address than p2:", p1 < p2)
    print("p1 and p2 are equal:", p1 == p2)
    print("p1 and p2 are not equal:", p1 != p2)
    # => p1 is not null
    #  p1 is at a lower address than p2: True
    #  p1 and p2 are equal: False
    #  p1 and p2 are not equal: True

    memset_zero(p1, 8)  # 3
    var all_data = p1.load[width=8](0)  # 4
    print(all_data)  # => [0, 0, 0, 0, 0, 0, 0, 0]
    rand(p1, 4)  # 5
    print(all_data)  # => [0, 0, 0, 0, 0, 0, 0, 0]
    all_data = p1.load[width=8](0)  # 6
    print(all_data)  # => [0, 33, 193, 117, 0, 0, 0, 0]

    var half = p1.load[width=4](0)  # 7
    half = half + 1
    p1.store[](4, half)
    all_data = p1.load[width=8](0)
    print(all_data)  # => [0, 33, 193, 117, 1, 34, 194, 118]

    # pointer arithmetic:
    p1 += 1  # 8
    all_data = p1.load[width=8](0)
    print(all_data)  # => [33, 193, 117, 1, 34, 194, 118, 0]

    p1 -= 1  # 9
    all_data = p1.load[width=8](0)
    print(all_data)  # => [0, 33, 193, 117, 1, 34, 194, 118]
    p1.free()  # 10

    all_data = p1.load[width=8](0)
    print(all_data)  # 11 => [67, 32, 35, 40, 83, 85, 0, 0]
