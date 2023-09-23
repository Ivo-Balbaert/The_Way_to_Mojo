fn main():
    alias fl = Float32   # 1
    alias Float16 = SIMD[DType.float16, 1]
    alias MojoArr2 = DTypePointer[DType.float32] 

    alias my_debug_build = 1  # 2
    alias width = 960
    alias height = 960
    alias MAX_ITERS = 200