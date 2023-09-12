fn swap(inout lhs: Int, inout rhs: Int):
    let tmp = lhs
    lhs = rhs
    rhs = tmp

fn main():
    var x = 42
    var y = 12
    print(x, y)  # => 42, 12
    swap(x, y)
    print(x, y)  # => 12, 42