struct MyNumber:
    var value: FloatLiteral

    fn __init__(inout self, num: FloatLiteral):
        self.value = num

    fn __radd__(self, rhs: FloatLiteral) -> FloatLiteral:
        print("running MyNumber 'radd' implementation") # => running MyNumber 'radd' implementation
        return self.value + rhs

fn main():
    let num = MyNumber(40.0)
    print(2.0 + num) # => 42.0