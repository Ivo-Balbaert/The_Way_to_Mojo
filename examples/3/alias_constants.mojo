alias MAX_ITERS = 200           # 1
alias DAYS_PER_YEAR = 365.24
alias PI = 3.141592653589793    
alias TAU = 2 * PI

    
fn main():
    alias debug_mode = True     # 2
    alias width = 960
    alias height = 960
   # MAX_ITERS = 500            # 2B error: expression must be mutable in assignment
    print(MAX_ITERS)            # 3A
    for i in range(MAX_ITERS):  # 3B
        print(i, " ", end="") # => 0  1  2  3  4  5  6  ... 198 199