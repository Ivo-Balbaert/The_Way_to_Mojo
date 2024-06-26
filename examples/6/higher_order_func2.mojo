fn adder(a: Int, b: Int) -> Int:
    return a + b


fn suber(a: Int, b: Int) -> Int:
    return a - b


# fn diver(a: Int, b: Int) -> Float16:
#     return a / b


fn exec_param[bin_op: fn (Int, Int) -> Int](x: Int, y: Int) -> Int:
    var result: Int = 0
    for i in range(10):
        result += bin_op(x, y)
    return result


fn main():
    print(exec_param[adder](10, 5))  # => 150
    print(exec_param[suber](10, 5))  # => 50
