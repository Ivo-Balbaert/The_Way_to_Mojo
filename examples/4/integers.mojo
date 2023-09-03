fn main():
    let i: Int = 2 
    print(i)   # => 2

    # use as indexes:
    var vec = DynamicVector[Int]()
    vec.push_back(2)
    vec.push_back(4)
    vec.push_back(6)

    print(vec[i])  # => 6