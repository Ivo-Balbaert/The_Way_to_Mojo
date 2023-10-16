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
    let my_number = MyNumber(1.0) 
    print(True & my_number)
    # => Called MyNumber's __rand__ function
    # => True
    # print(my_number & True) #  error: 'MyNumber' does not implement the '__and__' method
    
   