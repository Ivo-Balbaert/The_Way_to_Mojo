fn main():
    # StringLiteral:
    var lit = "This is my StringLiteral"   # 1
    print(lit)  # => This is my StringLiteral

    # lit = 20  # => error: Expression [9]:26:11: cannot implicitly convert 'Int' value to 'StringLiteral' in assignment

    # String:
    from String import String   # 2
    from String import ord

    s = String("Mojo🔥")       # 3
    print(s)            # => Mojo🔥
    print(s[0])         # 4 => M
    print(ord(s[0]))    # => 77

    # building a string with a DynamicVector:
    from Vector import DynamicVector
    let vec = DynamicVector[Int8](2)    # 5
    vec.push_back(78)
    vec.push_back(79)

    from Pointer import DTypePointer
    from DType import DType
    # 6:
    let vec_str_ref = StringRef(DTypePointer[DType.int8](vec.data).address, vec.size)
    print(vec_str_ref) # 7 => NO

    vec[1] = 78
    print(vec_str_ref)  # 8 => NN
    let vec_str = String(vec_str_ref)  # 9
    print(vec_str)      # 9 => NN

    vec[0] = 65
    vec[1] = 65
    print(vec_str_ref)  # => AA
    print(vec_str)      # 10 => NN

    emoji = String("🔥😀")
    print("fire:", emoji[0:4])    # 11 => fire: 🔥
    print("smiley:", emoji[4:8])  # => smiley: 😀
