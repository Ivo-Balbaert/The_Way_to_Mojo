fn main():
    alias fl = Float32   # 1
    alias Float16 = SIMD[DType.float16, 1]
    alias MojoArr2 = DTypePointer[DType.float32] 
    alias my_debug_build = 1  # 2