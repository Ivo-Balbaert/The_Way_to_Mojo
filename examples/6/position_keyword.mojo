fn func1(first: Int, second: Int, /, third: Int) -> Int:
    return first + second + third


fn main():
    print(func1(1, 2, third=3))  # => 6
    print(func1(1, 2, 3))  # => 6
    # print(func1(first=1, 2, 3))  # error: positional argument follows keyword argument
