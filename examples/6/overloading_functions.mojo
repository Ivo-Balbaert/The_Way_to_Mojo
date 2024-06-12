fn add(x: Int, y: Int) -> Int:              # 1
    return x + y

fn add(x: String, y: String) -> String:    # 2
    return x + y

fn main():
    print(add(1, 2)) # => 3
    print(add("Hi ", "Suzy!")) # => Hi Suzy!
    # print(add(1, "Hi")) # 3 => error: 1 cannot be implicitly converted to String
    # print(add(False, "Hi")) # 4 => error: False cannot be implicitly converted to String
    print(add(str(1), "Hi")) # 3 => 1Hi
    print(add(str(False), "Hi")) # 4 => FalseHi
 