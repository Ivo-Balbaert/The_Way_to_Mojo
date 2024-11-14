fn add_all[*a: Int]() -> Int:
    var result: Int = 0
    for i in VariadicList(a):
        result += i
    return result


fn main():
    print(add_all[1, 2, 3]())  # => 6
