fn pow(base: Int, exp: Int = 2) -> Int:    # 1
    return base ** exp

fn main():
    var z = pow(3) # 2 # Uses the default value for `exp`, which is 2
    print(z) # => 9