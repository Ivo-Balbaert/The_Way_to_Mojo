fn add[cond: Bool = False](a: Int, b: Int) -> Int:
    return a + b if cond else 0


fn main():
    print(add(3, 4))  # => 0 # Default value is taken
    print(add[True](3, 4))  # => 7 # Override the default value
