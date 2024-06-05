struct MyFloat:
    var val: Float16

    fn __init__(inout self, value: Float16):
        self.val = value


struct MyInt:
    var val: Int

    fn __init__(inout self, value: Int):
        self.val = value

    fn __mul__(self, other: Self) -> Self:
        print("mul invoked")
        return Self(self.val * other.val)

    fn __rmul__(self, other: MyFloat) -> Self:
        print("rmul invoked")
        return Self(int(other.val) * self.val)  # Will truncate

    fn __imul__(inout self, other: Self):
        print("imul invoked")
        self.val = self.val * other.val


fn main():
    var num: MyInt = MyInt(42)

    var mul_res = MyInt(3) * MyInt(2)
    print(mul_res.val)

    var rmul_res = MyFloat(3.5) * MyInt(2)
    print(rmul_res.val)

    var imul_res = MyInt(10)
    imul_res *= MyInt(20)
    print(imul_res.val)


# =>
# mul invoked
# 6
# rmul invoked
# 6
# imul invoked
# 200
