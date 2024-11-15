# 4 Basic types
!! Interesting topics from: https://docs.modular.com/mojo/manual/types
- nominal types (struct!!), nominal and structural typing, other types 
- types defined in the standard library, not in the language itself
- Using Int as the default integer type
- rounding errors etc with floats
- literal types: arbitrary precision at compile-time
- Stringable will implicitly convert String:
var s = str("Items in list: ") + 5
- convert StringLiteral values to String using the built-in str() method, example: concatenation
var a = 5
var b = "String literals may not concatenate"
print(a + b)

In Mojo, all values have an associated data type. Most of these types are nominal types, defined by a struct. These types are nominal (or "named") because type equality is determined by the type's name, not its structure. 
Some types that aren't defined as structs include functions, which are typed based on their signatures, 
and NoneType, which is a type with one instance, the None object, used to signal "no value" source (https://docs.modular.com/mojo/manual/types).

The most common types are built-in types, which are always available and don't need to be imported. These include types for numeric values, strings, boolean values, and others. The standard library also includes many more types that you can import as needed, including collection types, utilities for interacting with the filesystem and getting system information, and so on source (https://docs.modular.com/mojo/manual/types).

The Mojo standard library also includes a set of basic collection types that can be used to build more complex data structures. These include List, Dict, Set, and Optional. The collection types are generic types: while a given collection can only hold a specific type of value (such as Int or Float64), you specify the type at compile time using a parameter source (https://docs.modular.com/mojo/manual/types#collection-types).




All data values have a corresponding data *type*.
Mojo's basic types are defined as built-ins, defined in the package `builtin`. 
??They are automatically imported in code (not anymore since v 24.5). These include the Bool, Int, IntLiteral, FloatLiteral, String and StringLiteral types, which we'll discuss in this section. They are all defined as a struct (see § 7).

Composite types contain one or more values and will be discussed in § 9 and beyond. These values can be of the same type (homogeneous) or of different types (heterogeneous).

## 4.1 The data type DType
The `builtin` package contains the `dtype` module, home of the `DType` type. `DType` is like an umbrella type for the bool and numeric types. 
It has the following aliases:  
* bool = bool: Represents a boolean data type.
* int8 = si8: Represents a signed integer type whose bitwidth is 8.
* uint8 = ui8: Represents an unsigned integer type whose bitwidth is 8.
* int16 = si16: Represents a signed integer type whose bitwidth is 16.
* uint16 = ui16: Represents an unsigned integer type whose bitwidth is 16.
* int32 = si32: Represents a signed integer type whose bitwidth is 32.
* uint32 = ui32: Represents an unsigned integer type whose bitwidth is 32.
* int64 = si64: Represents a signed integer type whose bitwidth is 64.
* uint64 = ui64: Represents an unsigned integer type whose bitwidth is 64.
* bfloat16 = bf16: Represents a brain floating point value whose bitwidth is 16.
* float16 = f16: Represents an IEEE754-2008 binary16 floating point value.
* float32 = f32: Represents an IEEE754-2008 binary32 floating point value.
* float64 = f64: Represents an IEEE754-2008 binary64 floating point value.

* type = dtype
* invalid = invalid: Represents an invalid or unknown data type.

The bitwidth for the following aliases is determined as: 32-bit on 32-bit machines and 64-bit on 64-bit machines.
* index = index: Represents an integral type whose bitwidth is the maximum integral value on the system.
* address = address: Represents a pointer type whose bitwidth is the same as the bitwidth of the hardware's pointer type.

For example: `DType.uint8` can be used in code whenever you need an unsigned integer type of bitwidth 8.

>Note that DType.float64 isn't a type, it's a value that describes a data type. You can't create a variable with the type DType.float64. You can create a variable with the type 
SIMD[DType.float64, 1] (or Float64, which is the same thing).
```
var f : DType.float64    # error: expected a type, not a value
var f : Float64          # ok
```

DType has a lot of methods to test types, for example `is_uint8` checks whether the type is uint8. 
In the following snippet, inspect is a generic function that inspects the type
```py
fn inspect(type: DType):
        print("Is unit8::", type.is_uint8())
        print("Is signed:", type.is_signed())
    
inspect(DType.float16) 
```

DType is specifically used in providing compile time optimization by creating specialized code for a particular type.



A *scalar* just means a single value in Mojo. The scalar types include the Bool type (see § 4.2), as well as the numerical types, which are all based on SIMD (see § 4.4).
The following code shows how to define a scalar with the `Scalar` type:
`s = Scalar[DType.int32](42)`

The following code shows that a scalar is equivalent to its numeric type.  

See `int_scalar.mojo`:
```py
from testing import assert_equal

def main():
    a = Int32(42)
    b = Scalar[DType.int32](42)
    assert_equal(a, b) #  # Int32 is Scalar[DType.int32]
```

Following are some type-aliases defined in stdlib:  
```py
alias Scalar = SIMD[size=1]
alias Int8 = Scalar[DType.int8]
alias Float32 = Scalar[DType.float32]
```

## 4.2  The Bool type
Defined in the module `bool` as a struct, `Bool` has only 2 values: `True` and `False`. 
It is constructed from an i1 value (a ` __mlir_type.i1` value), which takes only one bit of memory.
Among its methods are bool, invert, eq, ne, and, or, xor, rand, ror, rxor.  
>Note: Struct methods in Mojo often can be written with a prefix or infix `operator`, which translates to a so-called `dunder` method. This names comes from 'double underscore' or __ (sometimes also written with a small blanc space between the _, like _ _) (see § 7.3).

Here are some examples of code with booleans and operators/dunder methods:
See `bools.mojo`:
```py
fn main():
    var x: Bool = True   # equivalent: var x = True
    print(x)        # => True
    x = False
    print(x)        # 1 => False

    # 2 - Invert (~)
    print(~False)             # => True  # equivalent:  print(False.__invert__()) 

    # 3 - eq and ne (== !=)
    print(True == False)      # => False # equivalent:  print(True.__eq__(False))  
    print(True != False)      # => True  # equivalent:  print(True.__ne__(False))  

    # 4 - and, or and xor
    print(True & False)       # => False # equivalent:  print(True.__and__(False)) 
    print(False | False)      # => False # equivalent:  print(False.__or__(False))
    print(True ^ False)       # => True  # equivalent:  print(True.__xor__(False))

    # 5 Conversion to Bool:
    var b1 = (42).__bool__()
    print(b1)                  # => True
    var b2 = (0).__bool__()
    print(b2)                  # => False
    var b3 = ("Mojo").__bool__()
    print(b3)                  # => True
```

Reversing the value is done with the prefix `~` operator, which translates to the `__invert__` method (see line 2).
Equality is tested with the infix `==` operator, which translates to the `__eq__` method.  
Non-equality is tested with the `!=` operator, equivalent to the `__ne__` method.
The and operator is `&`, and its method is `__and__`. It is True only if both values are True.
The or operator is `|`, and its method is `__or__`. It is True if at least one of both values is True.
The xor (exclusive or) operator is `^`, , and its method is `__xor__`. outputs True if exactly one of two inputs is True.

You can convert other type values to a Bool value with the `__bool__` method, see line 5. 
--> Try out in the REPL if you can convert a String value to Bool.

We discuss the r-methods (__rand__, __ror__, __rxor__) in § 4.3.2.3-4.

Now we discuss the different number types of numbers. Then in the next section (see § 4.4), we shall see how they can be used in SIMD operations.


## 4.3 Numerical types
These are the numerical types:
>Note: a 'literal' is a constant value.

* IntLiteral: this is a static literal value with infinite precision; compile time calculations can be done with very high precision.
* FloatLiteral: this is a floating point literal
* Int  
* Int8, Int16, Int32, Int64
* UInt8, UInt16, UInt32, UInt64
* Float32
* Float64

The prefix U means the type is unsigned. The number at the end refers to the number of bits used for storage, so UInt32 is an unsigned 32 bits/4 bytes integer number.
All numeric types are derived from a SIMD type for performance reasons (see § 4.4).

### 4.3.1 The Integer types
The integer types are defined in modules `int` and `int_literal`. 

`Int` is the same size as the architecture of the computer, so on a 64 bit machine it's 64 bits wide. Internally it is defined as a struct.

A small handy detail: _ can be used to separate thousands in IntLiteral values:  `10_000_000`

Equality is checked with ==, the inverse is !=
The following normal operators exist: -, <, >, <=, >=, + (add), - (sub), *, / (returns a Float).
Mojo allows you to define custom bitwidth integers (see § 14.6 Custom bitwidth integers).

#### 4.3.1.1 Using Ints as indexes
Integers can also be used as indexes, as shown in the following example. Here the parametrized type List (from module `collections.list`) takes Int as the type of its elements:

See `ints_indexes.mojo`:
```py
fn main():
    var i: Int = 2 
    print(i)   # => 2
    var j: IntLiteral = 2
    print(j)  # => 2

    # use as indexes:
    var vec = List[Int]()
    vec.append(2)  # item at index 0
    vec.append(4)  # item at index 1
    vec.append(6)  # item at index 2

    print(vec[i])  # => 6
```

### 4.3.1.2 Converting integers
The type name can be used to convert a value to the type (if possible):
`Type(value)`, see line 1.  
For example: `UInt8(1)` makes sure the value 1 is stored as an unsigned 1 byte integer.

There is also a `cast` method to convert to another type.  
The general format of a cast is: `value.cast[to_type]()` (see line 3):
See `int_casting.mojo`:
```py
fn main():
    var n = UInt8(42)    # 1
    print(n) # => 42
    var x : UInt8 = 42   # 2   
    print(x) # => 42
    var y : Int8 = x.cast[DType.int8]() # 3
    print(y) # => 42
         
    var w : Int = int(x)      # 4: `SIMD` to `Int`
    print(x) # => 42
    var z : UInt8 = w         # 5: `Int` to `SIMD`
```

>Note: As we will shortly in § 4.4, numbers and SIMD are closely related. Because UInt8 is an alias for SIMD[DType.uint8, 1], lines 3 and 4 can be seen as casts from a SIMD value to an int. Line 5 does the opposite conversion.

The integer type is different from the Python int type (see: https://docs.modular.com/mojo/programming-manual.html#int-vs-int). One difference is that Mojo's Int type is fixed, it can't work with big numbers. But the Python int can, so we can use that from Mojo! 

#### 4.3.1.3 Converting Bool to Int
This is simply one by converting with UInt8(), as we did in the previous section.

See `convert_bool.mojo`:
```py
fn main():
    var b1: Bool = True
    var m = UInt8(b1)
    print(m)  # => 1
    var b2: Bool = False
    var n = UInt8(b2)
    print(n)  # => 0
```

We see that True converts to 1, and False to 0.

#### 4.3.1.4 Handling big integers
The integer types in Mojo are all constrained, the largest type Int or Int64 is 64-bits wide.
In § 8.4.5 we show you how to handle big integers within Mojo, by using Python int's.

### 4.3.2 The Float types
The floating point types live in module `float_literal`.
A FloatLiteral takes the machine word-size (for example 64 bit) as default type. 

#### 4.3.2.1 Declarations and conversions
Conversions in Mojo are performed by using the constructor as a conversion function as in: 
`Float32(value_to_convert)`. 

See `floats.mojo`:
```py
fn main():
    var i: IntLiteral = 2
    var x = 10.0
    print(x)  # => 10.0
    var float: FloatLiteral = 3.3
    print(float)  # => 3.2999999999999998
    var f32 = Float32(float)  # 1
    print(f32)  # => 3.2999999523162842
    var f2 = FloatLiteral(i)  # 2
    print(f2)  # => 2.0
    var f3 = Float32(i) # 3
    print(f3)  # => 2.0

    var a = 40.0
    a += 2.0
    print(a)  # => 42.0

    # Conversions:
    # var j: Int = 3.14  # error: cannot implicitly convert 'FloatLiteral' value to 'Int'
    # var j = Int(3.14)  # error: cannot construct 'Int' from 'FloatLiteral' value in 'var'
    # var i2 = Int(float) # convert error
    # var i2 = Int(f32) # convert error

    var j = FloatLiteral(3.14).__int__()
    print(j)  # => 3 
```

A conversion from a 64 bit FloatLiteral to a Float32 works, but looses some precision (see line 1). As shown above in lines 2-3, conversion from an Int to FloatLiteral or Float32 works, but not from an Int to a FloatLiteral. Conversion from FloatLiteral to an Int is done with: `FloatLiteral.__int__()`.

All normal operations exist.
// (floordiv): Returns lhs divided by rhs rounded down to the next whole number:  
`print(5.0 // 2.0) => 2.0`
% (mod): Returns the remainder of lhs divided by rhs: 
`print(5.0 % 2.0) => 1.0`
** (pow)


#### 4.3.2.2 The i (in-place) operations
These are the i operations: iadd (with operator +=), isub, imul, itruediv, ifloordiv, imod, ipow
i stands for in-place, the lhs becomes the result of the operation, a new object is not created.

```py
var a = 40.0
a += 2.0 # this runs __iadd__
print(a)  # => 42.0
```

Same for: -=, *=, /=, %=, //=, **=

>Note: In the following sections we use a simple struct definition MyNumber. __init__ is kind of a constructor, called when an instance of the struct is made. For more details, see § 7.

#### 4.3.2.3 The r (right hand side or rhs) operations
These operations are: radd, rsub, rmul, rtruediv, rfloordiv, rmod, rpow:  
They allow to define the base operations for types that by default don't work with them.
Think of the r as reversed, for example: in a + b, if a doesn't implement __add__, 
then b.__radd__(a) will run instead if __radd__ is defined for b.
(reverse addition is used when we try to add two values, where the first value does not have __add__ implemented. In this case, the Mojo compiler checks if the second value has __radd__ implemented, and it calls that one.)

In the following example, we define _radd_ for the struct MyNumber, so that we can add its value to a FloatLiteral (note that the struct instance is the rhs in the expression `2.0 + num`):
Here is an example  demonstrating both iadd and radd methods:
Example: see `ri    add.mojo`:
```py
struct MyFloat:
    var val: FloatLiteral

    fn __init__(inout self, num: FloatLiteral):
        self.val = num

    fn __radd__(self, other: FloatLiteral) -> FloatLiteral:
        print(
            "radd MyFloat invoked", end=" - "
        )  # => running MyNumber 'radd' implementation
        return self.val + other


struct MyInt:
    var val: Int

    fn __init__(inout self, value: Int):
        self.val = value

    fn __add__(self, other: Self) -> Self:
        print("add MyInt invoked")
        return Self(self.val + other.val)

    fn __radd__(self, other: MyFloat) -> Self:
        print("radd MyInt invoked")
        return Self(self.val + int(other.val))

    fn __iadd__(inout self, other: Self):
        print("iadd MyInt invoked")
        self.val = self.val + other.val


fn main():
    var num = MyFloat(40.0)
    print(2.0 + num)  # => radd MyFloat invoked - 42.0

    var num2: MyInt = MyInt(42)

    var add_res = MyInt(1) + MyInt(2)  # => add MyInt invoked
    print(add_res.val)  # => - 3

    # Even though MyFloat does not implement __add__ method, MyInt's __radd__ is invoked
    var radd_res = MyFloat(3.5) + MyInt(2)  # => radd MyInt invoked  
    print(radd_res.val) # => 5

    var iadd_res = MyInt(10)
    iadd_res += MyInt(20) # iadd MyInt invoked 
    print(iadd_res.val)   # => 30
```

(First comment out __radd__ to see which error you get when this method is not defined. Explain the error/)

See also:  `risub.mojo`,  `rimul.mojo`

#### 4.3.2.4 Comparing a FloatLiteral and a Bool
The Bool type also has rhs equivalents of __and__ and so on, like __rand__, __ror__, __rxor__. Here the Bool value is automatically used at the rhs of the operator.

You normally cannot compare a Bool with a FloatLiteral (which is an instance of the MyNumber struct here). But we can if we implement the `__rand__` method on the struct.
Then we can execute the following code as in line 5:

See `bool_anding_struct.mojo`:
```py
struct MyNumber:
    var value: FloatLiteral
    fn __init__(inout self, num: FloatLiteral):
        self.value = num

    fn __rand__(self, lhs: Bool) -> Bool:
        print("Called MyNumber's __rand__ function")
        if self.value > 0.0 and lhs:
            return True
        return False

fn main():
   varmy_number = MyNumber(1.0) 
    print(True & my_number)   
    # => Called MyNumber's __rand__ function
    # => True
```

>Note: Which error do you get when calling `print(my_number & True)`? Explain.
(You get the error: `MyNumber' does not implement the '__and__' method`   )


## 4.4 SIMD
?? needs parametric struct type (§ 16)
Mojo relies heavily on using [SIMD](https://en.wikipedia.org/wiki/Single_instruction,_multiple_data) in calculations to enhance performance. All math functions work on SIMD items. That's why the `SIMD` type is also defined as a struct in its own module `builtin.simd`. 

### 4.4.1 Defining SIMD vectors
Mojo can use SIMD (Single Instruction, Multiple Data) on modern hardware that contains special registers. These registers allow you to do the same operation on all elements of a 'vector' in a single instruction, greatly improving performance. So SIMD works on a number of items *in parallel*. Moreover, it is fast because the vector registers are the fastest kind of memory access at the hardware level.

The type of a value that can be processed by a SIMD-register is called *register-passable* and is of type `AnyRegType`.

>Note: a `vector` is like an array of numbers, for example [1, 15, 25, 43] is an integer vector with 4 elements. An example of SIMD would be to multiply all 4 items of the vector by 3 in a single CPU instruction.

SIMD is a core type in Mojo: 
- all scalars are of SIMD type and width 1:
See `scalar_simd.mojo`:
```py
from testing import assert_equal

def main():
    a = Scalar[DType.int32](42)
    b = SIMD[DType.int32, 1](42)
    assert_equal(a, b) 
```
- all math functions work with SIMD elements

Here is an example of a simd vector with size 4:  
`a = SIMD[DType.uint8, 4](1, 2, 3, 4)`
which is printed out as: `print(a)` # => [1, 2, 3, 4]

The general format to define a SIMD vector is: `SIMD[DType.type, size]`  
It has two parameters: 
* the type specifies the data type, for example: uint8, float32. It is also given by the field `element_type`. 
* the size (or width) is given by the `len` function. The size of the SIMD vector must be a power of 2, for example 1, 2, 4, 8, and so on. The number of elements is often called the `group_size`.
The type and size are parameters, which allow you to directly map your data to the SIMD vectors adapted to your hardware.

>Note:  The SIMD struct is an example of a parametric struct type definition (see § 7.9.1).

All numeric types (see $ 4.3) are defined as aliases in terms of SIMD:  
`UInt8` is just a *type alias* for `SIMD[DType.uint8, 1]`, which is the same as `SIMD[ui8, 1]`. This means a single number is also a SIMD type, as shown in the following aliases: 
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

Let's now show some concrete examples of using SIMD.

Here is some code using SIMD:
See `simd.mojo`:
```py
import math

fn main():
    var a = SIMD[DType.uint8, 4](1, 2, 3, 4)  # 1
    print(a)  # => [1, 2, 3, 4]
    print(a.element_type) # => uint8
    print(len(a)) # => 4

    a *= 10                                   # 2
    print(a)  # => [10, 20, 30, 40]

    var zeros = SIMD[DType.uint8, 4]()        # 3A
    print(zeros)  # => [0, 0, 0, 0]
    var ones = SIMD[DType.uint8, 4](1)        # 3B
    print(ones)  # => [1, 1, 1, 1]

    var vec1 = SIMD[DType.int8, 4](2, 3, 5, 7)
    var vec2 = SIMD[DType.int8, 4](1, 2, 3, 4)
    var product = vec1 * vec2                 # 3C
    print(product) # => [2, 6, 15, 28]

    var numbers = SIMD[DType.uint8, 8]()
    print(numbers) # => [0, 0, 0, 0, 0, 0, 0, 0]
 
    # fill them with numbers from 0 to 7
    numbers = math.iota[DType.uint8, 8](0)    # 4
    print(numbers) # => [0, 1, 2, 3, 4, 5, 6, 7]
    numbers *= numbers   # 5     
    print(numbers) # => [0, 1, 4, 9, 16, 25, 36, 49]
```

SIMD is a core type, which is parametric on width and type.

SIMD is a parametric (generic) type, indicated with the [ ] braces. We need to indicate the item type and the number of items, as is done in line 1 when declaring the SIMD-vector a.  
DType.uint8 and 4 are called *parameters*. They must be known at compile-time.  
(1, 2, 3, 4) are the *arguments*, which can be compile-time or runtime known.
a is now a vector of 8 bit numbers that are packed into 32 bits. We can perform a *single instruction across all of its items*, instead of 4 separate instructions as when we would have used a for loop, like *= shown in line 2.  

Line 3A-B initialize a SIMD vector respectively with zeros and ones as values.  
If all items have the same value, use the shorthand notation as in line 3B for value 1.  

math.iota (line 4) fills an array with numbers incremented by 1.
Line 5 also performs a SIMD instruction: x*x for each number simultaneously.

On SIMD vectors of the same size and type you can apply all operators like *, /, %, **. We see examples in line 3C and 5. Math operations on SIMD values are applied *elementwise*, on each individual element in the vector. You can cast them to Bool type with cast[DType.bool]() and then apply &, |, ^ and so on.


### 4.4.2 SIMD system properties
We can interrogate our machine as to what its SIMD capabilities are. See `simd_system.mojo`
```py
from sys.info import simdbitwidth, simdbytewidth, simdwidthof
import math


fn main():
    print(simdbitwidth())  # 1 => 256
    print(simdbytewidth())  # 2 => 32
    print(simdwidthof[DType.uint64]())  # 3 => 4
    print(simdwidthof[DType.float32]())  # 4 => 8

    var a = SIMD[DType.float32](42)  # 5
    print(len(a))  # 6 => 8
```

To show the SIMD register size on the current machine, use the function `simdbitwidth` from module `sys.info` as in line 1. It gives you the total amount of bits that can be processed at the same time on the host systems SIMD register.
The result `256` in line 1 means that we can pack 32 x 8 (= 256) bits or 32 1-byte numbers or 8 4-byte numbers together and perform a calculation on all of these with a single instruction.
The function `simdbytewidth` is the total amount of bytes that can be processed at the same time on the host systems SIMD register, on our machine this is 32.  

Lastly the function `simdwidthof` is used to show how many of values of a certain type can fit into the target's SIMD register, e.g. to see how many uint64's can be processed with a single instruction. For our system, the SIMD register can process 4 UInt64 values at once (see line 3). 
So if you have some values of a certain type (e.g. float32) to process with SIMD, you can use the following expression:  
`SIMD[DType.float32, simdwidthof[DType.float32]()]`  
to process the maximum amount of values simultaneously.
(the SIMD type defaults to the architectural SIMD width of the type, so the above is equivalent to just `SIMD[DType.float32]`)
Line 4 tells us that this amount is 8.

### 4.4.3 Using element type and group size as compile-time constants
Using the alias keyword, we can define the SIMD element type and group size as compile-time constants, as in the code below:

See `simd_compile-time.mojo`:
```py
from sys.info import simdwidthof
import math

alias element_type = DType.int32                    # 1
alias group_size = simdwidthof[element_type]()


fn main():
    var numbers: SIMD[element_type, group_size]
    # initialize numbers:
    numbers = math.iota[element_type, group_size](0)
    print(numbers)  # => [0, 1, 2, 3, 4, 5, 6, 7]
```

This can make the code more readable (we define these values only once), and possibly give some performance benefits. It's a good practice to write code like that. 
`numbers` is a static vector, with items of type element_type, and a size which is exactly the number of elements of that type fitting into your SIMD registers.

For another example, see § 15.1.2 - parallelize with SIMD.

**Questions**
Is this a correct declaration of a SIMD type? Test it.
`var n = SIMD[DType.int32, 7](1, 2, 3, 4)`

**Exercises**
1- Initialize two single floats with 64 bits of data and the value 2.0, using the full SIMD version, and the shortened alias version, then multiply them together and print the result.
(see `exerc4.1.🔥`)
2- Create a loop using SIMD that prints four rows of data that look like this:
    [1,0,0,0]
    [0,1,0,0]
    [0,0,1,0]
    [0,0,0,1]

Hint: Use a loop: for i in range(4):
                        pass
(see `exerc4.2.🔥`)


### 4.4.4  Splat, join and cast
!! Splat doesn't exist anymore (since 24.5), rsqrt now in max library
The `splat` method sets all elements of the SIMD vector to the given value (it 'broadcasts' the value), like in the following example in line 1:

See `simd_methods.mojo`:
```py
from math import rsqrt
alias dtype = DType.float32


fn main():
    var a = SIMD[dtype].splat(0.5)  # 1
    print("SIMD a:", a)  # => SIMD a: [0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5]

    var big_vec = SIMD[DType.float16, 32].splat(1.0)  # 2
    var bigger_vec = (big_vec + big_vec).cast[DType.float32]()  # 3
    print(bigger_vec)
    # [2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0]

    var b = SIMD[dtype].splat(2.5)
    print("SIMD a.join(b):", a.join(b))   # 4
    # => SIMD a.join(b): 
    # [0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5]

    print(rsqrt[DType.float16, 4](42))    # 5
    # => [0.154296875, 0.154296875, 0.154296875, 0.154296875]

    var d = SIMD[DType.int8, 4](42, 108, 7, 13)
    print(d.shuffle[1, 3, 2, 0]())  # 6  => [108, 13, 7, 42]
```

We don't indicate the size of the SIMD vector, so it is the default size 8 for float32. 
>Note: splat makes it explicit, but as we saw in § 4.4.1, you can leave it out.

In line 2, we make a vector of type Float16 and size 32. In line 3, we add all the elements to themselves in one SIMD operation, and cast them to float32.  
Line 4 shows how to `join` (concatenate) 2 vectors of the same size.
Line 5 shows how the math function rsqrt is called upon a SIMD vector of size 4 and elements 42.

In line 6 the `shuffle` method is used, which takes a mask of permutation indices and permutes the vector accordingly.
The `interleave` method in line 7 combines two SIMD vectors into one by taking one element from the first and another from the second, weaving the vectors together.

*Exercise*
The `join` function already exists. But say you had to reinvent it and write a concat function with the following header that does the same thing:  
`fn concat[ty: DType, len1: Int, len2: Int](lhs: SIMD[ty, len1], rhs: SIMD[ty, len2]) -> SIMD[ty, len1+len2]:`

For a SIMD vector `a = SIMD[DType.float32, 2](1, 2)` and another vector with elements 3 and 4, write the code for the function concat.
(solution: see simd_concat.mojo)

(See also Vectorization: § 20.5.6)

See also:  joy of mojo:     conditional_simd_operations.mojo

## 4.4B Complex numbers
The built-in defined module complex defines a type `ComplexSIMD` and methods to work with complex numbers.
It has fields re and im and aliases:
* ComplexFloat32 = ComplexSIMD[float32, 1]
* ​ComplexFloat64 = ComplexSIMD[float64, 1]
!! example

## 4.5 The String types
Mojo has no equivalent of a char type for individual characters.

### 4.5.1 The StringLiteral type
The `StringLiteral` type is built-in. In `strings.mojo` a value of the type `StringLiteral` is made in line 1. (Guess the error when you try to give it the value 20 and test it out.)
The value can be delimited by "" or ''. 

String literals are all null-terminated for compatibility with C APIs (but this is subject to change). String literals store their length as an integer, and this does not include the null terminator.

To define a *multi-line string*, enclose the literal in three single or double quotes (like docstrings, see § 3.2.2):
```py
var s = """
Multi-line string literals let you 
enter long blocks of text, including 
newlines."""
```

They can be converted to a Bool value (see lines 1B-C): an empty StringLiteral is False, a non-empty is True. (Bool() doesn't work here).


See `strings.mojo`:
```py
fn main() raises:
    var lit = "This is my StringLiteral"       # 1
    print(lit)  # => This is my StringLiteral
    var lit2 = 'This is also a StringLiteral'  # 1A

    # lit = 20  # => error: Expression [9]:26:11: cannot implicitly convert 'Int' value to 'StringLiteral' in assignment

    # Conversion to Bool:
    var x = ""
    print(x.__bool__())  # 1B => False
    var y = "a"
    print(y.__bool__())  # 1C => True

    x = "abc"
    y = "abc"
    var z = "ab"
    print(x == y)  # 1D => True # equivalent to x.__eq__(y)
    print(x == z)  # => False

    z = "ab"
    print(x != y)  # => False
    print(x != z)  # => True

    var x1 = "hello "
    var y1 = "world"
    var d = x1 + y1  # equivalent to x1.__add__(y1)
    print(d)         # => hello world
   
    x = "string"
    print(len(x))  # => 6   # equivalent to x.__len__()  

    var y2 = x.data()
    x = "alo"
    print(y2)  # 2 => 0x7f72bc000170
    print(x)   # => alo

    print(int("19"))    # 2 => 19
    print(int("Mojo"))  # => Unhandled exception caught during execution: String is not convertible to integer.

    # print(("hello world")[0]) # => Error: `StringLiteral` is not subscriptable
    # var s2 = "hello world" # s2 is a `StringLiteral`
    # print(s2[:5]) # ERROR: `StringLiteral` is not subscriptable
```

Equality is tested with the == operator (or the method __eq__, see lines 1D-E). Not equality with != (or  __ne__).
You can join or concatenate two StringLiterals the + operator or __add__.
The length of a string is given by the len() function or __len__ method.

`data` gets the raw pointer to the underlying data, see line 2.
This could be useful if you need to pass the string data to a function that requires a pointer, or if you want to perform low-level operations on the string data.

>Note: this method has as return type DTypePointer[si8, 0]. This means that the method returns a pointer to the underlying data of the string literal. The `si8` indicates that the data is a sequence of 8-bit signed integers, which is a common way to represent characters in a string (signed !!).

#### 4.5.1.1   Converting a StringLiteral to an integer
Use the `int()` method, see line 2.

### 4.5.2 The String type
The `String` type represents a *mutable* string. The `string` module contains basic methods for working with strings. UTF-8 encoding is used to store strings. The length len corresponds to the number of bytes, not number of characters.
The string value is heap-allocated, but the String contains a List field, which is actually a pointer to the heap allocated data. This means we can load a huge amount of data into it, and change the size of the data dynamically during runtime. (Picture !!)

```py
    # String:
    var s9: String = "Mojo🔥" # normal type annotation
    var s = String("Mojo🔥")  # 3 - is conversion(casting)
    print(s)  # => Mojo🔥
    print(s[0])  # 4 => M
    print(ord(s[0]))  # => 77
    print(String("hello world")[0])  # => h
    var s8 : String = 1 # 5 - implicit type conversion
```

One way to make a String is to convert a StringLiteral value with `String(value)`, as in line 3. This works exactly the same as the `var s9: String = "Mojo🔥"` in the previous line. Both work because String has a constructor __init__(inout self, strlit: StringLiteral).

Implicit conversion of an integer to a string works in Mojo (see line 5), because String has a constructor __init__(inout self, num: Int). In any other cases, use the str() method to explicitly convert to a String.

Strings are 0-index based, and the i-th ASCII character can be read with `s[i]` (see line 4). The `ord` function gives the corresponding ASCII value of the character. You can work with Unicode characters by working with slices (see line 11).

This works because a String is backed by a data structure known as `List[SIMD[si8, 1]]` or `List[Int8]`. This is similar to a Python list, here it's storing multiple int8's that represent the characters.  

You can build a string starting from a List (see line 5 in the code below), and add some ASCII characters to it. In line 6, we convert the List to a String.



```py
    # building a string with a List:
    var buf = List[Int8](2)  # 5
    buf.append(65)
    buf.append(79)
    buf[0] = 78
    buf.append(0)
    var str = String(buf)  # 6
    print(str)  # => NA0
```

### 4.5.3 The StringRef type
(defined in the utils module)
A value of type `StringRef` represents a constant reference to a string, namely: a sequence of characters and a length, which need not be null terminated.

See the code examples for how this can be used, directly or by using the pointer .data(), optionally with the length:  
* data: A pointer to the beginning of the string data being referenced
* length: The length of the string being referenced.

It has the methods `getitem`, equal, not equal and length:  
* `getitem`: gets the string value at the specified position. It receives the index of the character to get, using the brackets notation.  
* equal: compares two strings for equality

```py
    # StringRef:
    var isref = StringRef("i")
    print(isref.data)  # => i
    print(isref.length)  # => 1
    print(isref)  # => i

    ## by using the pointer:
    var x3 = "Mojo"
    var ptr = x3.data()
    var str_ref = StringRef(ptr)
    print(str_ref)  # => Mojo

    var x2 = StringRef("hello")
    print(x2.__getitem__(0))  # => h
    print(x2[0])  # => h

    var s1 = StringRef("Mojo")
    var s2 = StringRef("Mojo")
    print(s1 == s2)  # => True
    print(s1 != s2)  # => False
    print(len(s1))  # => 4
```

Summary:
* StringLiteral is compile time known, static lifetime. 
* String owns the underlying buffer, backed by List, hence it is mutable, 0-terminated.  
* StringRef does not own underlying buffer, is immutable(!!), not 0-terminated. 


### 4.5.4 Some String methods
See `string_methods.mojo`:
```py
fn main() raises:    # raised needed because of atoi
    var s = String("abcde")
    print(s) # => abcde

    print(s[0]) # => a
    for i in range(len(s)):     # 1
        print(s[i], end=" ")    # => a b c d e
    # Slicing:
    print(s[2:4]) # => cd       # 2
    print(s[1:])  # => bcde     # 3
    print(s[:5])  # => abcde
    print(s[:-1]) # => abcd     # 4
    print(s[::2]) # => ace      # 5
    
    var emoji = String("🔥😀")
    print("fire:", emoji[0:4])    # 11 => fire: 🔥
    print("smiley:", emoji[4:8])  # => smiley: 😀

    # Appending:
    var x = String("Left")
    var y = String("Right")
    var c = x + y
    c += "🔥"
    print(c) # => LeftRight🔥   # 6

    # Join:
    var j = String("🔥")
    print(j.join('a', 'b')) # => a🔥b     # 7
    print(j.join(40, 2))    # => 40🔥2 

    var sit = StaticIntTuple[3](1,2,3)
    print(j.join(sit)) # => 1🔥2🔥3       # 8

    # Conversion from String to integer: atol
    var n = atol("19")
    print(n)                               # 9 =>
    # var e = atol("hi") # => Unhandled exception caught during execution: 
    # String is not convertible to integer.
    # print(e) 

    print(chr(97))  # => a
    print(ord('a')) # => 97
    print(ord('🔥')) # 9 => -16
    print(isdigit(ord('8'))) # => True
    print(isdigit(ord('a'))) # => False

    var s2 = String(42)
    print(s2) # => 42
```

Looping over a string is shown in line 1.  
Using a slice to print part of the string (here: from 2 up to 4 non-inclusive) in line 2.
Slice all characters starting from 1 (line 3).
Slice all characters up to the second last (line 4).
Only get every second item after the start position (line 5).

Both slicing and indexing work with bytes, not characters, for example an emoji is 4 bytes so you need to use this slice of 4 bytes to print the character (see line 11):
```py
    var emoji = String("🔥😀")
    print("fire:", emoji[0:4])    # 11 => fire: 🔥
    print("smiley:", emoji[4:8])  # => smiley: 😀
```

Appending: Returns a new string by copying memory (see line 6).
The join function has a similar syntax to Python's join. You can join elements using the current string as a delimiter (see line 7).
You can also use it to join elements of a StaticIntTuple (line 8).

`atol`: The term comes from the C stdlib for ASCII to long-integer, it converts a String to an Int (currently just works with base-10 / decimal).

Use `chr` to convert an integer between 0 and 255 to a string containing the single character. ord stands for ordinal which means the position of the character in ASCII. Only 1 byte utf8 (ASCII) characters currently work, anything outside will currently wrap (see line 9).

Use String(integer) to convert an integer to a string.

The `isdigit` function checks if the character passed in is a valid decimal between 0 and 9, which in ASCII is 48 to 57.


**Other useful methods**
* strip : to remove whitespace
* count : counting the number of occurrences of a substring in a string
* find : finding the offset index of a substring in a string 
* replace : replace a substring with another string.
* split : split the string by a delimiter
* lower - upper
* startswith - endswith
* isdigit, isupper, islower, isspace


## 4.6 Defining types with alias
You can also define a synonym or shorthand for a type with alias, as in line 1 below.

### 4.6.1 Using alias for types
See `alias_types.mojo`:
```py
alias FType = Float32              # 1
alias MyInt = Int

fn add(a: MyInt, b: MyInt) -> MyInt:
    return a + b

fn main():
    alias MojoArr = DTypePointer[DType.float32] 
    var f1: FType = 3.1415
    var f2: MojoArr

    print(add(1, 2)) # => 3
```

This can come in handy when a big computation uses one particular type, but sometimes you want to be able to change that type to see for example the performance difference.

Types like Float16 (see § 4.4.1) are also defined with alias in the standard library:  
`alias Float16 = SIMD[DType.float16, 1]`


### 4.6.2 Defining an enum type using alias
(!! After ch 7 on structs)
You can create an enum-like structure using the alias declaration, which defines the enum values at compile-time.

See `enum_type.mojo`:
```py
struct EnumT:
    alias invalid = 0
    alias bool = 1
    alias int8 = 2
    alias uint8 = 3
    alias int16 = 4
    alias uint16 = 5
    alias float32 = 15

fn main():
    var en = EnumT.float32
    print(en)  # => 15
```

In this example, EnumT is a struct that implements a simple enum using aliases for the enum's values. Now we can use EnumT.float32 as a parameter expression, which also works as a runtime value.


## 4.7 The object type
You can use variables without type-annotation in def functions, just like in Python. In that case, you're already using the `object` type under the hood!

!! Give an example, and show the type is object

`object` is defined in module `object` in the `builtin` package, so it is not a Python object.  
It is used to represent *untyped values*. 
* This is the type of arguments in def functions that do not have a type annotation, such as the type of x in `def f(x): pass`. A value of any type can be passed in as the x argument in that case. 
* `object` is also the return type of any def without return type 

The object type allows for dynamic typing because it can actually represent any type in the Mojo standard library, and the actual type is inferred at runtime. This makes it compatible with Python.  However the lack of type enforcement can lead to *runtime errors* when a function receives or returns an unexpected type.

Suppose you want to start coding with fn functions (gaining some of their benefits), but you do not yet know or do not care about the types of variables. In that case, use the object type explicitly
Here is an example of creating and using objects:

See `object1.mojo`:
```py
fn print_object(o: object):
    print(o)

fn add(a: object, b: object) raises -> object:  # 1
        return a + b
    
fn main() raises:
    var obj = object("hello world")     # a string
    obj = object([])                    # change to a list
    obj.append(object(123))             # a list of objects
    obj.append(object("hello world"))
    print_object(obj)   # => [123, 'hello world']
    print(obj) # => [123, 'hello world']

    print(add(1, 2.5))  # 2 => 3.5
```

Mojo did not complain about the type incompatibility of arguments because the object type has initializers for many builtin data types. What happens is that Mojo calls the appropriate initializer in object corresponding to the type of the given value. In the above case, object has initializers for both Int and FloatLiteral. In line 2, an object with Int and another object with FloatLiteral are instantiated, so that the add function can work. But be careful: runtime-errors can occur here, because there are no compile-time checks!

> Try changing one of the number arguments to a string. Now change both arguments to strings. Can you explain the result?

An object acts like a Python reference:

See `object2.mojo`:
```py
def modify(a):
    # argument given by copy in Mojo `def` but one can modify the referenced list
    a[0] = 1

def main():
    a = object([0])
    b = a  # <- the reference is copied but not the pointed list

    print(a)  # prints [0]
    modify(a)
    print(a)  # prints [1]
    print(b)  # prints [1]
```

This is pure Mojo code that does not use the Python interpreter. 




`matmul1.mojo` in § 20. shows an example of the use of object.
The following function shows how an object can be initialized and its attributes defined:
```
fn matrix_init(rows: Int, cols: Int) raises -> object:
    varvalue = object([])
    return object(
        Attr("value", value), Attr("__getitem__", matrix_getitem), Attr("__setitem__", matrix_setitem), 
        Attr("rows", rows), Attr("cols", cols), Attr("append", matrix_append),
    )
```


Objects do have types and can be type-checked.

Usage: They fit into a tiny space (+- 38K), so could be used in WASM and microcontrollers.

## 4.8 Special types
### 4.8.1 Register-passable types
Types of this kind are composed exclusively of *fixed-size data types*, which can (theoretically) be stored in a machine register. They are always passed *by value*, meaning, the values are copied.
A register-passable type can include other types, as long as they are also register-passable.  
Int, Bool, and SIMD, for example, are all register-passable types.  
So a register-passable struct could include Int and Bool fields, but not a String field.  
Register-passable types are declared with the *@register_passable* decorator (see 11B 11.2).

Because they can easily be handled in machine registers, without needing extra indirections, so they hugely benefit performance.

### 4.8.2 Trivial types
These are types that don't require any custom logic in their lifecycle methods. 
It indicates that the type is register passable, so the value is passed in CPU registers instead of through normal memory. But it also says that the value is "trivially" copyable and movable: the machine knows how to handle them. you don't need to define __init__, __copyinit__, __moveinit__ and __del__, and you even can't! 

Trivial also means that these values are always passed by copy/value.
Examples of trivial types:
* Arithmetic types such as Int, Bool, Float64, SIMD etc.
* Pointers (the address value is trivial, not the data being pointed to)
* Arrays of other trivial types including SIMD
* Struct types decorated with @register_passable("trivial") may only contain other trivial types.

These are all also register-passable types, so we declare a trivial type with the *@register_passable(trivial)* decorator (see 11B 11.2).

>Note: Trivial types shouldn't be limited to only register-passable types, so in the future trivial types will be separated from the @register_passable decorator (!!).

### 4.8.3 Memory-only types
They are the opposite of the preceding register-passable type. These types usually use pointers or references to manage heap-allocated memory. String, List, and Dict are all examples of memory-only types.

### 4.8.4 AnyType and AnyRegType
These are in effect metatypes, that is, types of types.
* `AnyType`: This represents any Mojo data type. This is also a trait, see § 11.
* `AnyRegType`: a metatype representing any register-passable type.

### 4.8.5 NoneType
* `NoneType = None`: This represents the absence of a value. 
`NoneType` is a type with one instance, the `None` object, which is used to signal "no value."

Both None and AnyType are defined as *type aliases* (metatypes) in the builtin module `type_aliases`:

