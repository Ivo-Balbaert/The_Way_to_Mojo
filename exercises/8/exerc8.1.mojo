from python import Python

fn main() raises:
    var x = Python.evaluate('pow(2, 8)')
    print(x)     # => 256
    # alternative:
    var pow = Python.evaluate("2 ** 8")   
    print(pow)   # => 256


    