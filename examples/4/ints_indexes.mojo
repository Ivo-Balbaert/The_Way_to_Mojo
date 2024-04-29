fn main():
    var i: Int = 2
    print(i)  # => 2
    var j: IntLiteral = 2
    print(j)  # => 2

    # use as indexes:
    var vec = List[Int]()
    vec.append(2)  # item at index 0
    vec.append(4)  # item at index 1
    vec.append(6)  # item at index 2

    print(vec[i])  # => 6
