struct MyStruct:
    var ints: List[Int]

    fn __init__(inout self, ints: List[Int]):
        self.ints = ints

    fn __contains__(self, value: Int) -> Bool:
        for i in self.ints:
            if i[] == value:
                return True
        return False


fn main():
    var my_struct = MyStruct(List(1, 2, 3))
    print(1 in my_struct)  # 1 => True
    print(5 in my_struct)  # 2 => False
