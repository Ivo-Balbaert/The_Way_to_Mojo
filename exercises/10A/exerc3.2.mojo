from PythonInterface import Python  

fn main():
    let math = Python.import_module("math")   
    print(math.pi)   # => 3.141592653589793

    