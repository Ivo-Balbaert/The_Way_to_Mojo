from python import Python

fn main() raises:
    var w: Int = 42
    var x = Python.evaluate('5 + 10')   # 1
    print(x)   # => 15

    var py = Python()
    var py_string = py.evaluate("'This string was built' + ' inside of python'")
    print(py_string)  # => This string was built inside of python
 
    var pybt = Python.import_module("builtins")
    _ = pybt.print("this uses the python print function") # => this uses the python print function
    _ = pybt.print("The answer is", w) # => The answer is 42
    _ = pybt.print(pybt.type(x))  # => <class 'int'>
    _ = pybt.print(pybt.id(x))    # => 139787831339296

    x = "mojo"            
    print(x)              # => mojo

    print(pybt.type([0, 3]))            # uses the Mojo print function
    print(pybt.type((False, True)))
    print(pybt.type(4))
    print(pybt.type("orange"))
    print(pybt.type(3.4))
# =>
# <class 'list'>
# <class 'tuple'>
# <class 'int'>
# <class 'str'>
# <class 'float'>