# 7 Structs

Structs exist in all lower-level languages like C/C++ and Rust. Like classes, they have fields and methods, but they are mostly stored on the stack to gain performance.

## 7.1 First example
The following example demonstrates a struct MyInteger with one field called value. In line 2 an instance of the struct called myInt is made. This calls the constructor __init__ from line 1.
In the following lines, the fields is changed and accessed with the dot-notation:

See `struct1.mojo`:
```py
struct MyInteger:
    var value: Int
    fn __init__(inout self, num: Int):   # 1
        self.value = num

fn main():
    var myInt = MyInteger(7)        # 2
    myInt.value = 42
    print(myInt.value)              # => 42
```

The `self` argument denotes the current instance of the struct. Inside its own methods, the struct's type can also be called `Self`.

## 7.2 Comparing a FloatLiteral and a Bool
You normally cannot compare a Bool with a FloatLiteral (instance of the MyNumber here):
But we can if we implement the `__rand__` method on the struct.
Now we can execute the following code as in line 5:

See `struct_compare_bool.mojo`:
```py
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
```

>Note: If you write `print(my_number & True)` you get the error: `MyNumber' does not implement the '__and__' method`   

See also § 4.2.2

## 7.3 The SIMD struct

