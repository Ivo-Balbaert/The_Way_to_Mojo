# 7 Structs
Structs exist in all lower-level languages like C/C++ and Rust. You can build high-level abstractions for types (or "objects") in a *struct*. 
A struct in Mojo is similar to a class in Python: they both support methods, fields, operator overloading, decorators for metaprogramming, and so on. To gain performance structs are by default stored on the stack .

>Note: At this time (Aug 2023), Mojo doesn't have the concept of "class", equivalent to that in Python; but it is on the roadmap.

>Note: Python classes are dynamic: they allow for dynamic dispatch, monkey-patching (or "swizzling"), and dynamically binding instance properties at runtime. However, Mojo structs are completely static - they are bound at compile-time and you cannot add methods at runtime, so they do not allow dynamic dispatch or any runtime changes to the structure. Structs allow you to trade flexibility for performance while being safe and easy to use.

 By using a 'struct' (instead of 'class'), the attributes (fields) will be tightly packed into memory, such that they can even be used in data structures without chasing pointers around.

## 7.1 First example
The following example demonstrates a struct MyInteger with one field called value. In line 2 an instance of the struct called myInt is made. This calls the constructor __init__ from line 1.
In the following line, the fields is changed and then accessed with the dot-notation:

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

## 7.3 A second example
See `struct2.mojo`:  
```py
struct IntPair:   
    var first: Int          # 1
    var second: Int         # 2

    fn __init__(inout self, first: Int, second: Int):   # 3
        self.first = first
        self.second = second

    fn __lt__(self, rhs: IntPair) -> Bool:
        return self.first < rhs.first or
              (self.first == rhs.first and
               self.second < rhs.second)
    
    fn dump(self):
        print(self.first)
        print(self.second)

fn pair_test() -> Bool:
    let p = IntPair(1, 2)   # 4 
    p.dump()                # => 1
                            # => 2
    let q = IntPair(2, 3)
    if p < q:           # 5 
        print("p < q")  # => p < q

    return True

fn main():
   print(pair_test()) # => True
```

The fields of a struct (here lines 1-2) need to be defined as var when they are not initialized (2023 Sep: let fields are not yet allowed), and a type is necessary. 
To make a struct, you need an __init__ method (see however § 11.1). 
The `fn __init__` function (line 3) is an "initializer" - it behaves like a constructor in other languages. It is called in line 4. 
All methods like it that start and end with __ are called *dunder*  (double-underscore) methods. They are widely used in internal code in MojoStdLib. They can be used directly as a method call, but there are often shortcuts or operators to call them (see the StringLiteral examples in strings.mojo).  
`self` refers to the current instance of the struct, it is similar to the `this` keyword used in some other languages.
In line 5, the `<` operator is automatically translated to the __lt__ method.

Try out:
Add the following line just after instantiating the struct:
`return p < 4`          
What do you see?
This returns a compile time error: invalid call to '__lt__': right side cannot be converted from 'Int' to 'IntPair'.

**Exercise**
Define a struct Point for a 3 dimensional point in space. Declare a point variable origin, and print out its items.
(see *exerc7.1.mojo*)


## 7.4 Overloaded functions and methods
Like in Python, you can define functions in Mojo without specifying argument data types and Mojo will handle them dynamically. This is nice when you want expressive APIs that just work by accepting arbitrary inputs and let *dynamic dispatch* decide how to handle the data. However, when you want to ensure type safety, Mojo also offers full support for overloaded functions and methods.  
This allows you to define multiple functions with the same name but with different arguments. This is a common feature called *overloading*, as seen in many languages, such as C++, Java, and Swift.  
When resolving a function call, Mojo tries each candidate and uses the one that works (if only one works), or it picks the closest match (if it can determine a close match), or it reports that the call is ambiguous if it can’t figure out which one to pick. In the latter case, you can resolve the ambiguity by adding an explicit cast on the call site.  

In the next example a struct Complex is defined for defining complex numbers, but it has two __init__ methods, one to define only the real part, and another to define both parts of a complex number: the __init__ constructor is overloaded.

