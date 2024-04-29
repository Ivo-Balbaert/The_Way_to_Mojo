fn main():
    var x: Bool = True   # equivalent: var x = True
    print(x)        # => True
    x = False
    print(x)        # 1 => False

    # 2 - Invert (~)
    print(~False)             # => True  # equivalent:  print(False.__invert__()) 

    # 3 - eq and ne (== !=)
    print(True == False)      # => False # equivalent:  print(True.__eq__(False))  
    print(True != False)      # => True  # equivalent:  print(True.__ne__(False))  

    # 4 - and, or and xor
    print(True & False)       # => False # equivalent:  print(True.__and__(False)) 
    print(False | False)      # => False # equivalent:  print(False.__or__(False))
    print(True ^ False)       # => True  # equivalent:  print(True.__xor__(False))

    # 5 Conversion to Bool:
    var b1 = (42).__bool__()
    print(b1)                  # => True
    var b2 = (0).__bool__()
    print(b2)                  # => False
    var b3 = ("Mojo").__bool__()
    print(b3)                  # => True