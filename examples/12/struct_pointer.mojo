# from memory.unsafe_pointer import UnsafePointer
from memory import Pointer


struct MyNumber:
    var value_ptr: UnsafePointer[Int]

    fn __init__(inout self, value: Int):
        self.value_ptr = UnsafePointer[Int].alloc(1)  # 1
        initialize_pointee_move(self.value_ptr, value)  # 2

    fn __copyinit__(inout self, other: Self):
        self.value_ptr = UnsafePointer[Int].alloc(1)
        initialize_pointee_copy(self.value_ptr, other.value())

    fn __moveinit__(inout self, owned other: Self):
        self.value_ptr = other.value_ptr
        other.value_ptr = UnsafePointer[Int]()  # empty value

    fn value(self) -> Int:
        return self.value_ptr[]  # 3

    fn change_value(self, value: Int):
        initialize_pointee_move(self.value_ptr, value)

    fn __del__(owned self):
        self.value_ptr.free()

fn main():
    var num = MyNumber(42)
    print("num:", num.value()) # => num: 42

    # copyinit:
    var other_num: MyNumber = num # Calling __copyinit__ on other_num
    print("other_num after copy:", other_num.value()) # => 42
    other_num.change_value(84)
    print("other_num after change:", other_num.value()) # => 84
    print("num after copy:", num.value()) # => 42

    # moveinit
    var other_num2: MyNumber = num^ # Moving
    print("other_num2 after move:", other_num2.value()) # => other_num2 after move: 42
    other_num2.change_value(84)
    print("other_num2 after change:", other_num2.value()) # => other_num2 after move: 84
    # Uncommenting below line results in compiler error as `num` is no longer initialized
    # print("num after copy:", num.value())