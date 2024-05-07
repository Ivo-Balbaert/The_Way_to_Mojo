# 7 Structs
A struct is a custom data structure that groups related variables of different data types into a single unit that holds multiple values.

Structs exist in all lower-level languages like C/C++ and Rust. You can build high-level abstractions for types (or "objects") in a *struct*. 

A struct in Mojo is similar to a class in Python: they both support methods, fields, operator overloading, decorators for metaprogramming, and so on. 
Fields are variables that hold data relevant to the struct, and methods are functions inside a struct that generally act upon the field data.  
To gain performance, structs are by default stored on the stack, and all fields are memory inlined.
All the data types in Mojo's standard library (such as Int, Bool, String, and Tuple) are defined as structs.

>Note: At this time (Aug 2023), Mojo doesn't have the concept of "class", equivalent to that in Python; but it is on the roadmap.

>Note: Python classes are dynamic: they allow for dynamic dispatch, monkey-patching (or "swizzling"), and dynamically binding instance properties at runtime. However, Mojo structs are completely static - they are bound at compile-time and you cannot add methods at runtime, so they do not allow dynamic dispatch or any runtime changes to the structure. Structs allow you to trade flexibility for performance while being safe and easy to use.

By using a 'struct' (instead of 'class'), the attributes (fields) will be tightly packed into memory, such that they can even be used in data structures without chasing pointers around.

Struct methods are functions, whose first argument is `self` by default.

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

`Self` refers to the type of the struct that you're in, while `self` refers to the actual object
The `self` argument denotes the current instance of the struct. It is similar to the `this` keyword used in some other languages.
It is always the first argument, in __init__ prefixed by inout (because the current instance is about to change). When you make an instance, __init__ is automatically called, but you don't provide a value for self, as in line 2.


A method has a signature like this: `fn method1(self, other parameters)` and when object1 is an instance of its type, the method is called as: `object1.method1(params)`. So `object1` is automatically used as `self`, the first parameter of the method.

Use inout in a method when self is going to change.
Inside its own methods, the struct's type can also be called `Self`.


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
        print(self.first, self.second)

fn pair_test() -> Bool:
    var p = IntPair(1, 2)   # 4 
    p.dump()                # => 1 2
    var q = IntPair(2, 3)
    if p < q:           # 5 
        print("p < q")  # => p < q
    return True

fn main():
   print(pair_test()) # => True
```

The fields of a struct (here lines 1-2) need to be defined as var when they are not initialized, and a type is necessary. 
To make a struct, you need an __init__ method (see however § 11.1). 
The `fn __init__` function (line 3) is an "initializer" - it behaves like a constructor in other languages. It is called in line 4. 
Methods that take the implicit self argument are called *instance methods* because they act on an instance of the struct, like in `p.dump()`.

**Dunder methods**
These structs have so-called *dunder* (short for double underscore) methods, like the
 `__add__` method. 
 Often an equivalent infix or prefix operator can act as 'syntax sugar' for calling such a method. For example: the `__add__` is called with the operator `+`, so you can use the operator in code,which is much more convenient.
 
You can think of dunder methods as interface methods to change the runtime behaviour of types, for example: by implementing `__add__` for `U24`, we are telling the Mojo compiler, how to add (+) two `U24`s.

Common examples are:
* the `__init__` method: this acts as a constructor, creating an instance of the struct.
* the `__del__` method: this acts as a destructor, releasing the occupied memory.
* the `__eq__` method: to test the equality of two values of the same type.  

In line 5, the `<` operator is automatically translated to the __lt__ method.

Try out:
Add the following line just after instantiating the struct:
`return p < 4`          
What do you see?
This returns a compile time error: invalid call to '__lt__': right side cannot be converted from 'Int' to 'IntPair'.

See also `planets.mojo`.( crashes since 0.6.1, see removed_from_test)

Here is another style of writing the __init__ method:
From `nbody.mojo`:
```py
@register_passable("trivial")
struct Planet:
    var pos: SIMD[DType.float64, 4]
    var velocity: SIMD[DType.float64, 4]
    var mass: Float64

    fn __init__(
        pos: SIMD[DType.float64, 4],
        velocity: SIMD[DType.float64, 4],
        mass: Float64,
    ) -> Self:
        return Self {
            pos: pos,
            velocity: velocity,
            mass: mass,
        }
