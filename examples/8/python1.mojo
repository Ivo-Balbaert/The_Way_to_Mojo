from python import Python

fn main() raises:
    var x = Python.evaluate('5 + 10')   # 1
    print(x)   # => 15

    let py = Python.import_module("builtins")
    py.print("this uses the python print keyword") # => this uses the python print keyword

    py.print(py.type(x))  # => <class 'int'>
    py.print(py.id(x))    # => 139787831339296

    x = "mojo"            
    print(x)              # => mojo