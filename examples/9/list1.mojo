fn main():
    var lst = List[Int](8)  # 1 - same as List(8)
    lst.append(10)  # 1A
    lst.append(20)
    print(len(lst))  # 2 => 3
    print(lst.size)  # => 3
    print(lst.capacity)  # 3 => 4

    for idx in range(len(lst)):  # 3B
        print(lst[idx], end=", ")  # => 8, 10, 20,
    print()

    for n in lst:   # 3C
        print(n[], end=", ")  # => 8, 10, 20,
    print()

    print(lst[0])  # => 8
    lst[1] = 42  # 5
    print(lst[1])  # => 42
    lst[6] = 10  # 6 - no boundaries check!

    var lst2 = lst  # 7 - deep copy
    lst[0] = 99
    print(lst2[0])  # => 8
    for idx in range(len(lst)):
        print(lst[idx], end=", ")  # => 99, 42, 20,
    print()
    for idx in range(len(lst2)):
        print(lst2[idx], end=", ")  # => 8, 20, 20,
    print()

    print(lst.pop())  # 9 => 20
    print(len(lst))   # => 2
    for idx in range(len(lst)):
        print(lst[idx], end=", ")  # => 99, 42,
    print()

    lst.reserve(16)      # 10
    print(lst.capacity)  # => 16
    print("after reserving: ", lst.size)  # => 2
    lst.resize(10, 0)    # 11
    print("after resizing: ", lst.size)  # => 10

    lst.clear()      # 12
    print(lst.size)  # => 0
    print(len(lst))  # => 0
    print(lst[1])    # => 42  - former items are not cleared

    var list = List(1, 2, 4)
    for item in list:  # 13
        print(item[], end=", ")  # => 1, 2, 4, 

    var inputs = List(1.2, 5.1, 2.1)
    var weights = List(3.1, 2.1, 8.7)
    var bias = 3
    var output = inputs[0]*weights[0] + inputs[1]*weights[1] + inputs[2]*weights[2] + bias
    print(output) # => 35.699999999999996

    
