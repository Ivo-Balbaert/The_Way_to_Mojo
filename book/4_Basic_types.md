# 4 Basic types
Mojo's basic types are defined as built-ins, which means they are automatically imported in code. These include Bool, Int, FloatLiteral, StringLiteral, StringRef and String, which we'll discuss in this section. Underneath, they are all defined as a struct (see § ??).

These structs mostly contain so-called *dunder* (__...__) methods. Common examples are:
* the `__init__` method: this acts as a constructor, creating an instance of the struct.
* the `__del__` method: this acts as a destructor, releasing the occupied memory.
* the `__eq__` method: to test the equality of two values of the same type.  
Often an equivalent infix or prefix operator can act as 'syntax sugar' for calling such a method. For example: the `__eq__` is called with the operator `==`.

A *scalar* just means a single value in Mojo. The scalar types include the Bool type (see § 4.1.2), as well as the numerical types, which are all based on SIMD (see § ??).

## 4.1 The Bool type
Defined in the module `bool` as a struct, `Bool` has only 2 values: `True` and `False`. Among its methods are bool, invert, eq, ne, and, or, xor, rand, ror, rxor. 

Here are some declarations:
See `bools.mojo`:
```py
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


### 4.2 The numerical types
These are the numerical types:

* Int  
* Int8, Int16, Int32, Int64
* UInt8, UInt16, UInt32, UInt64
* Float32
* Float64

The prefix U means the type is unsigned. The number at the end refers to the number of bits used for storage, so UInt32 is an unsigned 4 bytes integer number.

#### 4.2.1 The Integer type
The integer types are defined in module `int`, while the floating point types live in module `float_literal`. Both are part of the `builtin` package.

Int is the same size as your architecture, so on a 64 bit machine it's 64 bits wide. Internally it is defined as a struct.

>Note: this type is different from the Python int type (see: https://docs.modular.com/mojo/programming-manual.html#int-vs-int)

The type name can be used to convert a value to the type (if possible), for example: `UInt8(1)` makes sure the value 1 is stored as an unsigned 1 byte integer.

A small handy detail about spelling: _ can separate thousands:  `10_000_000`

All numeric types are derived from a SIMD type for performance reasons (see § 7.3).

Integers can also be used as indexes, as shown in the following example. Here the parametrized type DynamicVector (from module utils.vector) takes Int as the parameter type of its elements:

See `integers.mojo`:
```py
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

#### 4.2.2 The FloatLiteral type and conversions
A FloatLiteral also takes the machine word-size (for example 64 bit) as default type. 
Conversions in Mojo are performed by using the constructor as a conversion function as in: 
`Float32(value_to_convert)`. 
We see that a conversion from a 64 bit FloatLiteral to a Float32 works, but already looses some precision.
As shown above conversion from an Int to Float works. Conversion from FloatLiteral to an Int is done with: `FloatLiteral.to_int`.

See `floats.mojo`:
```py
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
```py
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

```py
var a = 40.0
a += 2.0
print(a)  # => 42.0
```

Same for: -=, *=, /=, %=, //=, **=

If an Int or a Float value does not equal 0 or 0.0, it returns True in an if statement:
```py
if 1.0:
    print("not 0.0")  # => not 0.0

if not 0.0:
    print("is 0.0")   # => is 0.0

if 0:       # or 0.0
    print("this does not print!")
```

XYZ

## 4.3 The String types
Mojo has no equivalent of a char type.

### 4.3.1 The StringLiteral type
It has a `StringLiteral` type, which is built-in. In `strings.mojo` a value of that type is made in line 1. (Guess the error when you try to give it the value 20 and test it out.)  
It is written directly into the data segment of the binary. When the program starts, it's loaded into read-only memory, which means it's constant and lives for the duration of the program.
String literals are all null-terminated for compatibility with C APIs (but this is subject to change). String literals store their length as an integer, and this does not include the null terminator.

They can be converted to a Bool value (see lines 1B-C): an empty string is False, an non-empty is True. (Bool() doesn't work here).

See `strings.mojo`:
```py
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

`data` gets the raw pointer to the underlying data; pointer<scalar<si8>> is the return type of the method. This means that the method returns a pointer to the underlying data of the string literal. The `si8` indicates that the data is a sequence of 8-bit signed integers, which is a common way to represent characters in a string.

So, if you have a StringLiteral object, you can call data() on it to get a pointer to its underlying data. This could be useful if you need to pass the string data to a function that requires a pointer, or if you want to perform low-level operations on the string data.

### 4.3.2 The String type
The `String` type represents a mutable string*. The `string` module contains basic methods for working with strings.
The string value is heap-allocated, but the String itself is actually a pointer to heap allocated data. This means we can load a huge amount of data into it, and change the size of the data dynamically during runtime. (Picture ??)

```py
   # String:
    let s = String("Mojo🔥")       # 3
    print(s)            # => Mojo🔥
    print(s[0])         # 4 => M
    print(ord(s[0]))    # => 77
```

One way to make a String is to convert a StringLiteral value with `String(value)`, as in line 3.  
Strings are 0-index based, and the i-th ASCII character can be read with `s[i]` (see line 4). The `ord` function gives the corresponding ASCII value of the character. You can work with Unicode characters by working with slices (see line 11).

This works because a String has an underlying data structure known as `DynamicVector[SIMD[si8, 1]]`. This is similar to a Python list, here it's storing multiple int8's that represent the characters.  
You can build a string starting from a DynamicVector (see line 5), and add two ASCII characters to it. 
To display it, print(vec) doesn't work. To do that, we can use a `StringRef` to get a pointer to the same location in memory, but with the methods required to output the numbers as text, see lines 6-7.

```py
    # building a string with a DynamicVector:
    from utils.vector import DynamicVector
    var vec = DynamicVector[Int8](2)    # 5
    vec.push_back(78)
    vec.push_back(79)

    from memory.unsafe import DTypePointer
    # 6:
    let vec_str_ref = StringRef(DTypePointer[DType.int8](vec.data).address, vec.size)
    print(vec_str_ref) # 7 => NO
```

Because it points to the same location in heap memory, changing the original vector will also change the value retrieved by the reference:

```py
    vec[1] = 78
    print(vec_str_ref)  # 8 => NN
```

In line (9) we make a deep copy `vec_str` of the string. Having made a copy of the data to a new location in heap memory, we can now modify the original and it won't effect our copy (see line 10):

```py
    let vec_str = String(vec_str_ref)  # 9
    print(vec_str)      # => NN

    vec[0] = 65
    vec[1] = 65
    print(vec_str_ref)  # => AA
    print(vec_str)      # 10 => NN
```

### 4.3.3 The StringRef type
A value of type `StringRef` represents a constant reference to a string, namely: a sequence of characters and a length, which need not be null terminated.
See the code examples for how this can be used, directly or by using the pointer .data(), optionally with the length:  
* data: A pointer to the beginning of the string data being referenced
* length: The length of the string being referenced.

It has the methods `getitem`, equal, not equal and length:  
* `getitem`: gets the string value at the specified position. It receives the index of the character to get, using the brackets notation.  
* equal: compares two strings for equality

```py
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

Emojis are actually four bytes, so we need a slice of 4 to have it print correctly (see line 11):

```py
    let emoji = String("🔥😀")
    print("fire:", emoji[0:4])    # 11 => fire: 🔥
    print("smiley:", emoji[4:8])  # => smiley: 😀
```