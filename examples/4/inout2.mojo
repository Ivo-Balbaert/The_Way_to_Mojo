struct MyInt:
    var value: Int
    
    fn __init__(inout self, v: Int):
        self.value = v
  
    fn __copyinit__(inout self, other: MyInt):
        self.value = other.value
        
    # self and rhs are both immutable in __add__.
    fn __add__(self, rhs: MyInt) -> MyInt:
        return MyInt(self.value + rhs.value)

    # ... but this cannot work for __iadd__
    # Uncomment to see the error:
    fn __iadd__(inout self, rhs: Int):
       self = self + rhs  # ERROR: cannot assign to self!

fn main():
    var m = MyInt(10)
    let n = MyInt(20)
    let o = n + m
    print(o.value)  # => 30
    
    var x: MyInt = 42
    x += 1
    print(x.value) # prints 43 as expected

    