```

**Exercise**
1 -  Define a struct Point for a 3 dimensional point in space. Declare a point variable origin, and print out its items.
(see *exerc7.1.mojo*)
2 -  Define a struct Car with attributes brand, model, year and price. Define two __init__ functions, one which sets the brand and gives model the value "Base", and one which sets all attributes. Make a method that prints all attributes.  
Declare a car with all attributes and print these out. Declare a Car with only a speed, and print out its model.
(see *car.mojo*)

## 7.4 Overloading of methods
We discussed overloading of functions in § 6.6. Because methods are just functions that live inside a struct, they can also be overloaded.

### 7.4.1 Overloaded methods
In the next example a struct Complex is defined representing complex numbers, but it has two __init__ methods, one to define only the real part, and another to define both parts of a complex number: the __init__ constructor is overloaded.

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
    var c1 = Complex(7)
    print (c1.re)  # => 7.0
    print (c1.im)  # => 0.0
    var c2 = Complex(42.0, 1.0)
    c2.im = 3.14
    print (c2.re)  # => 42.0
    print (c2.im)  # => 3.1400001049041748
```
Although we haven't discussed parameters yet (they're different from function arguments), you can also overload functions and methods based on parameters.  

For other examples, which show method and function overloading in the same program, see `employee.mojo` and `overloading2.mojo`.

### 7.4.2 Overloaded operators
(?? First make an exercise/example for Rectangle with the area and perimeter methods, then overloading_operators with only __add__).

In the following code snippet, we define a method __add__ in our struct Rectangle (line 1). Then we can use + as in line 2, adding two rectangles, and this will automatically call the __add__ method. Line 3 shows that both calls have the same result.

See `overloading_operators.mojo`:
```py
struct Rectangle:
    var length: Float32
    var width: Float32

    fn __init__(inout self, length: Float32, width: Float32):
        self.length = length
        self.width = width
        print("Rectangle created with length and width:", self.length, "and width:", self.width)

    fn area(self) -> Float32:
        var area: Float32 = self.length * self.width
        print("The area of the rectangle is:", area)
        return area
    
    fn area(self, side: Float32) -> Float32:
        var area: Float32 = side * side
        print("The area of the square is:", area)
        return area

    fn perimeter(self) -> Float32:
        var perimeter: Float32 = 2 * (self.length + self.width)
        print("The perimeter of the rectangle is:", perimeter)
        return perimeter

    fn __add__(self, other: Rectangle) -> Rectangle:    # 1
        return Rectangle(self.length + other.length, 
                self.width + other.width)

fn main():
    var square = Rectangle(10.0, 10.0)
    # => Rectangle created with length: 10.0 and width: 10.0
    var rect = Rectangle(5.0, 7.0)
    # => Rectangle created with length: 5.0 and width: 7.0
    var squareArea = square.area()
    # => The area of the rectangle is: 100.0
    var squareArea2 = square.area(10.0)
    # => The area of the square is: 100.0
    var rect2 = square + rect                   # 2
    # => Rectangle created with length: 15.0 and width: 17.0
    # this is the same as calling:              
    var rect2b = square.__add__(rect)           # 3
    # => Rectangle created with length: 15.0 and width: 17.0
```

(?? Show error on + when __add__ is not defined)


## 7.5 The __copyinit__ and __moveinit__ special methods
Developers in Mojo have precise control over the lifetime behavior of defined types by choosing to implement or omit certain methods. 
* Initialization (custom construction) is managed using __init__ , 
* Freeing of memory is managed through custom destructors (using the existing __del__ special method), 
* Copying is controlled with __copyinit__ ("deep copy"), 
* Move operations are handled through __moveinit__ .

Mojo uses *value semantics* by default, meaning that in a statement like `var b = a` we expect to create a copy of `a` when assigning to `b` (image ??). However, Mojo doesn't make any assumptions about *how* to copy the value of a. 

Many basic types either don't need a  __copyinit__ method (like Int), or have it implemented in the standard library (like String).

In the above program when typing `var b = square`, which is a *copy* operation from square to b, we get the `error: value of type 'Rectangle' cannot be copied into its destination`. 
The error indicates that Mojo doesn't know how to copy a Rectangle struct, and that we must implement a `__copyinit__` method, which would implement the copying logic.

When a struct has no __copyinit__ method, an instance of that struct cannot be copied.
In the following example a struct HeapArray is defined in line 1. If we try to copy it to another variable b (line 2), we get an `error: value of type 'HeapArray' cannot be copied into its destination`.

?? Use Rectangle example here to copy Rectangle, same error as __add__, --> needs __copyinit__
?? example uses Pointer and should come later ( as esxc?)
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
    var b = a  # <-- copy error: value of type 'HeapArray' cannot be copied into its destination
    b.dump()   
    a.dump()   
```

HeapArray contains an instance of `Pointer` (which is equivalent to a low-level C pointer), and Mojo doesn't know what kind of data it points to or how to copy it. More generally, some types (like atomic numbers) cannot be copied or moved around because their address provides an identity just like a class instance does.

If we then provide that method (see line 2), all works fine:
When executing `let b = a`, b gets substituted for self, and a for rhs. a is on the 'right hand side', that's why we call the 2nd arguments rhs.

See `copy_init.mojo`:
```py
fn __copyinit__(inout self, rhs: Self):         # 2
        self.cap = rhs.cap
        self.size = rhs.size
        self.data = Pointer[Int].alloc(self.cap)
        for i in range(self.size):
            self.data.store(i, rhs.data.load(i))

fn main():
    var a = HeapArray(3, 1)
    a.dump()   # => [1, 1, 1]
    var b = a
    b.dump()   # => [1, 1, 1]
    a.dump()   # => [1, 1, 1]
```

When we comment out __copyinit__, we get the error:
`'HeapArray' is not copyable because it has no '__copyinit__'`.

?? Prove that it is a copy: change original var, copy is not changed, image

Mojo also supports the `__moveinit__` method which allows both Rust-style moves (which frees a value when a lifetime ends) and C++-style moves (where the contents of a value is removed but the destructor still runs), and allows defining custom move logic.
`var b = a^`, after the value is moved, a should no longer exist.

Mojo provides *full control over the lifetime of a value*, including the ability to make types copyable, move-only, and not-movable. This is more control than languages like Swift and Rust offer, which require values to at least be movable.

## 7.6 Using a large struct instance as function argument
Because a fn function gets its arguments only as immutable references, a large struct argument will never cause extensive memory copying.
In the following example the SomethingBig a and b structs are not copied to the function fn use_something_big. This function only gets references (the addresses) to these instances.

See `borrowed0.mojo`:
```py
struct HeapArray:
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

    fn __copyinit__(inout self, other: Self):
        self.cap = other.cap
        self.size = other.size
        self.data = Pointer[Int].alloc(self.cap)
        for i in range(self.size):
            self.data.store(i, other.data.load(i))
            
    fn __del__(owned self):
        self.data.free()

    fn dump(self):
        print_no_newline("[")
        for i in range(self.size):
            if i > 0:
                print_no_newline(", ")
            print_no_newline(self.data.load(i))
        print("]")

struct SomethingBig:
    var id_number: Int
    var huge: HeapArray

    fn __init__(inout self, id: Int):
        self.huge = HeapArray(1000, 0)
        self.id_number = id

    # self is passed by-reference for mutation as described above.
    fn set_id(inout self, number: Int):
        self.id_number = number

    # Arguments like self are passed as borrowed by default.
    fn print_id(self):  # Same as: fn print_id(borrowed self):
        print(self.id_number)

fn use_something_big(borrowed a: SomethingBig, b: SomethingBig):
    """'a' and 'b' are both immutable, because 'borrowed' is the default."""
    a.print_id()  # => 10
    b.print_id()  # => 20

fn main():
    var a = SomethingBig(10)
    var b = SomethingBig(20)
    use_something_big(a, b)
```

The Mojo compiler implements a *borrow checker* (similar to Rust) that prevents code from dynamically forming mutable references to a value when there are immutable references outstanding, and it prevents multiple mutable references to the same value (?? 2023 Sep 8: NOT yet implemented).

## 7.7 Using inout with structs
See also `counter.mojo`

In the following example, we are able to do `x += 1` where x has type MyInt, because the method `__iadd__` is defined (+= is syntax sugar for __iadd__). But this could only work because in that function the self parameter is declared as `inout` (remove inout to see the error that results).

See `inout2.mojo`:
```py
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
    var m = MyInt(10)
    var n = MyInt(20)
    var o = n + m
    print(o.value)  # => 30
    
    var x: MyInt = 42
    x += 1         # 1  # works only because of __iadd__ method
    print(x.value) # => 43
