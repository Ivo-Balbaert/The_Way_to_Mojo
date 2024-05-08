from python import Python 

fn main() raises:
    var py = Python.import_module("builtins")
    var col = py.input("What is your favorite color? ")
    print("Your favorite color is: ", col)