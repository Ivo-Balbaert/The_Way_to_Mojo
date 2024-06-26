fn adder(a: Int, b: Int) -> Int: 
    return a + b

fn suber(a: Int, b: Int) -> Int: 
    return a - b

fn exec(x: Int, y: Int, bin_op: fn(Int, Int) -> Int) -> Int:
    var result: Int = 0
    for i in range(10):
        result += bin_op(x, y)
    return result

fn main():
    print(exec(10, 5, adder)) # => 150
    print(exec(10, 5, suber)) # => 50
