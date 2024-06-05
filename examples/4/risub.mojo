struct MyFloat:

    var val: Float16

    fn __init__(inout self, value: Float16):
        self.val = value

struct MyInt:

    var val: Int

    fn __init__(inout self, value: Int):
        self.val = value    

    fn __sub__(self, other: Self) -> Self:
        print("sub invoked")
        return Self(self.val - other.val)

    fn __rsub__(self, other: MyFloat) -> Self:
        print("rsub invoked")
        return Self(int(other.val) - self.val) # Order matters for subtraction; it is not commutative. 

    fn __isub__(inout self, other: Self):
        print("isub invoked")
        self.val = self.val - other.val

fn main():
    var num: MyInt = MyInt(42)

    var sub_res = MyInt(1) - MyInt(2)  # => sub invoked
    print(sub_res.val)                 # -1

    # Even though MyFloat does not implement __sub__ method, subtraction is done with MyInt's __rsub__
    var rsub_res = MyFloat(3.5) - MyInt(2)  # => rsub invoked
    print(rsub_res.val) # => 1

    var isub_res = MyInt(10)
    isub_res -= MyInt(20)  # => isub invoked
    print(isub_res.val)    # -10