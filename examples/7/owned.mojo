
fn sum(owned a: Int8, owned b: Int8) -> Int8:
    a = 3
    b = 2
    return a + b

fn main():
    var a: Int8 = 4
    var b: Int8 = 5

    # owned: the functions 'owns' these variables, so it can change them, but the original
    # values remain unchanged
    print(sum(a, b))     # => 5 
    # if a and b are declared with let, you would get error: uninitialized variable 'a'
    print(a, b)          # => 4 5
