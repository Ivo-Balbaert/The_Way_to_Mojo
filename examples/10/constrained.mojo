fn add_positives[x: Int, y: Int]() -> UInt8:
    constrained[x > 0, "use a positive number"]()  # 1A
    constrained[y > 0]()  # 1B
    return x + y


fn main():
    var res = add_positives[2, 4]()
    print(res)  # => 6
    # _ = add_positives[-2, 4]()  # 2
    # => error: function instantiation failed
    # => note:               constraint failed: use a positive number
