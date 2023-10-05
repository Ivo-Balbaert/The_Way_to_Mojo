from utils.vector import InlinedFixedVector, UnsafeFixedVector

fn main():
    var vec = InlinedFixedVector[4, Int](8)  # 1

    vec.append(10)      # 2
    vec.append(20)
    print(len(vec))     # => 2

    print(vec.capacity)             # => 8
    print(vec.current_size)         # => 2
    print(vec.dynamic_data[0])      # => 1  (??)
    print(vec.static_data[0])       # => 10

    print(vec[0])       # => 10
    vec[1] = 42
    print(vec[1])       # => 42

    print(len(vec))     # => 2
    vec[6] = 10
    vec.clear()
    print(len(vec))     # => 0
    
    var vec2 = UnsafeFixedVector[Int](8) # 3
    vec2.append(10)
    vec2.append(20)
    print(len(vec))   # => 2

    print(vec2.capacity)    # => 8
    print(vec2.data[0])     # => 10
    print(vec2.size)        # => 2

    vec2.clear()
    print(vec2[1])          # => 20 
    print(vec2.size)        # => 0