See `overloading.mojo`:
```py
struct Complex:
    var re: Float32
    var im: Float32

    fn __init__(inout self, x: Float32):
        """Construct a complex number given a real number."""
        self.re = x
        self.im = 0.0

    fn __init__(inout self, r: Float32, i: Float32):
        """Construct a complex number given its real and imaginary components."""
        self.re = r
        self.im = i

fn main():
    let c1 = Complex(7)
    print (c1.re)  # => 7.0
    print (c1.im)  # => 0.0
    var c2 = Complex(42.0, 1.0)
    c2.im = 3.14
    print (c2.re)  # => 42.0
    print (c2.im)  # => 3.1400001049041748
```

You can overload methods in structs and classes and also overload module-level functions.

Mojo doesn’t support overloading solely on result type, and doesn’t use result type or contextual type information for type inference, keeping things simple, fast, and predictable.  
Again, if you leave your argument names without type definitions, then the function behaves just like Python with dynamic types. As soon as you define a single argument type, Mojo will look for overload candidates and resolve function calls as described above.

Although we haven’t discussed parameters yet (they’re different from function arguments), you can also overload structs, functions and methods based on parameters.  

## 7.5 The __copyinit__ and __moveinit__ special methods
For advanced use cases, Mojo allows you to define custom constructors (using Python’s existing __init__ special method), custom destructors (using the existing __del__ special method) and custom copy and move constructors using the new __copyinit__ and __moveinit__ special methods.  

When a struct has no __copyinit__ method, an instance of that struct cannot be copied.
In the following example a struct HeapArray is defined in line 1. If we try to copy it to another variable b (line 2), we get an `error: value of type 'HeapArray' cannot be copied into its destination`.

See `copy_init.mojo`:
```py
from memory.unsafe import Pointer

struct HeapArray:                   # 1
    var data: Pointer[Int]
    var size: Int
    var cap: Int

    fn __init__(inout self):
        self.cap = 16
        self.size = 0
        self.data = Pointer[Int].alloc(self.cap)

    fn __init__(inout self, size: Int, val: Int):
        self.cap = size * 2
        self.size = size
        self.data = Pointer[Int].alloc(self.cap)
        for i in range(self.size):
            self.data.store(i, val)

    fn __del__(owned self):
        self.data.free()

    fn dump(self):
        print_no_newline("[")
        for i in range(self.size):
            if i > 0:
                print_no_newline(", ")
            print_no_newline(self.data.load(i))
        print("]")

fn main():
    var a = HeapArray(3, 1)
    a.dump()  
    let b = a  # <-- copy error: value of type 'HeapArray' cannot be copied into its destination
    b.dump()   
    a.dump()   
```

HeapArray contains an instance of `Pointer` (which is equivalent to a low-level C pointer), and Mojo doesn’t know what kind of data it points to or how to copy it. More generally, some types (like atomic numbers) cannot be copied or moved around because their address provides an identity just like a class instance does.

If we then provide that method (see line 2), all works fine:
When executing `let b = a`, b gets substituted for self, and a for other.

See `copy_init.mojo`:
```py
fn __copyinit__(inout self, other: Self):         # 2
        self.cap = other.cap
        self.size = other.size
        self.data = Pointer[Int].alloc(self.cap)
        for i in range(self.size):
            self.data.store(i, other.data.load(i))

fn main():
    let a = HeapArray(3, 1)
    a.dump()   # => [1, 1, 1]
    let b = a
    b.dump()   # => [1, 1, 1]
    a.dump()   # => [1, 1, 1]
```

Mojo also supports the `__moveinit__` method which allows both Rust-style moves (which take a value when a lifetime ends) and C++-style moves (where the contents of a value is removed but the destructor still runs), and allows defining custom move logic.

Mojo provides *full control over the lifetime of a value*, including the ability to make types copyable, move-only, and not-movable. This is more control than languages like Swift and Rust offer, which require values to at least be movable.

