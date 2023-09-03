struct MyNumber:
    var value: FloatLiteral
    fn __init__(inout self, num: FloatLiteral):
        self.value = num

    fn __rand__(self, other: Bool) -> Bool:
        print("Called MyNumber's __rand__ function")
        if self.value > 0.0 and other:
            return True
        return False
    
fn main():
    # 5 - ror, rand and rxor
    let my_number = MyNumber(1.0) # => Called MyNumber's __rand__ function
    print(True & my_number)   # => True



