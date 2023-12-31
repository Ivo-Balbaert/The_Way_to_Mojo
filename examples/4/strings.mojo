fn main():
    # StringLiteral:
    let lit = "This is my StringLiteral"  # 1
    print(lit)  # => This is my StringLiteral

    # lit = 20  # => error: Expression [9]:26:11: cannot implicitly convert 'Int' value to 'StringLiteral' in assignment

    # Conversion to Bool:
    var x = ""
    print(x.__bool__())  # 1B => False
    var y = "a"
    print(y.__bool__())  # 1C => True

    x = "abc"
    y = "abc"
    var z = "ab"
    print(x.__eq__(y))  # 1D => True
    print(x.__eq__(z))  # => False
    print(x == y)  # 1E => True

    z = "ab"
    print(x.__ne__(y))  # => False
    print(x.__ne__(z))  # => True
    print(x != y)  # => False

    let x1 = "hello "
    let y1 = "world"
    let c = x.__add__(y)
    let d = x1 + y1
    print(c)  # => hello world
    print(d)  # => hello world

    x = "string"
    print(x.__len__())  # => 6
    print(len(x))  # => 6

    x = "string"
    let y2 = x.data()
    x = "alo"
    print(y2)  # => string
    print(x)  # => alo

    # print(("hello world")[0]) # => Error: `StringLiteral` is not subscriptable
    # let s2 = "hello world" # s2 is a `StringLiteral`
    # print(s2[:5]) # ERROR: `StringLiteral` is not subscriptable

    # String:
    let s = String("Mojo🔥")  # 3 - is conversion(casting)
    # alternative:
    let s9: String = "Mojo🔥"
    print(s)  # => Mojo🔥
    print(s[0])  # 4 => M
    print(String("hello world")[0])  # => h
    print(ord(s[0]))  # => 77

    # building a string with a DynamicVector:

    from utils.vector import DynamicVector

    var vec = DynamicVector[Int8](2)  # 5
    vec.push_back(78)
    vec.push_back(79)

    from memory.unsafe import DTypePointer

    # 6:
    let vec_str_ref = StringRef(DTypePointer[DType.int8](vec.data).address, vec.size)
    print(vec_str_ref)  # 7 => NO

    vec[1] = 78
    print(vec_str_ref)  # 8 => NN
    let vec_str = String(vec_str_ref)  # 9
    print(vec_str)  # => NN

    vec[0] = 65
    vec[1] = 65
    print(vec_str_ref)  # => AA
    print(vec_str)  # 10 => NN

    # StringRef:
    let isref = StringRef("i")
    # var isref : StringRef = StringRef("a")
    print(isref.data)  # => i
    print(isref.length)  # => 1
    print(isref)  # => i

    ## by using the pointer:
    let x3 = "Mojo"
    let ptr = x3.data()
    let str_ref = StringRef(ptr)
    print(str_ref)  # => Mojo

    let y3 = "string_2"
    let ptry = y3.data()
    let length = len(y)
    let str_ref2 = StringRef(ptry, length)
    print(str_ref2.length)  # => 8
    print(str_ref2)  # => string_2

    let x2 = StringRef("hello")
    print(x2.__getitem__(0))  # => h
    print(x2[0])  # => h

    let s1 = StringRef("Mojo")
    let s2 = StringRef("Mojo")
    print(s1.__eq__(s2))  # => True
    print(s1 == s2)  # => True
    print(s1.__ne__(s2))  # => False
    print(s1 != s2)  # => False
    print(s1.__len__())  # => 4
    print(len(s1))  # => 4