## 7.7 Improving performance with the SIMD struct
Mojo can use SIMD (Single Instruction, Multiple Data) on modern hardware that contains special registers. These registers allow you do the same operation across a vector in a single instruction, greatly improving performance.

Mojo’s SIMD struct type is defined as a struct in the builtin `simd` module and exposes the common SIMD operations in its methods, making the SIMD data type and size values parametric. This allows you to directly map your data to the SIMD vectors on any hardware.
The SIMD struct is a generic struct type definition (see § 7.8.1).

General format: `SIMD[DType.type, size]`  
* type specifies the data type, for example: uint8, float32, it is given by the field `element_type` 
* the `len` function gives the size (which must be a power of 2) of the SIMD vector, for example 1, 2, 4, and so on

`UInt8` is just a *type alias* for `SIMD[DType.uint8, 1]`, 
which is the same as `SIMD[ui8, 1]`.  
All numeric types (see $ 4.2 and the DType class) are defined as aliases in terms of SIMD:  
* Int8 = SIMD[si8, 1]
* UInt8 = SIMD[ui8, 1]
* Int16 = SIMD[si16, 1]
* UInt16 = SIMD[ui16, 1]
* Int32 = SIMD[si32, 1]
* UInt32 = SIMD[ui32, 1]
* Int64 = SIMD[si64, 1]
* UInt64 = SIMD[ui64, 1]
* Float16 = SIMD[f16, 1]
* Float32 = SIMD[f32, 1]
* Float64 = SIMD[f64, 1]

Here is an example of a simd struct with size 4: `SIMD[DType.uint8, 4](1, 2, 3, 4)`

Here is some code using this feature:
See simd.mojo:
```py
from sys.info import simdbitwidth

fn main():
    let zeros = SIMD[DType.uint8, 4]()       # 0
    print(zeros)  # => [0, 0, 0, 0]

    var y = SIMD[DType.uint8, 4](1, 2, 3, 4)  # 1
    print(y)  # => [1, 2, 3, 4]

    y *= 10                                 # 2
    print(y)  # => [10, 20, 30, 40]

    let z = SIMD[DType.uint8, 4](1)         # 3
    print(z)  # => [1, 1, 1, 1]

    print(simdbitwidth())  # => 256         # 4  
```

SIMD is also a generic type, indicated with the [ ] braces. We need to indicate the item type and the number of items, as is done in line 1 when declaring the SIMD-vector y.
Line 0 initializes a SIMD vector with zeros as values.  
DType.uint8 and 4 are called *parameters*. They must be known at compile-time.  
(1, 2, 3, 4) are the *arguments*, which can be compile-time or runtime known (for example: user input or data retrieved from an API).

y is now a vector of 8 bit numbers that are packed into 32 bits. We can perform a single instruction across all of it instead of 4 separate instructions, like *= shown in line 2.  
If all items have the same value, use the shorthand notation as for z in line 3.  

To show the SIMD register size on the current machine, use the function `simdbitwidth` from module `sys.info` as in line 4. The result `256` means that we can pack 32 x 8bit numbers together and perform a calculation on all of these with a single instruction.

**Exercises**
1- Initialize two single floats with 64 bits of data and the value 2.0, using the full SIMD version, and the shortened alias version, then multiply them together and print the result.
(see `exerc7.2.🔥`)
2- Create a loop using SIMD that prints four rows of data that look like this:
    [1,0,0,0]
    [0,1,0,0]
    [0,0,1,0]
    [0,0,0,1]

Hint: Use a loop: for i in range(4):
                        pass
(see `exerc7.3.🔥`)

Other example: see simd2.mojo,

## 7.8 Parametric types in structs and functions
A **parametric* (generic) struct or function where you can indicate your own type is a very useful concept. It allows you to write flexible code, that can be reused in many situations.

The general format is: `StructOrFunctionName[parameters](arguments)`.  
The parameters serve to define which type(s) are used in a generic type.
The arguments are used as values within the function.

