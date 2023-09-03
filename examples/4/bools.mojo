fn main():
    var x: Bool = True
    print(x)        # => True
    print(x.value)  # => True

    x = False
    print(x)    # 1 => False

    # 2 - Invert:
    print(True.__invert__())  # => False
    print(~False)             # => True

    # 3 - eq and ne
    print(True.__eq__(True))  # => True
    print(True == False)      # => False

    print(True.__ne__(True))  # => False
    print(True != False)      # => True
    
    # 4 - and, or and xor
    print(True.__and__(True)) # => True
    print(True & False)       # => False
    print(True.__or__(False)) # => True
    print(False | False)      # => False
    print(True.__xor__(True)) # => False
    print(True ^ False)       # => True
    print(False ^ True)       # => True
    print(False ^ False)      # => False
