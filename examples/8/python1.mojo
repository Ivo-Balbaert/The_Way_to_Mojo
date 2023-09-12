from python import Python

fn main() raises:
    var x = Python.evaluate('5 + 10')   # 1
    print(x)   # => 15

    let py = Python()
    let py_string = py.evaluate("'This string was built' + ' inside of python'")
    print(py_string)  # => This string was built inside of python
 
    let pybt = Python.import_module("builtins")
    _ = pybt.print("this uses the python print keyword") # => this uses the python print keyword

    _ = pybt.print(pybt.type(x))  # => <class 'int'>
    _ = pybt.print(pybt.id(x))    # => 139787831339296

    x = "mojo"            
    print(x)              # => mojo