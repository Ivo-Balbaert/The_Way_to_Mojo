fn main() raises:    # raised needed because of atoi
    var s = String("abcde")
    print(s) # => abcde

    print(s[0]) # => a
    for i in range(len(s)):     # 1
        print(s[i], end=" ")    # => a b c d e
    # Slicing:
    print(s[2:4]) # => cd       # 2
    print(s[1:])  # => bcde     # 3
    print(s[:5])  # => abcde
    print(s[:-1]) # => abcd     # 4
    print(s[::2]) # => ace      # 5
    
    var emoji = String("🔥😀")
    print("fire:", emoji[0:4])    # 11 => fire: 🔥
    print("smiley:", emoji[4:8])  # => smiley: 😀

    # Appending:
    var x = String("Left")
    var y = String("Right")
    var c = x + y
    c += "🔥"
    print(c) # => LeftRight🔥   # 6

    # Join:
    var j = String("🔥")
    print(j.join('a', 'b')) # => a🔥b     # 7
    print(j.join(40, 2))    # => 40🔥2 

    var sit = StaticIntTuple[3](1,2,3)
    print(j.join(sit)) # => 1🔥2🔥3       # 8

    # Conversion from String to integer: atol
    var n = atol("19")
    print(n)                               # 9 =>
    # var e = atol("hi") # => Unhandled exception caught during execution: 
    # String is not convertible to integer.
    # print(e) 

    print(chr(97))  # => a
    print(ord('a')) # => 97
    print(ord('🔥')) # 9 => -16
    print(isdigit(ord('8'))) # => True
    print(isdigit(ord('a'))) # => False

    var s2 = String(42)
    print(s2) # => 42
    