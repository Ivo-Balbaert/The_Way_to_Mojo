
fn sum(x: Int, y: Int) -> Int:  # 1
    # x = 42    # => expression must be mutable in assignment
    # var x = 42    # => invalid redefinition of 'x'
    return x + y

fn main():
    _ = sum(1, 2)
    var z = sum(1, 2)
    print(z)    # => 3