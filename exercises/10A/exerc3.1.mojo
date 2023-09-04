fn main():
    x = Python.evaluate('pow(2, 8)') 
    # alternative:
    let pow = Python.evaluate("2 ** 8")   
    print(x)   # => 256


    