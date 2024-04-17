# 4 Basic types
Mojo's basic types are defined as built-ins, defined in the package `builtin`. They are automatically imported in code. These include Bool, Int, FloatLiteral, StringLiteral, StringRef and String, which we'll discuss in this section. Underneath, they are all defined as a struct (see § ??).

These structs mostly contain so-called *dunder* (__methodname__) methods. 
(short for double underscore) `__add__` method. You can think of dunder methods as interface methods to change the runtime behaviour of types, e.g. by implementing `__add__`, we are telling the Mojo compiler, how to add two `U24`s.

Common examples are:
* the `__init__` method: this acts as a constructor, creating an instance of the struct.
* the `__del__` method: this acts as a destructor, releasing the occupied memory.
* the `__eq__` method: to test the equality of two values of the same type.  
Often an equivalent infix or prefix operator can act as 'syntax sugar' for calling such a method. For example: the `__eq__` is called with the operator `==`, so you can use the operator in code which is much more convenient.

A *scalar* just means a single value in Mojo. The scalar types include the Bool type (see § 4.1.2), as well as the numerical types, which are all based on SIMD (see § 7.9.3).

The `DType` (data type) class defined in module `dtype` is kind of an umbrella type for the bool and numeric types. It has the following aliases:  
* invalid = invalid: Represents an invalid or unknown data type.
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
* index = index: Represents an integral type whose bitwidth is the maximum integral value on the system.
* address = address: Represents a pointer type whose bitwidth is the same as the bitwidth of the hardware’s pointer type (32-bit on 32-bit machines and 64-bit on 64-bit machines).

## 4.1 The Bool type
Defined in the module `bool` as a struct, `Bool` has only 2 values: `True` and `False`. 
It is constructed from a i1 value (an __mlir_type.i1 value), which takes only one bit of memory.
Among its methods are bool, invert, eq, ne, and, or, xor, rand, ror, rxor. 

Here are some declarations:
See `bools.mojo`:
```mojo
fn main():
    var x : Bool = True
    print(x)    # => True

    x = False
    print(x)    # => False
    print(x.value)  # 1 => False

    # 2 - Invert:
    print(True.__invert__())  # => False
    print(~False)             # => True

    # 3 Eq and ne
    print(True.__eq__(True))  # => True
    print(True == False)      # => False

    print(True.__ne__(True))  # => False
    print(True != False)      # => True

    # 4 - and, or and xor
    print(True.__and__(True)) # => True
    print(True & False)       # => False
    print(True.__or__(False)) # => True
    print(False | False)      # => False
    print(True.__xor__(True)) # => False
    print(True ^ False)       # => True
    print(False ^ True)       # => True
    print(False ^ False)      # => False
```
The value method gives its underlying scalar value (see line 1).
Reversing the value is done with the `invert` method (see line 2).

Equality is tested with the `__eq__` method or the `==` operator.  
Non-equality is tested with the `__ne__` method or the `!=` operator.
The `__and__` method is True only if both values are True, its operator is `&`.
The `__or__` method is True only if one of both values are True, its operator is `|`.
The xor (Exclusive or), outputs True if exactly one of two inputs is True.
Its method is written as `__xor__` and its infix operator as `^` (ALT+^).

There are also rhs (right-hand-side) equivalents of __and__ and so on, like __rand__, __ror__, __rxor__. Here the bool value is automatically used as the rhs of the operator (see for example § 7.2).

## 4.1.1 Converting a Boolean to an int

See `convert_bool.mojo`:
```py
fn main():
    let b1: Bool = True
    let m = UInt8(b1)
    print(m)  # => 1
    let b2: Bool = False
    let n = UInt8(b2)
    print(n)  # => 0
```

## 4.2 The numerical types
These are the numerical types:

* Int  
* Int8, Int16, Int32, Int64
* UInt8, UInt16, UInt32, UInt64
* Float32
* Float64

The prefix U means the type is unsigned. The number at the end refers to the number of bits used for storage, so UInt32 is an unsigned 4 bytes integer number.

### 4.2.1 The Integer type
The integer types are defined in module `int`, while the floating point types live in module `float_literal`. Both are part of the `builtin` package.

Int is the same size as the architecture of the current computer, so on a 64 bit machine it's 64 bits wide. Internally it is defined as a struct.

