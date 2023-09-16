from python import PythonObject
alias int = PythonObject

fn main() raises:
    let x : int = 2
    # `int` does not overflow:
    print(x ** 100) # => 1267650600228229401496703205376
    # `Int` overflows:
    print(2 ** 100) # => 0