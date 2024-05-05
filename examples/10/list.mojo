fn main():
    var vec = List[Int](8)  # 1

    vec.append(10)
    vec.append(20)
    print(len(vec))  # 2 => 3
    print(vec.size)  # => 3

    print(vec.capacity)  # 3 => 4
    # error: 'AnyPointer[Int]' is not subscriptable, it does not implement the `__getitem__`/`__setitem__` methods
    # print(vec.data[0])  # 4 => 10

    print(vec[0])  # 5 => 8
    vec[1] = 42
    print(vec[1])  # => 42
    vec[6] = 10  # 6
    print(len(vec))  # => 3

    var vec2 = vec  # 7
    vec[0] = 99
    print(vec2[0])  # => 8
    vec[1] = 100

    print(len(vec))  # => 3
    print(vec.pop())  # 9 =>
    print(len(vec))  # => 3

    vec.reserve(16)  # 10
    print(vec.capacity)  # => 20
    print("after reserving: ", vec.size)  # => 2

    vec.resize(10, 0)  # 11
    print("after resizing: ", vec.size)  # => 16

    vec.clear()  # 12
    print(vec.size)  # => 0
    print(len(vec))  # => 0
    print(vec[1])  # => 100  - former items are not cleared