>Note: this type is different from the Python int type (see: https://docs.modular.com/mojo/programming-manual.html#int-vs-int)

One disadvantage is that Mojo's Int type is fixed, it can't work with big numbers.
Here is a simple trick to work with Python int's, which can handle big integers, in a Mojo program.
See `intInt.mojo`:
```mojo
from python import PythonObject
alias int = PythonObject

fn main() raises:
    let x : int = 2
    # `int` does not overflow:
    print(x ** 100) # => 1267650600228229401496703205376
    # `Int` overflows:
    print(2 ** 100) # => 0
```

The type name can be used to convert a value to the type (if possible), for example: `UInt8(1)` makes sure the value 1 is stored as an unsigned 1 byte integer.

There is also a cast method to convert to another type (see line 1):
See `casting.mojo`:
```mojo
fn main():
    # Cast SIMD:
    let x : UInt8 = 42  # alias UInt8 = SIMD[DType.uint8, 1]
    print(x) # => 42
    let y : Int8 = x.cast[DType.int8]()   # 1
    print(y) # => 42
         
    # Cast SIMD to Int
    let w : Int = x.to_int() # `SIMD` to `Int`
    let z : UInt8 = w         # `Int` to `SIMD`
```

(see also: § 7 simd2.mojo).

A small handy detail about spelling: _ can separate thousands:  `10_000_000`

All numeric types are derived from a SIMD type for performance reasons (see § 7.9.3).

Integers can also be used as indexes, as shown in the following example. Here the parametrized type DynamicVector (from module collections.vector) takes Int as the parameter type of its elements:

See `integers.mojo`:
```mojo
fn main():
    let i: Int = 2 
    print(i)   # => 2

    # use as indexes:
    var vec = DynamicVector[Int]()
    vec.push_back(2)
    vec.push_back(4)
    vec.push_back(6)

    print(vec[i])  # => 6
```

### 4.2.2 The FloatLiteral type and conversions
A FloatLiteral also takes the machine word-size (for example 64 bit) as default type. 
Conversions in Mojo are performed by using the constructor as a conversion function as in: 
`Float32(value_to_convert)`. 
We see that a conversion from a 64 bit FloatLiteral to a Float32 works, but already looses some precision.
As shown above conversion from an Int to Float works. Conversion from FloatLiteral to an Int is done with: `FloatLiteral.to_int`.


!! warning: if statement with constant condition 'if True'
    if 1.0: !!
See `floats.mojo`:
```mojo
fn main():
    let i: Int = 2
    let x = 10.0
    print(x) # => 10.0
    let float: FloatLiteral = 3.3
    print(float)  # => 3.2999999999999998
    let f32 = Float32(float)  # 1
    print(f32) # => 3.2999999523162842
    let f2 = FloatLiteral(i)
    print(f2) # => 2.0
    let f3 = Float32(i)
    print(f3) # => 2.0

    # Conversions:
    # let j: Int = 3.14  # error: cannot implicitly convert 'FloatLiteral' value to 'Int'
    # let j = Int(3.14)  # error: cannot construct 'Int' from 'FloatLiteral' value in 'let' 
    # let i2 = Int(float) # convert error
    # let i2 = Int(f32) # convert error
    let j = FloatLiteral.to_int(3.14)
    print(j)  # => 3
```

Equality is checked with ==, the inverse is !=
The following normal operators exist: -, <, >, <=, >=, + (add), - (sub), *, / (returns a Float)
// (floordiv): Returns lhs divided by rhs rounded down to the next whole number - 5.0 // 2.0 => 2.0
% (mod): Returns the remainder of lhs divided by rhs - print(5.0 % 2.0) => 1.0
** (pow)

**The r operations**  
radd, rsub, rmul, rtruediv, rfloordiv, rmod, rpow:
These operations allow to define the base operations for types that by default don't work with them.
Think of the r as reversed, for example:
 in a + b, if a doesn't implement __add__, then b.__radd__(a) will run instead.

In the following example, we define _radd_ for the struct MyNumber, so that we can add its value to a FloatLiteral (note that the struct instance is the rhs in the expression `2.0 + num`):

Example: see `radd.mojo`:
```mojo
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
```

**The i in-place operations**  
iadd (with operator +=), isub, imul, itruediv, ifloordiv, imod, ipow
i stands for in-place, the lhs becomes the result of the operation and a new object is not created.

```mojo
var a = 40.0
a += 2.0 # this runs __iadd__
print(a)  # => 42.0
```

Same for: -=, *=, /=, %=, //=, **=

If an Int or a Float value does not equal 0 or 0.0, it returns True in an if statement:
```mojo
if 1.0:
    print("not 0.0")  # => not 0.0

if not 0.0:
    print("is 0.0")   # => is 0.0

if 0:       # or 0.0
    print("this does not print!")
```

## 4.2.3 Random numbers
This functionality is implemented in the `random` package.

See `random1.mojo`:
```mojo
from random import seed, rand, randint, random_float64, 
    random_si64, random_ui64
from memory import memset_zero

fn main():
    print(random_float64(0.0, 1.0)) # 4 => 0.047464513386311948
    print(random_si64(-10, 10)) # 5 => 5
    print(random_ui64(0, 10)) # 6 => 3

    let p1 = DTypePointer[DType.uint8].alloc(8)    # 1
    let p2 = DTypePointer[DType.float32].alloc(8)
    memset_zero(p1, 8)
    memset_zero(p2, 8)
    print('values at p1:', p1.simd_load[8](0))
    # => values at p1: [0, 0, 0, 0, 0, 0, 0, 0]
    print('values at p2:', p2.simd_load[8](0))
    # => values at p2: [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]

    rand[DType.uint8](p1, 8)        # 2A
    rand[DType.float32](p2, 8)      # 2B
    print('values at p1:', p1.simd_load[8](0))
    # => values at p1: [0, 33, 193, 117, 136, 56, 12, 173]
    print('values at p2:', p2.simd_load[8](0))
    # => values at p2: [0.93469291925430298, 0.51941639184951782, 0.034572109580039978, 0.52970021963119507, 0.007698186207562685, 0.066842235624790192, 0.68677270412445068, 0.93043649196624756]

    randint[DType.uint8](p1, 8, 0, 10)  # 3
    print(p1.simd_load[8](0))
    # => [9, 5, 1, 7, 4, 7, 10, 8]
```

In lines 1 and following we create two variables to store new addresses on the heap and allocate space for 8 values, note the different DType, uint8 and float32 respectively. Zero out the memory to ensure we don't read garbage memory.
Now in lines 2A-B, we fill them both with 8 random numbers.
To generate random integers in a range, for example 1 - 10, use the function randint (see line 3).  
The function random_float64 returns a single random Float64 value within a specified range e.g 0.0 to 1.0 (see line 4).
The function random_si64 returns a single random Int64 value within a specified range e.g -10 to +10 (see line 5).
The function random_ui64 returns a single random UInt64 value within a specified range e.g 0 to +10 (see line 6).

The rand function allows for creating a Tensor with random values, see `random2.mojo`:
```mojo
from random import rand


fn main() raises:
    let tx = rand[DType.int8](3, 5)
    print(tx)


# =>
# Tensor([[-128, -95, 65, -11, 8],
# [-72, -116, 45, 45, 111],
# [-30, 4, 84, -120, -115]], dtype=int8, shape=3x5)
```

## 4.3 The String types
Mojo has no equivalent of a char type.

In short:
* StringLiteral compile time known, static lifetime, immutable. 
* String owns the underlying buffer, backed by DynamicVector hence mutable, 0 terminated.  
* StringRef does not own underlying buffer, is immutable, not 0 terminated. 

### 4.3.1 The StringLiteral type
It has a `StringLiteral` type, which is built-in. In `strings.mojo` a value of that type is made in line 1. (Guess the error when you try to give it the value 20 and test it out.)  
It is written directly into the data segment of the binary. When the program starts, it's loaded into read-only memory, which means it's constant and lives for the duration of the program.
String literals are all null-terminated for compatibility with C APIs (but this is subject to change). String literals store their length as an integer, and this does not include the null terminator.

They can be converted to a Bool value (see lines 1B-C): an empty string is False, an non-empty is True. (Bool() doesn't work here).
?? also examples with ''

See `strings.mojo`:
```mojo
fn main():
    # StringLiteral:
    let lit = "This is my StringLiteral"   # 1
    print(lit)  # => This is my StringLiteral

    # lit = 20  # => error: Expression [9]:26:11: cannot implicitly convert 'Int' value to 'StringLiteral' in assignment

    # Conversion to Bool:
    var x = ""
    print(x.__bool__())  # 1B => False
    var y = "a"
    print(y.__bool__())  # 1C => True

    x = "abc"
    y = "abc"
    var z = "ab"
    print(x.__eq__(y))  # 1D => True  
    print(x.__eq__(z))  # => False
    print(x == y)       # 1E => True

    z = "ab"
    print(x.__ne__(y))  # => False
    print(x.__ne__(z))  # => True
    print(x != y)       # => False

    let x1 = "hello "
    let y1   = "world"
    let c = x.__add__(y)
    let d = x1 + y1
    print(c)  # => hello world
    print(d)  # => hello world

    x = "string"
    print(x.__len__())  # => 6
    print(len(x))       # => 6

    x = "string"
    let y2 = x.data()
    x = "alo"
    print(y2)  # => string
    print(x)  # => alo
```

Equality is tested with the method __eq__ or the == operator. (1D-E). Not equality with __ne__ or != .
You can join or concatenate two StringLiterals with __add__ or the + operator.
The length of a string is given by the __len__ method or len() function.

`data` gets the raw pointer to the underlying data; pointer<scalar<si8>> is the return type of the method. This means that the method returns a pointer to the underlying data of the string literal. The `si8` indicates that the data is a sequence of 8-bit signed integers, which is a common way to represent characters in a string (signed ??).

So, if you have a StringLiteral object, you can call data() on it to get a pointer to its underlying data. This could be useful if you need to pass the string data to a function that requires a pointer, or if you want to perform low-level operations on the string data.

### 4.3.2 The String type
The `String` type represents an immutable string. Declare an immutable string with let. The `string` module contains basic methods for working with strings. Mojo uses UTF-8 encoding to store strings. The length len corresponds to the number of bytes, not number of characters.
The string value is heap-allocated, but the String itself is actually a pointer to the heap allocated data. This means we can load a huge amount of data into it, and change the size of the data dynamically during runtime. (Picture ??)

```mojo
   # String:
    let s = String("Mojo🔥")       # 3
    # alternative:
    let s9 : String = "Mojo🔥"
    print(s)            # => Mojo🔥
    print(s[0])         # 4 => M
    print(ord(s[0]))    # => 77
    print(String("hello world")[0]) # => h
    # s[0] = "a" # error: expression must be mutable in assignment
```

One way to make a String is to convert a StringLiteral value with `String(value)`, as in line 3.  
Strings are 0-index based, and the i-th ASCII character can be read with `s[i]` (see line 4). The `ord` function gives the corresponding ASCII value of the character. You can work with Unicode characters by working with slices (see line 11).

This works because a String is backed by a data structure known as `DynamicVector[SIMD[si8, 1]]` or `DynamicVector[Int8]`. This is similar to a Python list, here it's storing multiple int8's that represent the characters.  
You can build a string starting from a DynamicVector (see line 5), and add two ASCII characters to it. 

To display it, print(vec) doesn't work. To do that, we can use a `StringRef` to get a pointer to the same location in memory, but with the methods required to output the numbers as text, see lines 6-7.

```mojo
    # building a string with a DynamicVector:
    from collections.vector import DynamicVector
    var vec = DynamicVector[Int8](2)    # 5
    vec.push_back(78)
    vec.push_back(79)

#     from memory.unsafe import DTypePointer
#     # 6:
#     let vec_str_ref = StringRef(DTypePointer[DType.int8](vec.data).address, vec.size)
#     print(vec_str_ref) # 7 => NO
# ```

Because it points to the same location in heap memory, changing the original vector will also change the value retrieved by the reference:

```mojo
    # vec[1] = 78
    # print(vec_str_ref)  # 8 => NN
```

In line (9) we make a deep copy `vec_str` of the string. Having made a copy of the data to a new location in heap memory, we can now modify the original and it won't effect our copy (see line 10):

```mojo
    # let vec_str = String(vec_str_ref)  # 9
    # print(vec_str)      # => NN

    # vec[0] = 65
    # vec[1] = 65
    # print(vec_str_ref)  # => AA
    # print(vec_str)      # 10 => NN
```

### 4.3.3 The StringRef type
A value of type `StringRef` represents a constant reference to a string, namely: a sequence of characters and a length, which need not be null terminated.
See the code examples for how this can be used, directly or by using the pointer .data(), optionally with the length:  
* data: A pointer to the beginning of the string data being referenced
* length: The length of the string being referenced.

It has the methods `getitem`, equal, not equal and length:  
* `getitem`: gets the string value at the specified position. It receives the index of the character to get, using the brackets notation.  
* equal: compares two strings for equality

```mojo
    # StringRef:
    let isref = StringRef("i")
    # var isref : StringRef = StringRef("a")
    print(isref.data)      # => i
    print(isref.length)    # => 1
    print(isref)           # => i

    ## by using the pointer:
    let x3 = "Mojo"
    let ptr = x3.data()
    let str_ref = StringRef(ptr)
    print(str_ref) # => Mojo

    let y3 = "string_2"
    let ptry = y3.data()
    let length = len(y)
    let str_ref2 = StringRef(ptry, length)
    print(str_ref2.length) # => 8
    print(str_ref2)        # => string_2

    let x2 = StringRef("hello")
    print(x2.__getitem__(0)) # => h
    print(x2[0])             # => h

    let s1 = StringRef("Mojo")
    let s2 = StringRef("Mojo")
    print(s1.__eq__(s2))  # => True
    print(s1 == s2)       # => True
    print(s1.__ne__(s2))  # => False
    print(s1 != s2)       # => False
    print(s1.__len__())   # => 4
    print(len(s1))        # => 4
```

### 4.3.4 Some String methods
See `string_methods.mojo`:
```mojo
fn main() raises:    # raises needed because of atoi
    let s = String("abcde")
    print(s) # => abcde

    for i in range(len(s)):     # 1
        print(s[i])
    # a
    # b
    # c
    # d
    # e
    # Slicing:
    print(s[2:4]) # => cd       # 2
    print(s[1:])  # => bcde     # 3
    print(s[:-1]) # => abcd     # 4
    print(s[::2]) # => ace      # 5
    
    let emoji = String("🔥😀")
    print("fire:", emoji[0:4])    # 11 => fire: 🔥
    print("smiley:", emoji[4:8])  # => smiley: 😀

    # Appending:
    let x = String("Left")
    let y = String("Right")
    var c = x + y
    c += "🔥"
    print(c) # => LeftRight🔥   # 6

    # Join:
    let j = String("🔥")
    print(j.join('a', 'b')) # => a🔥b     # 7
    print(j.join(40, 2))    # => 40🔥2 

    let sit = StaticIntTuple[3](1,2,3)
    print(j.join(sit)) # => 1🔥2🔥3       # 8

    let n = atol("19")
    print(n)                               # 9
    # let e = atol("hi") # => Unhandled exception caught during execution: 
    # String is not convertible to integer.
    # print(e) 

    print(chr(97))  # => a
    print(ord('a')) # => 97
    print(ord('🔥')) # 9 => -16
    print(isdigit(ord('8'))) # => True
    print(isdigit(ord('a'))) # => False

    let s = String(42)
    print(s) # => 42
```

Looping over a string is shown in line 1.  
Using a slice to print part of the string (here: from 2 up to 4 non-inclusive) in line 2.
Slice all characters starting from 1 (line 3).
Slice all characters up to the second last (line 4).
Only get every second item after the start position (line 5).

Both slicing and indexing work with bytes, not characters, for example an emoji is 4 bytes so you need to use this slice of 4 bytes to print the character (see line 11):
```mojo
    let emoji = String("🔥😀")
    print("fire:", emoji[0:4])    # 11 => fire: 🔥
    print("smiley:", emoji[4:8])  # => smiley: 😀
```

Appending: Returns a new string by copying memory (see line 6).
The join function has a similar syntax to Python's join. You can join elements using the current string as a delimiter (see line 7).
You can also use it to join elements of a StaticIntTuple (line 8).

`atol`: The term comes from the C stdlib for ASCII to long-integer, it converts a string to an Int (currently just works with base-10 / decimal).

Use `chr` to convert an integer between 0 and 255 to a string containing the single character. ord stands for ordinal which means the position of the character in ASCII. Only 1 byte utf8 (ASCII) characters currently work, anything outside will currently wrap (see line 9).

Use String(integer) to convert an integer to a string.

The `isdigit` function checks if the character passed in is a valid decimal between 0 and 9, which in ASCII is 48 to 57.

See also `string_counting_bytes_and_characters.mojo`

- v 0.5.0: The String type has the count() and find() methods to enable counting the number of occurrences or finding the offset index of a substring in a string. It also has a replace() method which allows you to replace a substring with another string.


## 4.4 Defining alias types
We know that it is best practice to give constant values that are repeatedly used in our program a name, like ACONSTANT. So when its value changes, we only have to do it in one place. In Mojo, such constants are defined with the alias keyword.  This is a compile-time constant: all instances of the alias are replaced by its value at compile-time.

You can easily define a synonym or shorthand for a type with alias:

### 4.4.1 Usage of alias
See `alias1.mojo`:
```mojo
alias fl = Float32   # 1
alias Float16 = SIMD[DType.float16, 1]

alias MAX_ITERS = 200
alias DAYS_PER_YEAR = 365.24
alias PI = 3.141592653589793    # 1B
alias TAU = 2 * PI
    
fn main():
    alias MojoArr2 = DTypePointer[DType.float32] 

    alias debug_mode = True  # 2
    alias width = 960
    alias height = 960
    for i in range(MAX_ITERS):  # 3
        print_no_newline(i, " ") # => 0  1  2  3  4  5  6  ... 198 199
```

Line 1B shows that an alias constant is often capitalized.
Line 2 and following work, because alias is also a way to define a compile-time temporary value,  just like var and let define resp. a runtime variable and constant. alias is kind of a let at comptime. You can also make a user-defined type with it (see § 1B). All occurences of the alias name get substituted with the value at comptime, so it has a bit of a performance benifit. This is ideal to set parameter values of the problem at hand.
So line 3 is changed at compile time to `for i in range(MAX_ITERS):`.

Both None and AnyType are defined as type aliases in the builtin module `type_aliases` as metatypes:
* AnyType: Represents any Mojo data type, includes all Mojo types.
* AnyRegType: a metatype representing any register-passable type.
* NoneType = None: Represents the absence of a value.
(See also § 11.3 @parameter)

A struct field can also be an alias.

>Note: use alias in order to use the ord function efficently, example:  
`alias QUOTE = ord('"')`

### 4.4.2 Defining an enum type using alias
(?? After ch 7 on structs)
You can create an enum-like structure using the alias declaration, which defines the enum values at compile-time.

See `enum_type.mojo`:
```mojo
struct enum_type:
    alias invalid = 0
    alias bool = 1
    alias int8 = 2
    alias uint8 = 3
    alias int16 = 4
    alias uint16 = 5
    alias float32 = 15

fn main():
    let en = enum_type.bool
    print(en)  # => 1
```

In this example, enum_type is a struct that implements a simple enum using aliases for the enumerators. This allows clients to use enum_type.float32 as a parameter expression, which also works as a runtime value.

See also § 6.8


## 4.5 The object type
`object` is defined in module `object` in the `builtin` package, so it is not a Python object.  
It is used to represent untyped values. This is the type of arguments in def functions that do not have a type annotation, such as the type of x in `def f(x): pass`. A value of any type can be passed in as the x argument in that case.

Here is an example of creating an object:

See `object1.mojo`:
```mojo
fn print_object(o: object):
    print(o)

fn main() raises:
    var obj = object("hello world")     # a string
    obj = object([])                    # change to a list
    obj.append(object(123))             # a list of objects
    obj.append(object("hello world"))
    print_object(obj)   # => [123, 'hello world']
```

An object acts like a Python reference.

See `object2.mojo`:
```mojo
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

`matmul1.mojo` in § 20. shows an example of its use.
The following function shows how an object can be initialized and its attributes defined:
```
fn matrix_init(rows: Int, cols: Int) raises -> object:
    let value = object([])
    return object(
        Attr("value", value), Attr("__getitem__", matrix_getitem), Attr("__setitem__", matrix_setitem), 
        Attr("rows", rows), Attr("cols", cols), Attr("append", matrix_append),
    )
```


Objects do have types and can be type-checked.

Usage: They fit into a tiny space (+- 38K), so could be used in WASM and microcontrollers.

Mojo allows you to define custom bitwidth integers (see §  ## 14.6 Custom bitwidth integers )