```


**Exercise**
Write a swap function that switches the values of variables x and y (see `swap.mojo`).
(show it in an image, with the addresses)

## 7.8 Transfer struct arguments with owned and ^
(Better call this example:  UniqueNumber, it has nothing to do with pointers)
In the following example, we mimic the behavior of unique pointers. It has a __moveinit__ function (see line 1), which moves the pointer (?? better wording).  
In line 2 `take_ptr(p^)` the ownership of the `p` value is passed to another function take_ptr. Any subsequent use of p (as in line 3) gives the `error: use of uninitialized value 'p' - p is no longer valid here!`

See `transfer_owner.mojo`:
```py
struct UniquePointer:
    var ptr: Int
    
    fn __init__(inout self, ptr: Int):
        self.ptr = ptr
    
    fn __moveinit__(inout self, owned existing: Self):    # 1
        self.ptr = existing.ptr
        
    fn __del__(owned self):
        self.ptr = 0

fn take_ptr(owned p: UniquePointer):
    print("take_ptr")  # => take_ptr
    print(p.ptr)       # => 100

fn use_ptr(borrowed p: UniquePointer):
    print("use_ptr")  # => use_ptr
    print(p.ptr)      # => 100
    
fn work_with_unique_ptrs():
    var p = UniquePointer(100)
    use_ptr(p)    # Pass to borrowing function.
    take_ptr(p^)  # 1 

    # Uncomment to see an error:
    # use_ptr(p) # 2 

fn main():
    work_with_unique_ptrs()  
```

Transfer with ^ is useful when working with unique instances of some type, or when you want to avoid copies.

Another example is a FileDescriptor type. These types are *unique* or *move-only* types. In Mojo, you define the __moveinit__ method to take ownership of a unique type. The consuming move constructor __moveinit__ takes ownership of an existing instance, and moves its internal implementation details over to a new instance.  
You can also define custom __moveinit__ methods. If you want complete control, you should define methods like copy() instead of using the dunder method. 

**Summary**  
* Copyable type (type must have __copyinit__):    var s2 = s1    # s2.__copyinit__(s1) runs here, so s2 is self, s1 is existing (or other, rhs)
* Moveable type (type must have __moveinit__):    var s3 = s1^   # s3.__moveinit__(s1) runs here, so s3 is self, s1 is existing (or other, rhs), s1 is moved
__moveinit__ has as signature:  
`fn __moveinit__(inout self, owned existing: Self):`
    # Initializes a new `self` by consuming the contents of `existing`
__del__ has as signature:  
`fn __del__(owned self):`
    # Destroys all resources in `self`, usually with a free() method.


## 7.9 Compile-time metaprogramming in Mojo
Metaprogramming is about transforming or generating code at compile-time, which is then used at run-time.
One of the great characteristics of Python is that you can change code at runtime, so-called *run-time metaprogramming*. This can do some amazing things, but it comes at a great performance cost.  
The modern trend in programming languages is toward statically compiled languages, with *metaprogramming done at compile-time*! Think about Rust macros, Swift, Zig and Jai. Mojo as a compiled language fully embraces *compile-time metaprogramming*, built into the compiler as a separate stage of compilation - after parsing, semantic analysis, and IR generation, but before lowering to target-specific code. To do this, the same Mojo language is used for metaprograms as for runtime programs, and it also leverages MLIR. This is because Modular's work in AI needs high-performance machine learning kernels, and accelerators, and high abstraction capabilities provided by advanced metaprogramming systems.  

Currently the following techniques are used with metaprogramming:  
1) Parametric types in structs and functions  with compile-time arguments (called parameters in Mojo)(see § 7.9.1)
2) Running arbitrary Mojo code (at compile-time) to set parameter values (alias)
3) Using conditions based on parameter values. (@parameter if)
4) Overloading on parameters (see `overloading_params.mojo`)

### 7.9.1 Parametric types in structs and functions
A **parametric* (generic) struct or function, where you can indicate your own type when you call it, is a very useful concept. It allows you to write flexible code, that can be reused in many situations.

The general format is: 
`Struct[parameters](arguments)`.  
`FunctionName[parameters](arguments)`.  

The parameters serve to define which type(s) are used in a generic type ("parameter" and "parameter expression" represent a compile-time value in Mojo).
The arguments are used as values within the function ("argument" and "expression" refer to runtime values).

Parametric code gets compiled (at compile-time, not JIT-TED at runtime) into multiple specialized versions parameterized by the concrete types used during program execution. 
    
### 7.9.2 Parametric structs
We first encountered this concept in § 4.3.1.1, where we used a List struct as follows:  
`var vec = List[Int]()` 
But it could also have been: 
`var vec = List[Float]()` 
`var vec = List[String]()` 

A List can be made for any type of items (type `AnyType`). The type is parametrized and indicated between the `[]`.
(?? cannot find List in stdlib)

Another example of a parametric struct is the SIMD struct (see § 4.4).  
See also § 12.2.


### 7.9.3 How to create a custom parametric type: Array
Currently (2023 Sep) there is no canonical array type in the stdlib. 
You can make an array instance with SIMD (see § 4.4) or with Tensor or ...

So let's make one ourselves.
In the following example you see the start of code for a parametric type Array, with parameter `AnyRegType` (line 1). It has an __init__ constructor (line 2), which takes the size and a value as arguments.
Line 3 shows how to construct the array: 
`let v = Array[Float32](4, 3.14)`  
* parameter T = Float32
* arguments size is 4 and value is 3.14

See `parametric_array.mojo`:
```py
struct Array[T: AnyRegType]:                           # 1
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
   varv = Array[Float32](4, 3.14)         # 3
    print(v[0], v[1], v[2], v[3])
    # => 3.1400001049041748 3.1400001049041748 3.1400001049041748 3.1400001049041748