## 7.8.1 Parametric structs
We first encountered this in § 4.2.1, where we defined a DynamicVector as follows:  
`var vec = DynamicVector[Int]()` 
But it could also have been: 
`var vec = DynamicVector[Float]()` 
`var vec = DynamicVector[String]()` 

A DynamicVector can be made for any type of items (type `AnyType`). The type is parametrized and indicated between the `[]`.

Another example is the SIMD struct (see § 7.8).  
See also § 12.2.

Parametric code gets compiled into multiple specialized versions parameterized by the concrete types used during program execution. 

## 7.8.2 Parametric functions and methods
Here are some examples of parametric functions:

See `simd3.mojo`:
```py
from math import sqrt

fn rsqrt[dt: DType, width: Int](x: SIMD[dt, width]) -> SIMD[dt, width]:   # 1
    return 1 / sqrt(x)

fn main():
    print(rsqrt[DType.float16, 4](42))                                    # 2
    # => [0.154296875, 0.154296875, 0.154296875, 0.154296875]
```

The function `rsqrt[dt: DType, width: Int](x: SIMD[dt, width])` in line 1 is a parametric function. In line 2, the dt type becomes Float16, the width takes the value 4. The argument x is the SIMD vector (42, 42, 42, 42).


See `simd4.mojo`:
```py
fn concat[ty: DType, len1: Int, len2: Int](
        lhs: SIMD[ty, len1], rhs: SIMD[ty, len2]) -> SIMD[ty, len1+len2]:

    var result = SIMD[ty, len1 + len2]()
    for i in range(len1):
        result[i] = SIMD[ty, 1](lhs[i])
    for j in range(len2):
        result[len1 + j] = SIMD[ty, 1](rhs[j])
    return result

fn main():
    let a = SIMD[DType.float32, 2](1, 2)
    let b = SIMD[DType.float32, 2](3, 4)
    let x = concat[DType.float32, 2, 2](a, b)
    print(x) # => [1.0, 2.0, 3.0, 4.0]

    print('result type:', x.element_type, 'length:', len(x))
    # => result type: float32 length: 4
```

Here the function `concat[ty: DType, len1: Int, len2: Int](lhs: SIMD[ty, len1], rhs: SIMD[ty, len2])` is a parametric function, with:  
* parameters: type ty is float32, len1 and len2 are both 2
* arguments: lhs and rhs are resp. a and b, len1 and len2 are both 2

## 7.8.3 How to create a custom parametric type: Array
In the following example you see the code for a parametric type Array, with parameter `AnyType` (line 1). It has an __init__ constructor (line 2), which takes the size and a value as arguments.
Line 3 shows how to construct the array: 
`let v = Array[Float32](4, 3.14)`  
* parameter T = Float32
* arguments size is 4 and value is 3.14

See `parametric_array.mojo`:
```py
struct Array[T: AnyType]:                           # 1
    var data: Pointer[T]
    var size: Int
    var cap: Int

    fn __init__(inout self, size: Int, value: T):   # 2
        self.cap = size * 2
        self.size = size
        self.data = Pointer[T].alloc(self.cap)      # 4
        for i in range(self.size):
            self.data.store(i, value)               # 5
              
    fn __getitem__(self, i: Int) -> T:
        return self.data.load(i)            # 7

    fn __del__(owned self):
        self.data.free()                    # 6

fn main():
    let v = Array[Float32](4, 3.14)         # 3
    print(v[0], v[1], v[2], v[3])
    # => 3.1400001049041748 3.1400001049041748 3.1400001049041748 3.1400001049041748
```
   
In line 4, memory space is allocated with: `self.data = Pointer[T].alloc(self.cap)`, and the value is stored in the for-loop in line 5.
A destructor `__del__` is also provided, which executes  `self.data.free()` and is called automatically when the variable is no longer needed in code execution.
A `__getitem__` method is also shown which takes an index i and returns the value on that position with `self.data.load(i)` (line 7).


