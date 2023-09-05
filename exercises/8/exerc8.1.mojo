from python import Python

fn main() raises:
    let x = Python.evaluate('pow(2, 8)')
    print(x)     # => 256
    # alternative:
    let pow = Python.evaluate("2 ** 8")   
    print(pow)   # => 256


    