from python import Python

fn main() raises:
    var math = Python.import_module("math")   
    print(math.pi)   # => 3.141592653589793

    