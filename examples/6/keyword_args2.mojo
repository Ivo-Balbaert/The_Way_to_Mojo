fn pow(base: Int, exp: Int = 2) -> Int:    # 1
    return base ** exp

fn main():
    var z = pow(exp=3, base=2) # 2 # Uses keyword argument names (with order reversed)
    print(z) # => 8