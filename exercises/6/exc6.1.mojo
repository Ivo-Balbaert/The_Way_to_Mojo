fn calc(a: Int, b: Int) -> Int:
    return (a + b) * (a - b)

# def calc(a, b):
#     return (a + b) * (a - b)

fn main():    # should be  fn main() raises: for def
    var a = 1
    var b = 2

    print(calc(a, b))  # => -3
