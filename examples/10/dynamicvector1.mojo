from collections.vector import DynamicVector

fn main():
    var vec = DynamicVector[Int](8)  # 1

    vec.push_back(10)
    vec.push_back(20)
    print(len(vec))     # 2 => 2
    print(vec.size)     # => 2

    print(vec.capacity) # 3 => 8
    # error: 'AnyPointer[Int]' is not subscriptable, it does not implement the `__getitem__`/`__setitem__` methods
    # print(vec.data[0])  # 4 => 10
   
    print(vec[0])       # 5 => 10
    vec[1] = 42     
    print(vec[1])       # => 42
    print(len(vec))     # => 2
    vec[6] = 10         # 6
    print(len(vec))     # => 2

    let vec2 = vec      # 7
    vec[0] = 99
    print(vec2[0])      # => 99
    vec[1] = 100

    print(len(vec))     # => 2
    print(vec.pop_back()) # 9 => 
    print(len(vec))     # => 1

    vec.reserve(16)     # 10
    print(vec.capacity) # => 16
    print("after reserving: ", vec.size)     # => 1

    vec.resize(10, 0)      # 11
    print("after resizing: ", vec.size)     # => 10
    
    vec.clear()         # 12
    print(vec.size)     # => 0
    print(len(vec))     # => 0
    print(vec[1])       # => 1  - former items are not cleared
