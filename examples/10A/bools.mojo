struct MyNumber:
    var value: FloatLiteral
    fn __init__(inout self, num: FloatLiteral):
        self.value = num

    fn __rand__(self, other: Bool) -> Bool:
        print("Called MyNumber's __rand__ function")
        if self.value > 0.0 and other:
            return True
        return False
    
fn main()
    var x : Bool = True
    print(x)    # => True

    x = False
    print(x)    # => False

    print(x.value)  # 1 => False

    # 2 - Invert:
    print(True.__invert__())  # => False
    print(~False)             # => True

    # 3 - Eq and ne
    print(True.__eq__(True))  # => True
    print(True == False)      # => False

    print(True.__ne__(True))  # => False
    print(True != False)      # => True
    
    # 4 - and, or and xor
    print(True.__and__(True)) # => True
    print(True & False)       # => False
    print(True.__or__(False)) # => True
    print(False or False)     # => False
    print(True.__xor__(True)) # => False
    print(True ^ False)       # => True
    print(False ^ True)       # => True
    print(False ^ False)      # => False

    # 5 - ror, rand and rxor
    let my_number = MyNumber(1.0) # => Called MyNumber's __rand__ function
    print(True & my_number)   # => True



