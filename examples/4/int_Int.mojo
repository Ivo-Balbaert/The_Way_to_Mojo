from python import PythonObject

alias int = PythonObject


fn main() raises:
    var x: int = 2
    # Python `int` does not overflow:
    print(x**100)  # => 1267650600228229401496703205376
    # Mojo `Int` overflows:
    print(2**100)  # => 0
