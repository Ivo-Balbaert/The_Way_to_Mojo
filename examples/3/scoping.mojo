fn lexical_scopes():      # fn could also be def
    var num = 10
    var dig = 1
    if True:
        print("num:", num)  # Reads the outer-scope "num"
        var num = 20        # Creates new inner-scope "num"  # 1
        print("num:", num)  # Reads the inner-scope "num"
        dig = 2             # Edits the outer-scope "dig"
    print("num:", num)      # Reads the outer-scope "num"
    print("dig:", dig)      # Reads the outer-scope "dig"

def function_scopes():
    num = 1
    if num == 1:
        print(num)   # Reads the function-scope "num"
        num = 2      # Updates the function-scope variable # 2
        print(num)   # Reads the function-scope "num"
    print(num)       # Reads the function-scope "num"


fn main() raises:
    lexical_scopes() # =>
    # num: 10
    # num: 20
    # num: 10
    # dig: 2
    function_scopes() #  
    # 1
    # 2
    # 2
