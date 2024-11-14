# 16 16_Compile time metaprogramming

## 16.1 Compile-time metaprogramming in Mojo
Metaprogramming is about transforming or generating code at compile-time, which is then used at run-time.
One of the great characteristics of Python is that you can change code at runtime, so-called *run-time metaprogramming*. This can do some amazing things, but it comes at a great performance cost.  
The modern trend in programming languages is toward statically compiled languages, with *metaprogramming done at compile-time*! Think about Rust macros, Swift, Zig and Jai. Mojo as a compiled language fully embraces *compile-time metaprogramming*, built into the compiler as a separate stage of compilation - after parsing, semantic analysis, and IR generation, but before lowering to target-specific code. To do this, the same Mojo language is used for metaprograms as for runtime programs, and it also leverages MLIR. This is because Modular's work in AI needs high-performance machine learning kernels, and accelerators, and high abstraction capabilities provided by advanced metaprogramming systems.  

A parameter is like a compile-time variable that becomes a runtime constant. 

Currently the following techniques are used with metaprogramming:  
1) Parametric types in structs and functions with compile-time arguments (called parameters in Mojo)(see § 16.1.1)
2) Running arbitrary Mojo code (at compile-time) to set parameter values (alias)
3) Using conditions based on parameter values. (@parameter if)
4) Overloading on parameters (see `overloading_params.mojo`)
5) defining aliases
6) @unroll

### 16.1.1 Parametric types in structs and functions
A **parametric* (generic) struct or function, where you can indicate your own type when you call it, is a very useful concept. It allows you to write flexible code, that can be reused in many situations.

The general format is: 
`Struct[parameters](arguments)`.  
`FunctionName[parameters](arguments)`.  

The parameters serve to define which type(s) are used in a generic type ("parameter" and "parameter expression" represent a compile-time value in Mojo).
The arguments are used as values within the function ("argument" and "expression" refer to runtime values).

Parametric code gets compiled (at compile-time, not JIT-TED at runtime) into multiple specialized versions parameterized by the concrete types used during program execution. 
    
### 16.1.2 Parametric structs
We first encountered this concept in § 4.3.1.1, where we used a List struct as follows:  
`var vec = List[Int]()` 
But it could also have been: 
`var vec = List[Float]()` 
`var vec = List[String]()` 

A List can be made for any type of items (type `AnyType`). The type is parametrized and indicated between the `[]`.
(!! cannot find List in stdlib)

Another example of a parametric struct is the SIMD struct (see § 4.4).  
See also § 12.2.

You can use defaults and keyword parameters.

### 16.1.3 How to create a custom parametric type: Array
Currently (2023 Sep) there is no canonical array type in the stdlib. 
You can make an array instance with SIMD (see § 4.4) or with Tensor or ...

So let's make a generic array type ourselves.
In the following example you see the start of code for a parametric type Array, with parameter `AnyRegType` (line 1). This means our Array can hold fixed-size data types like integers and floating-point numbers that can be passed in a machine register, but not dynamically allocated data like strings or vectors.

It has an __init__ constructor (line 2), which takes a variable number of arguments.
Line 3 shows how to construct the array: 
`let v =GenericArray[Int](1,2,3,4)`  
* parameter T = Int
* arguments are 1,2,3,4

See `parametric_array.mojo`:
```py
from memory.unsafe_pointer import UnsafePointer, initialize_pointee_copy, destroy_pointee

struct GenericArray[ElementType: CollectionElement]:
    var data: UnsafePointer[ElementType]
    var size: Int

    fn __init__(inout self, *elements: ElementType):                    # 2
        self.size = len(elements)
        self.data = UnsafePointer[ElementType].alloc(self.size)         # 4
        for i in range(self.size):                                      # 5
            initialize_pointee_move(self.data.offset(i), elements[i])

    fn __del__(owned self):
        for i in range(self.size):
            destroy_pointee(self.data.offset(i))
        self.data.free()

    fn __getitem__(self, i: Int) raises -> ref [__lifetime_of(self)] ElementType:
        if (i < self.size):
            return self.data[i]                             # 7
        else:
            raise Error("Out of bounds")

fn main() raises:
    var array = GenericArray[Int](1, 2, 3, 4)               # 3
    for i in range(array.size):
        print(array[i], end=" ")  # => 1 2 3 4
```
   
