
fn sum(x: Int, y: Int) -> Int:  # 1
    # x = 42    # => expression must be mutable in assignment
    # var x = 42    # => invalid redefinition of 'x'
    return x + y

fn main():
    sum(1, 2)
    # let z = sum(1, 2)
    print(z)    # => 3