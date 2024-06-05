struct MyFloat:
    var val: FloatLiteral

    fn __init__(inout self, num: FloatLiteral):
        self.val = num

    fn __radd__(self, other: FloatLiteral) -> FloatLiteral:
        print(
            "radd MyFloat invoked", end=" - "
        )  # => running MyNumber 'radd' implementation
        return self.val + other


struct MyInt:
    var val: Int

    fn __init__(inout self, value: Int):
        self.val = value

    fn __add__(self, other: Self) -> Self:
        print("add MyInt invoked")
        return Self(self.val + other.val)

    fn __radd__(self, other: MyFloat) -> Self:
        print("radd MyInt invoked")
        return Self(self.val + int(other.val))

    fn __iadd__(inout self, other: Self):
        print("iadd MyInt invoked")
        self.val = self.val + other.val


fn main():
    var num = MyFloat(40.0)
    print(2.0 + num)  # => radd MyFloat invoked - 42.0

    var num2: MyInt = MyInt(42)

    var add_res = MyInt(1) + MyInt(2)  # => add MyInt invoked
    print(add_res.val)  # => - 3

    # Even though MyFloat does not implement __add__ method, MyInt's __radd__ is invoked
    var radd_res = MyFloat(3.5) + MyInt(2)  # => radd MyInt invoked  
    print(radd_res.val) # => 5

    var iadd_res = MyInt(10)
    iadd_res += MyInt(20) # iadd MyInt invoked 
    print(iadd_res.val)   # => 30