```
   
In line 4, memory space is allocated with: `self.data = Pointer[T].alloc(self.cap)`, and the value is stored in the for-loop in line 5.
A destructor `__del__` is also provided, which executes `self.data.free()` and is called automatically when the variable is no longer needed in code execution.
A `__getitem__` method is also shown which takes an index i and returns the value on that position with `self.data.load(i)` (line 7).

**Exercise**
Enhance the code for struct Array with other useful methods like __setitem__, __copyinit__, __moveinit__, __dump__ and so on.
(see `parametric_array2.mojo`, see also https://github.com/Moosems/Mojo-Types and https://github.com/Lynet101/Mojo_community-lib/blob/main/Algorithms/Quicksort/mojo/array.mojo).

See also Vec3f in ray_tracing.mojo (§ 20).


### 7.9.4 Parametric functions and methods
Better example: see parameter2.mojo in § 11.3
Here are some examples of parametric functions:

See `simd3.mojo`:
```py
from math import sqrt, rsqrt

# fn rsqrt[dt: DType, width: Int](x: SIMD[dt, width]) -> SIMD[dt, width]:   # 1
#     return 1 / sqrt(x)

fn main():
    print(rsqrt[DType.float16, 4](42))                                    # 2
    # => [0.154296875, 0.154296875, 0.154296875, 0.154296875]
```

The function `rsqrt[dt: DType, width: Int](x: SIMD[dt, width])` in line 1 is a parametric function. It performs elementwise reciprocal square root on the elements of a SIMD vector, like the definition in line 1. (which is now contained in math).
In line 2, the dt type becomes Float16, the width takes the value 4. The argument x is the SIMD vector (42, 42, 42, 42).

In the following example, we see how parameters (len1 and len2) can be used to form a *parameter expression* len1 + len2:  

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
   vara = SIMD[DType.float32, 2](1, 2)
   varb = SIMD[DType.float32, 2](3, 4)
   varx = concat[DType.float32, 2, 2](a, b)
    print(x) # => [1.0, 2.0, 3.0, 4.0]

    print('result type:', x.element_type, 'length:', len(x))
    # => result type: float32 length: 4
```

Here the function `concat[ty: DType, len1: Int, len2: Int](lhs: SIMD[ty, len1], rhs: SIMD[ty, len2])` is a parametric function, with:  
* parameters: type ty is float32, len1 and len2 are both Int
* arguments: lhs and rhs are resp. a and b, len1 and len2 are both 2

