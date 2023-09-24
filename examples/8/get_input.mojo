from python import Python 

fn main() raises:
    let py = Python.import_module("builtins")
    let col = py.input("What is your favorite color? ")
    print("Your favorite color is: ", col)