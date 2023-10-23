fn sum(owned a: Int8, owned b: Int8) -> Int8:
    a = 3
    b = 2
    return a + b


fn main():
    var a: Int8 = 4
    var b: Int8 = 5

    # owned: the functions 'owns' these variables, so it can change them, but the original
    # values are no longer there, they are moved by the transfer operator
    print(sum(a^, b^))  # => 5
    # print(a, b)  # => error: use of uninitialized value 'a', error: use of uninitialized value 'b'
