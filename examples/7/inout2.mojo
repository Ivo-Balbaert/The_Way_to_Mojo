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
    # Comment to see the error: MyInt' does not implement the '__iadd__' method
    fn __iadd__(inout self, rhs: Int):
       self = self + rhs  

fn main():
    let m = MyInt(10)
    let n = MyInt(20)
    let o = n + m
    print(o.value)  # => 30
    
    var x: MyInt = 42
    x += 1         # 1
    print(x.value) # => 43
    