In line 4, memory space is allocated with: `self.data = UnsafePointer[ElementType].alloc(self.size)`, and the value is stored in the for-loop in line 5.
A destructor `__del__` is also provided (line 8), which executes first a destruction of each CollectionElement in a for loop, and then frees the pointer with: `self.data.free()`. It is called automatically when the variable is no longer needed in code execution.
A `__getitem__` method is also shown which takes an index i; which first checks whether i is in within the bounds of the array, and then returns the value on that position with `self.data[i]` (line 7).


**Exercise**
Enhance the code for struct Array with other useful methods like __setitem__, __copyinit__, __moveinit__, __dump__ and so on.
(see `parametric_array2.mojo`, see also https://github.com/Moosems/Mojo-Types and https://github.com/Lynet101/Mojo_community-lib/blob/main/Algorithms/Quicksort/mojo/array.mojo).

See also Vec3f in ray_tracing.mojo (§ 20).


### 16.1.4 Parametric functions and methods
Parameters in functions must always have a type.
A simple example (from Manual):  `repeat.mojo`:
```py
# parametrized function:
fn repeat[count: Int](msg: String):
    @parameter
    for i in range(count):
        print(msg, end=" - ")

# a generic parametrized function:
fn repeat[MsgType: Stringable, count: Int](msg: MsgType):
    @parameter
    for i in range(count):
        print(msg, end=" - ")

fn main():
    repeat[3]("Hello") # => Hello - Hello - Hello - 

    print()
    # Must use keyword parameter for `count`
    repeat[count=2](42) # => 42 - 42 - 
```

Here are some examples of parametric functions:

1) passing values as parameters:
See `param_val_function.mojo`:
```py
fn div_compile_time[a: Int, b: Int]() -> Float64:
    return a / b


fn main():
    print(div_compile_time[3, 4]())      # 1 => 0.75
    print(div_compile_time[b = 4, a = 3]())  # 2 => 0.75
```

The function div_compile_time has no arguments (), but it has two parameter values 3 and 4, enclosed in []. At compile-time, the code for the function is generated with 3 and 4 substituted into a and b. At runtime (line 1), the function is executed.  
In line 2, we see that we can pass parameter values using the name of the parameter, so-called keyword parameters.

2) passing types as parameters
!! An example with a real type ? (traits) come only in § 13.

See `param_type_function.mojo`:
```py
fn add_ints[T: Intable](a: T, b: T) -> Int: 
    return int(a) + int(b)


fn main():
    print(add_ints[Int](3, 4))          # 1 => 7
    print(add_ints[Float16](3.0, 4.0))  # 2 => 7
    # print(add_ints[String](3.0, 4.0))   # error: cannot bind type 'String' to trait 'Intable'
```
Here we have a generic function add_ints that takes a type T. In line 1, T becomes Int, so a function version is compiled where T is Int. In line 2, T becomes Float16, so another function version is compiled where T is Float16. At runtime these functions get the arguments (3, 4) and (3.0, 4.0) respectively and the result is computed.

Of course, values and types can be used together as parameters.

Just like variadic arguments, you can pas a variable number of parameters:
See `param_variadic.mojo`:
```py
fn add_all[*a: Int]() -> Int:
    var result: Int = 0
    for i in VariadicList(a):
        result += i
    return result


fn main():
    print(add_all[1, 2, 3]())  # => 6
```

Parameters can also have default values, see `param_default.mojo`    :
```py
fn add[cond: Bool = False](a: Int, b: Int) -> Int:
    return a + b if cond else 0


fn main():
    print(add(3, 4))  # => 0 # Default value is taken
    print(add[True](3, 4))  # => 7 # Override the default value
```


see parameter2.mojo in § 11.3 (too complicated with @parameter and closure)

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


**Parametric functions with a variable number of arguments or parameters**
`fn f1[a: Int](*b: Int):`: this parametric function f1 has a variable number of arguments of type Int  
`fn f2[*a: Int](b: Int)`: this parametric function f2 has a variable number of parameters of type Int


### 16.1.5 Programming compile-time logic
You can also write imperative compile-time logic with control flow, even  compile-time recursion. The following example makes use the of the `@parameter if` feature, which is an if statement that runs at compile-time. It requires that its condition be a valid parameter expression, and ensures that only the live branch of the if statement is compiled into the program.

See `ctime_logic.mojo`: !! these functions already exist in Mojo!
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

Fully-bound, partially-bound, and unbound ( _ and *_ )  types: see manual
Automatic parameterization of functions:         see manual