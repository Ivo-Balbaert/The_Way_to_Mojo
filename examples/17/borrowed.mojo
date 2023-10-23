fn sum(borrowed a: Int8, borrowed b: Int8) -> Int8:
    # a = 3 # error: expression must be mutable in assignment
    return a + b

# same as:
# fn sum_borrowed(a: Int8, b: Int8) -> Int8:
#     return a + b

fn main():
    var a: Int8 = 4
    var b: Int8 = 5

    # borrowed: the values are used in computations, but they cannot be changed
    print(sum(a, b))  # => 9
    print(a, b)       # => 4 5