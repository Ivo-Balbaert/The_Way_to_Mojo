fn adder(a: Int, b: Int) -> Int: 
    return a + b

fn main():
#    var my_fn_var: fn(Int, Int) -> Int = adder
    var my_fn_var = adder    # 1

    print(my_fn_var(4, 3)) # => 7