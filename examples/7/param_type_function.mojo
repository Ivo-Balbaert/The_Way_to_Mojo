fn add_ints[T: Intable](a: T, b: T) -> Int: 
    return int(a) + int(b)


fn main():
    print(add_ints[Int](3, 4))          # 1 => 7
    print(add_ints[Float16](3.0, 4.0))  # 2 => 7
    # print(add_ints[String](3.0, 4.0)) # error: cannot bind type 'String' to trait 'Intable'