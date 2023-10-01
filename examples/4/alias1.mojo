alias fl = Float32   # 1
alias Float16 = SIMD[DType.float16, 1]

alias PI = 3.141592653589793    # 1B
alias SOLAR_MASS = 4 * PI * PI
alias DAYS_PER_YEAR = 365.24

fn main():
    alias MojoArr2 = DTypePointer[DType.float32] 

    alias my_debug_build = 1  # 2
    alias width = 960
    alias height = 960
    alias MAX_ITERS = 200