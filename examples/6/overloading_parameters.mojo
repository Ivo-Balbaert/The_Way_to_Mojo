fn add[a: Int, b: Int]() -> Int:
    return a + b


fn add[a: Bool, b: Bool]() -> Int:
    var ai: Int = 1 if a else 0
    var bi: Int = 1 if b else 0
    return ai + bi


fn main():
    print(add[Int(1), Int(2)]())  # => 3
    print(add[True, False]())  # => 1
