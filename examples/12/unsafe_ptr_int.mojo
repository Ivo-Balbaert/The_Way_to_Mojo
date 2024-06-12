fn main():
    var ptr = UnsafePointer[Int].alloc(1)
    var ptr_uint64 = UInt64(int(ptr))
    print(ptr_uint64)  # => 94264536539136
    ptr.free()