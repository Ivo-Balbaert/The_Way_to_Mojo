alias fl = Float32   # 1
alias Float16 = SIMD[DType.float16, 1]

alias MAX_ITERS = 200
alias DAYS_PER_YEAR = 365.24
alias PI = 3.141592653589793    # 1B
alias TAU = 2 * PI

    
fn main():
    alias MojoArr2 = DTypePointer[DType.float32] 

    alias debug_mode = True  # 2
    alias width = 960
    alias height = 960
    for i in range(MAX_ITERS):  # 3
        print_no_newline(i, " ") # => 0  1  2  3  4  5  6  ... 198 199