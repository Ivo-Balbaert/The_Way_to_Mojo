from memory.unsafe import DTypePointer

fn main() raises:
    # StringLiteral:
    var lit = "This is my StringLiteral"       # 1
    print(lit)  # => This is my StringLiteral
    var lit2 = 'This is also a StringLiteral'  # 1

    # lit = 20  # => error: Expression [9]:26:11: cannot implicitly convert 'Int' value to 'StringLiteral' in assignment

    # Conversion to Bool:
    var x = ""
    print(x.__bool__())  # 1B => False
    var y = "a"
    print(y.__bool__())  # 1C => True

    x = "abc"
    y = "abc"
    var z = "ab"
    print(x == y)  # 1E => True # equivalent to x.__eq__(y)
    print(x == z)  # => False

    z = "ab"
    print(x != y)  # => False
    print(x != z)  # => True

    var x1 = "hello "
    var y1 = "world"
    var d = x1 + y1  # equivalent to x1.__add__(y1)
    print(d)         # => hello world
   
    x = "string"
    print(len(x))  # => 6   # equivalent to x.__len__()  

    var y2 = x.data()
    x = "alo"
    print(y2)  # => 0x7f72bc000170
    print(x)   # => alo

    print(int("19"))  # => 19
    # print(int("Mojo"))  # => Unhandled exception caught during execution: String is not convertible to integer.

    # print(("hello world")[0]) # => Error: `StringLiteral` is not subscriptable
    # var s2 = "hello world" # s2 is a `StringLiteral`
    # print(s2[:5]) # ERROR: `StringLiteral` is not subscriptable

    # String:
    var s : String = "Mojo🔥"
    # var s = String("Mojo🔥")     # 3 - is conversion(casting)
    print(s)  # => Mojo🔥
    print(s[0])  # 4 => M
    print(ord(s[0]))  # => 77
    print(String("hello world")[0])  # => h
    var s3 : String = 1 # implicit type conversion, uses constructor __init__(inout self, num: Int)

    # building a string with a List:
    var buf = List[Int8](2)  # 5
    buf.append(65)
    buf.append(79)
    buf[0] = 78
    buf.append(0)
    var str = String(buf)  
    print(str)  # => NA0

    # StringRef:
    var isref = StringRef("i")
    print(isref.data)  # => i
    print(isref.length)  # => 1
    print(isref)  # => i

    ## by using the pointer:
    var x3 = "Mojo"
    var ptr = x3.data()
    var str_ref = StringRef(ptr)
    print(str_ref)  # => Mojo

    var x2 = StringRef("hello")
    print(x2.__getitem__(0))  # => h
    print(x2[0])  # => h

    var s1 = StringRef("Mojo")
    var s2 = StringRef("Mojo")
    print(s1 == s2)  # => True
    print(s1 != s2)  # => False
    print(len(s1))  # => 4