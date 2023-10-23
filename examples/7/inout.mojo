fn sum(inout a: Int8, inout b: Int8) -> Int8:
    # with inout the values can be changed (they must be declared as var)
    a = 3
    b = 2
    return a + b

fn main():
    var a: Int8 = 4
    var b: Int8 = 5

    # inout: values can be changed inside, and the changes are visible outside
    print(sum(a, b))  # => 5
    print(a, b)       # => 3 2