(For:  
   var a = SIMD[DType.float32, 2](1, 2)
   var b = SIMD[DType.float32, 4](3, 4, 5, 6)
we get as result:  
NOT    [1.0, 2.0, 3.0, 4.0, 5.0, 6.0]
    result type: float32 length: 6
but an error:
 call expansion failed - no concrete specializations
    var x = concat[DType.float32, 2, 4](a, b))

### 7.9.5 Programming compile-time logic
You can also write imperative compile-time logic with control flow, even  compile-time recursion. The following example makes use the of the `@parameter if` feature, which is an if statement that runs at compile-time. It requires that its condition be a valid parameter expression, and ensures that only the live branch of the if statement is compiled into the program.

See `ctime_logic.mojo`: ?? these functions already exist in Mojo!
```py
fn slice[ty: DType, new_size: Int, size: Int](
        x: SIMD[ty, size], offset: Int) -> SIMD[ty, new_size]:
    var result = SIMD[ty, new_size]()
    for i in range(new_size):
        result[i] = SIMD[ty, 1](x[i + offset])
    return result

fn reduce_add[ty: DType, size: Int](x: SIMD[ty, size]) -> Int:
    @parameter
    if size == 1:
       return int(x[0])
    elif size == 2:
        return int(x[0]) + int(x[1])

    # Extract the top/bottom halves, add them, sum the elements.
    alias half_size = size // 2
    var lhs = slice[ty, half_size, size](x, 0)
    var rhs = slice[ty, half_size, size](x, half_size)
    return reduce_add[ty, half_size](lhs + rhs)
    
fn main():
    var x = SIMD[DType.index, 4](1, 2, 3, 4)
    print(x) # => [1, 2, 3, 4]
    print("Elements sum:", reduce_add[DType.index, 4](x))
    # => Elements sum: 10
```
## 7.10 Static methods
A struct can also have so-called *static methods*, if they are prefixed by the decorator `@staticmethod`. These methods can be called on the struct type itself (line 1), but also on a struct instance, see line 2.

See `static_methods.mojo`:
```py
struct Logger:
    fn __init__(inout self):
        pass

    @staticmethod
    fn log_info(message: String):
        print("Info: ", message)


fn main():
    Logger.log_info("Static method called.")            # 1
    # => Info:  Static method called.
    var l = Logger()
    l.log_info("Static method called from instance.")   # 2
    # => Info:  Static method called from instance.
```



## 7.11 Lifetimes
Mojo implements eager destruction of variables, that is: the memory is released ASAP, destroying values immediately after last-use. 

Int is a trivial type and Mojo reclaims this memory without need for a __del__() method.
String is a destructible (it has its own __del__() method) and Mojo destroys it as soon as it's no longer used.
This means that a struct which has only String and Int fields doesn't need a destructor.
A struct that contains a pointer (like Array in § 7.9.4 or HeapArray) needs a __del__.

Mojo also has field-sensitive lifetime management: it keeps track separately of whether a "whole object" is fully or only partially initialized or destroyed.  But the "whole object" must be constructed with the aggregate type's initializer (__init__) (not by initializing all individual fields) and destroyed with the aggregate destructor (__del__).

### 7.11.1 Types that cannot be instantiated
These are types from which you cannot create an instance because they have no initializer __init__. To get an instance from them, you need to define an __init__ method or use a decorator like @value that generates an initializer. 

But without initializer, these types can be useful as "namespaces" for helper functions, because you can refer to static members like `NoInstances.my_int` or `NoInstances.print_hello()`.

See `no_instance.mojo`:
```py
struct NoInstances:
    var state: Int
    alias my_int = Int

    @staticmethod
    fn print_hello():
        print("hello world")

fn main():
    NoInstances.print_hello() # => hello world 
```

### 7.11.2 Non-movable and non-copyable types
These can be instantiated, bot not copied or moved, because they have no copy or move constructors. Useful to implement types like atomic operations. 

See example `structs2.mojo` from mojo_gym: perhaps as exercise?

A struct can implement *traits* (see § 8).


- From v 0.4.0: Structs support default parameters
- From v 0.5.0: Structs support keyword parameters, also with defaults (enclosed in [])

