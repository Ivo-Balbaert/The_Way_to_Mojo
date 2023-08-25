# 3 Basic building blocks
We'll start by discussing the last code snippet of § 2.

For a list of keywords, see keywords.txt  
Keywords normally cannot be used as identifiers. If it really is necessary, you can enclose them in backticks `` to force the use of a keyword as an identifier (see error.mojo).

## 3.1 The main function, def and fn, variables and types
Mojo is a compiled language, and thus when code is stored in `.mojo` files, a `main()` function is required as the entry point to a program. 

See `first.mojo`:
```py
fn main():
    var n: Int = 1      # 1
    n += 1              # 2
    print(n)            # => 2
```

>Note: The main() function isn’t required in a REPL or notebook environment, where code is JIT-compiled. That's why in the notebook code, we had to call it explicitly.

Like in Python, `main()` has no parameters and no return value.

>Note: Why didn't we write the Python form `def main()`, instead of `fn main()`? It turns out that both forms of function can be used in Mojo, but they have different meaning. `def` functions are dynamic, flexible and types are optional, which makes it easier to port Python functions to Mojo. `fn` is meant for stricter code: it enforces strongly-typed and memory-safe behavior. Supporting both `def` and `fn` makes it easier to port Python functions to Mojo.

From line 1, we see that Mojo also uses indentation to define code blocks, instead of the { } found in C-type languages. Mojo also knows `print`, as well as control-flow syntax such as `if` conditions and `for` loops.

We also declare a variable `n` with the keyword `var`, which means it is a real mutable variable whose value can change. If you need to define an immutable variable (a constant), use `let` instead, benefiting type-safety and performance.

Why is this also useful? Because Python doesn't give you an error if you mistype a variable name in an assignment, while Mojo does when declared with var/let.

>Note: A def used in Mojo allows to declare untyped variables just by assigning them a value. But you can also use var and let inside defs!

>Note: Take care to only use var when really needed!

Another example:
see `let2.mojo`:
```py
def your_function(a, b):
    let c = a
    # Uncomment to see an error:
    # c = b  # error: c is immutable

    if c != b:
        let d = b
        print(d)  # => 3

your_function(2, 3)
```

let and var declarations support type specifiers as well as patterns, and late initialization as in lines 1-3::

see `let3.mojo`:
```py
def your_function():
    let x: Int = 42
    let y: Float64 = 17.0

    let z: Float32   # 1
    if x != 0:
        z = 1.0      # 2
    else:
        z = foo()    # 3
    print(z)      # => 1.0

def foo() -> Float32:
    return 3.14

your_function()
```

What happens when you change var to let? You get a compiler error:  
```
error: Expression [15]:7:5: expression must be mutable for in-place operator destination
    n += 1
    ^
```
Indeed in line 2, the value of n is incremented. The line is equivalent to: `n = n + 1`. `let` makes n immutable.

If var is omitted, you get another error:
```
??
```

Unlike in def functions, in fn functions you need to use either var or let when a local variable is declared.

Also in line 1, we see that the type of n is declared as `Int`, an integer. *Declaring the type is not required for local variables in fn*, but it can be useful and increases performance.
Mojo has so-called *progressive typing*: adding more types leads to better performance and error checking, the code becomes safer and more reliable.
If the type is omitted, it is inferred by the compiler, that is: derived from the type of value the variable is initialized with (here the integer 1).

Here is an example snippet which uses `let` for declarations (see `let.mojo`):
```py
fn main()
    do_math()

fn do_math():
    let x: Int = 1
    let y = 2        # 1
    print(x + y)     # => 3
```

In line 2, the type of variable `y` is also inferred to be Int.
(?? What happens when you leave out fn main())

What happens when?
?? Int is omitted

Finally, we see a convention here:  
* variable and function names start with a lowercase letter, and follow camelCase style (example: luckyNumber).
* types (like `Int`) start with an uppercase letter, and follow PascalCase style (example: IntPair).

>Note: When using Mojo in a REPL environment (such as a Jupyter notebook), top-level variables (variables that live outside a function or struct) are treated like variables in a def, so they allow implicit value type declarations (they do not require var or let declarations, nor type declarations). This matches the Python REPL behavior.

Mojo is also a *strongly-typed language", contrary to Python, which is *loosely typed* (see `change_type.mojo`):
```py
var x = UInt8(1)
x = "will cause an error" # error

# error: Expression [14]:20:9: cannot implicitly convert 'StringLiteral' value to 'SIMD[ui8, 1]' in assignment
#     x = "will cause an error"
#         ^~~~~~~~~~~~~~~~~~~~~
```
Trying to change a variable's type as in the code above leads to a compiler error.

## 3.2 Function arguments and return type
Functions declared as `fn` in Mojo must specify the types of their arguments. If a value is returned, its type must be specified after a `->` and before the body of the function.

This is illustrated in the `sum` function in the following example (see line 1):  
See `sum.mojo`:
```py
fn main():
    z = sum(1, 2)
    print(z)    # => 3

fn sum(x: Int, y: Int) -> Int:  # 1
    return x + y
```

By default, a function cannot modify its arguments values. They are immutable references and read-only. 

?? Try out: let sum change x

Arguments are only *borrowed* by convention. You can make this explicit by writing:  

```py
fn sum(borrowed x: Int, borrowed y: Int) -> Int:  
    return x + y
```

## 3.3 Can a function change its arguments?
## 3.3.1 inout 
For a function's the arguments to be mutable, you need to declare them as *inout*. This means that changes made to the arguments inside the function are visible outside the function.  
This is illustrated in the following example (see `inout.mojo`):  

```py
fn main():
    var a = 1
    var b = 2
    c = sum_inout(a, b)
    print(a)  # => 2
    print(b)  # => 3
    print(c)  # => 5  

fn sum_inout(inout x: Int, inout y: Int) -> Int:  # 1
    x += 1
    y += 1
    return x + y
```

This is a potential source of bugs, that's why Mojo forces you to be explicit about it with *inout*

## 3.3.2 owned
An even stronger option is to declared an argument as *owned*. Then the function gets full ownership of the value, so that it’s mutable and but also guaranteed unique. This means the function can modify the value and not worry about affecting variables outside the function.  
For example (see `owned.mojo`):  
```py
from String import String   # 1

fn main():
    mojo()

fn mojo():
    let a: String = "mojo"
    let b = set_fire(a)                      
    print(a)        # => "mojo"
    print(b)        # => "mojo🔥"

fn set_fire(owned text: String) -> String:   # 2
    text += "🔥"
    return text
```

Our variable to be owned is of type `String`. This type and its methods(??) are defined in module String, which is not built-in like `Int`. It has to be imported as in line 1.  
`set_fire` takes ownership of variable a in line 2 as parameter `text`, which it changes and returns.  
From the output, we see that the return value b has the changed value, while the original value of a still exists. Mojo made a copy of a to pass this as the text argument.

## 3.3.3 owned and transferred with ^
If however you want to give the function ownership of the value and do NOT want to make a copy (which can be an expensive operation for some types), then you can add the *transfer* operator `^` when you pass variable a to the function.  
The transfer operator effectively destroys the local variable name - any attempt to call it later causes a compiler error.  

If you change in the example above the call to set_fire() to look like this:

```py
let b = set_fire(a^)   # this doesn't make a copy
print(a)        # 3 => error:
```

we get the error: ??
because the transfer operator effectively destroys the variable a , so when the following print() function tries to use a, that variable isn’t initialized anymore.
If you delete or comment out print(a), then it works fine.

>Note: Currently (Aug 17 2023), Mojo always makes a copy when a function returns a value.

## 3.4 Structs
>Note: At this time (Aug 2023), Mojo doesn't have the concept of "class", equivalent to that in Python; but it is on the roadmap.

You can build high-level abstractions for types (or "objects") in a *struct*. A struct in Mojo is similar to a class in Python: they both support methods, fields, operator overloading, decorators for metaprogramming, and so on. 

>Note: Python classes are dynamic: they allow for dynamic dispatch, monkey-patching (or “swizzling”), and dynamically binding instance properties at runtime. However, Mojo structs are completely static - they are bound at compile-time and you cannot add methods at runtime, so they do not allow dynamic dispatch or any runtime changes to the structure. Structs allow you to trade flexibility for performance while being safe and easy to use.

Here is a basic struct example (see `struct1.mojo`):  
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
    
    fn dump(inout self):
        print(self.first)
        print(self.second)

def pair_test() -> Bool:
    let p = IntPair(1, 2)   # 4 
    dump(p)                 # => 1
                            # => 2
    let q = IntPair(2, 3)
    # does this work?
    if p < q:  # this is automatically translated to __lt__
        print("p < q")
    return True

fn main():
    pair_test()
```

The fields of a struct (here lines 1-2) need to be defined as var when they are not initialized (?? are let fields allowed), and a type is necessary. 
To make a struct, you need an __init__ method (see however § 11.1). 
The `fn __init__` function (line 3) is an "initializer" - it behaves like a constructor in other languages. It is called in line 4. 
All methods like it that start and end with __ are called *dunder* methods. They are widely used in internal code in MojoStdLib. They can be used directly (always ??) as a method call, but there are often shortcuts or operators to call them (see the StringLiteral examples in strings.mojo).  
`self` refers to the current instance of the struct, it is similar to the `this` keyword used in some other languages.

?? fn dump(inout self):    inout is not needed?

Try out:
Add the following line just after instantiating the struct:
`return p < 4`          
What do you see?
-- gives a compile time error

**Exercise**
Define a struct Point for a 3 dimensional point in space. Declare a point variable origin, and print out its items.
(see *exerc3.5.mojo*)


## 3.5 Python integration

### 3.5.1 Running Python code
To execute a Python expression, you can use the `evaluate` method:  
See `python.mojo`:
```py
x = Python.evaluate('5 + 10')   # 1
print(x)   # => 15
```

The rhs (right hand side) of line 1 is of type `PythonObject`.  
The above code is equivalent to:

```py
%%python
x = 5 + 10
print(x)
```

which is used in a Jupyter notebook running Mojo (see § 2). In the Mojo playground, using %%python at the top of a cell will run code through Python instead of Mojo.  
Python objects are all allocated on the heap, so x is a heap reference.

All the Python keywords can be accessed by importing `builtins`:
```py
let py = Python.import_module("builtins")
py.print("this uses the python print keyword")
```

Now we can use the `type` builtin from Python to see what the dynamic type of x is:
```py
py.print(py.type(x))  # => <class 'int'>
```

The address where the value of x is stored on the heap is given by the Python builtin `id`. This address itself is stored on the stack. (?? schema)

```py
py.print(py.id(x))   # =>  139787831339296
```

When Mojo uses a PythonObject, accessing the value actually uses the address in the stack to lookup the data on the heap, even for a simple integer. The heap object contains a reference count, and the runtime will free the object's memory when the count reaches 0. 
A Python object also can change its type dynamically, which is also stored in the heap object:
```py
x = "mojo"            
print(x)              # => mojo
```

All this makes programming easier, but comes with a performance cost.

The equivalent Mojo code is (see `equivalent.mojo`):
```py
x = 5 + 10
print(x)            # => 15
```

We've just unlocked our first Mojo optimization! Instead of looking up an object on the heap via an address, x is now just a value on the stack with 64 bits that can be passed through registers.

This has numerous performance implications:
* All the expensive allocation, garbage collection, and indirection is no longer required
* The compiler can do huge optimizations when it knows what the numeric type is
* The value can be passed straight into registers for mathematical operations
* There is no overhead associated with compiling to bytecode and running through an interpreter
* The data can now be packed into a vector for huge performance gains

### 3.5.3 Working with Python modules
Importing and using a Python package in Mojo is very easy.  
Here's an example of how to import the NumPy package (see `numpy.mojo`):

```py
from PythonInterface import Python           # 1

fn main():
    let np = Python.import_module("numpy")   # 2

    array = np.array([1, 2, 3])              # 3
    print(array)  # => [1  2  3]

    arr = np.ndarray([5])        # arr is a PythonObject
    print(arr)  # => [0.   0.25 0.5  0.75 1.  ]
    arr = "this will work fine"  # Python is loosely typed
    print(arr)  # => this will work fine

    ar = np.arange(15).reshape(3, 5)
    print(ar)
    print(ar.shape)                          # 4

# =>
# [[ 0  1  2  3  4]
# [ 5  6  7  8  9]
# [10 11 12 13 14]]
# (3, 5)
```

First you have to import the Python module as in line 1: `from PythonInterface import Python`.  
Then you can use the `Python.import_module()` function with the module name (see line 2). You give it a constant name (here `np`), which can be used later to call module methods.
(The equivalent of this line in Python would be: `import numpy as np`.)
Now you can use numpy as if writing in Python, see lines 3-4.

You can import any other Python module in a similar manner. Keep in mind that you must import the whole Python module.  However, you cannot import individual members (such as a single Python class or function) directly - you must import the whole Python module and then access members through the module name.

**Exercises**
1- Use the Python interpreter to calculate 2 to the power of 8 in a PythonObject and print it
(see `exerc3.1.🔥`)
2- Using the Python math module, return pi to Mojo and print it
(see `exerc3.2.🔥`)


### 3.5.4 Running Python code in the interpreter mode or in the Mojo mode
There is a great difference between running Python inside Mojo (through a Python object or %%python), and running Mojo code, although the Mojo code may be exactly the same as the Python code.  

Concrete example:
```py
x = 5 + 10
print(x)
```

In the 1st case, the Python code is interpreted at compile-time through a CPython interpreter, which communicates with the Mojo compiler.
In the 2nd case, the code is compiled to native code, and then run, which is obviously a lot faster. More in detail, here are the performance optimizations in this case:
This has numerous performance implications:
* All the expensive allocation, garbage collection, and indirection of looking up an object on the heap via an address is no longer required: a lot of Mojo values can just reside on the stack, and possibly as 64 bits chunks passed through registers.  
* The compiler can do huge optimizations when it knows what the numeric type is
* Numerical values can be passed straight into registers for mathematical operations
* There is no overhead associated with compiling to bytecode and running through an interpreter
* The data can now be packed into a vector for huge performance gains, perhaps using SIMD optimizations.


## 3.6 if else and Bool values
`guess.mojo` shows an example of a def type of function, that returns a Bool value (line 1). We define a temporary variable of type `StringLiteral` in line 2. Lines 3 and 4 then contain the if-else condition:  
`guess == luckyNumber` compares the values of guess and luckyNumber with `==`. It returns a Bool value: if the values guess and luckyNumber are equal, the expression is `True` and the first block is executed, else its value is `False`, and the else block runs.
`!=` is the inverse of `==`.

See `guess.mojo`:
```py
fn main():
    guessLuckyNumber(37)

def guessLuckyNumber(guess) -> Bool:    # 1
    let luckyNumber: Int = 37
    var result: StringLiteral = ""      # 2
    if guess == luckyNumber:            # 3
        result = "You guessed right!"   # => You guessed right!
        print(result)
        return True
    else:                               # 4
        result = "You guessed wrong!"
        print(result)
        return False
```

## 3.7 Basic types
Mojo's basic types are defined in the Built-in modules, which are automatically imported in code. This includes Bool, Int, FloatLiteral, StringLiteral and StringRef, which we'll discuss in this section.
*All* the "standard types" like `Int`, `Bool`, `String` and even `Tuple` are made using structs.

## 3.7.1 Scalar values
*Scalar* just means a single value, you'll notice in Mojo all the numerics are SIMD (see § 3.7.3) scalars, as well as the Bool type (see § 3.7.2).  

### 3.7.1.2 The Bool type
We already used this in § 3.6, and shown in `struct1.mojo`.

Defined in the module Bool as a struct, it has only 2 values True and False, and the dunder (__...__) methods bool, invert, eq, ne, and, or, xor, rand, ror, rxor. 

Here are some declarations:
see `bools.mojo`;
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
    print(False or False)     # => False
    print(True.__xor__(True)) # => False
    print(True ^ False)       # => True
    print(False ^ True)       # => True
    print(False ^ False)      # => False

    # 5 - ror, rand and rxor
    let my_number = MyNumber(1.0) # => Called MyNumber's __rand__ function
    print(True & my_number)   # => True

```
The value method gives its value (see line 1).

Reversing the value is done with the `invert` method (see line 2). De dunder-version can be called as a method on the value. `~` is the equivalent prefix operator.

Equality is tested with the `__eq__` method or the `==` operator. Non-equalitiy is tested with the  `__ne__` method or the `!=` operator.
The `__and__` method is True only if both values are True, its operator is `&`.
The `__or__` method is True only if one of both values are True, its operator is `or`.
The xor (Exclusive or), outputs True if exactly one of two inputs is True.
Its method is written as `__xor__` and its infix operator as `^` (ALT+^).

The ror, rand and rxor methods are quite special. Here is an example:  

You normally can't compare a Bool with an FloatLiteral (instance of the MyNumber here):
```py
struct MyNumber:
    var value: FloatLiteral
    fn __init__(inout self, num: FloatLiteral):
        self.value = num
```

But we can if we implement the `__rand__` method on it:
```py
    fn __rand__(self, other: Bool) -> Bool:
        print("Called MyNumber's __rand__ function")
        if self.value > 0.0 and other:
            return True
        return False
```

Now we can execute the following code as in line 5:
```py
    let my_number = MyNumber(1.0) # => Called MyNumber's __rand__ function
    print(True & my_number)   # => True
```

### 3.7.1.3 The numeric types
Here are the currently defined numerical types:
* Int  
* Int8
* Int16
* Int32
* Int64
* UInt8
* UInt16
* UInt32
* UInt64
* Float32
* Float64

In `change_type.mojo` (line 1) we see two things:  
* The type name is used to convert a value to the type (if possible):  
`UInt8(1)`
* from the error that results in assigning a StringLiteral value: `cannot implicitly convert 'StringLiteral' value to 'SIMD[ui8, 1]' in assignment`  
we see that UInt8 is just a *type alias* for SIMD[DType.uint8, 1], which is the same as SIMD[ui8, 1].  
Indeed, it is defined in the `SIMD` module as `UInt8 = SIMD[ui8, 1]`, just as all other numeric types.
The integer types are defined in module `Int`, while the floating point types live in module `FloatLiteral`.

**The `Int` type**:  
This is defined in module Int, together with a lot of useful methods, which we'll use in future examples.
Int is the same size as your architecture, so on a 64 bit machine it's 64 bits wide.

See `numerical_types.mojo`:
```py
let i: Int = 2 
print(i)

# use as indexes:
var vec_2 = DynamicVector[Int]()
vec_2.push_back(2)
vec_2.push_back(4)
vec_2.push_back(6)

print(vec_2[i])  # => 6
```

Integers can also be used as index, like in the following example (see ``)

A small handy detail about spelling: _ can separate thousands:
10_000_000

**The `FloatLiteral` type and Conversions**:

```py
    let float: FloatLiteral = 3.3
    print(float)  # => 3.2999999999999998
    let f32 = Float32(float)  # 1
    print(f32) # => 3.2999999523162842

    let f2 = FloatLiteral(i)
    print(f2) # => 2.0
    let f3 = Float32(i)
    print(f3) # => 2.0

    let i: Int = 2 
    print(i)
    # let j: Int = 3.14    # 2 - error: cannot implicitly convert 'FloatLiteral' value to 'Int'
    # let j = Int(3.14)    # 3 - error: cannot construct 'Int' from 'FloatLiteral' value in 'let' 
    # let i2 = Int(float) # convert error
    # let i2 = Int(f32) # convert error
    # let i2 = Int(float) # convert error
    # let i2 = Int(f32) # convert error
```

Equality is checked with ==, the inverse is !=
The following normal operators exist:
-, <, >, <=, >=, + (add), - (sub), *, 
/ (returns a Float)
// (floordiv): Returns lhs divided by rhs rounded down to the next whole number - 5.0 // 2.0 => 2.0
% (mod): Returns the remainder of lhs divided by rhs - print(5.0 % 2.0) => 1.0
** (pow)

**The r operations**  
radd, rsub, rmul, rtruediv, rfloordiv, rmod, rpow:
These operations allow to define the base operations for types that by default don't work with them.
Think of the r as reversed, for example in a + b, if a doesn't implement __add__, then b.__radd__(a) will run instead.

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
iadd, isub, imul, itruediv, ifloordiv, imod, ipow
i stands for in-place, the lhs becomes the result of the operation and a new object is not created.

```py
var a = 40.0
a += 2.0
print(a)  # => 42.0
```

Same for: -=, *=, /=, %=, //=, **=

If an Int or a Float value does not equal 0 or 0.0, it returns true in an if statement:
```py
if 1.0:
    print("not 0.0")  # => not 0.0

if not 0.0:
    print("is 0.0")   # => is 0.0

if 0:       # or 0.0
    print("this does not print!")
```

A FloatLiteral also takes the machine word-size (here 64 bit) as default type. 
Conversions in Mojo are performed by using the constructor as a conversion function as in: `Float32(value_to_convert)`. 
We see that a conversion from a 64bit FloatLiteral to a Float32 works, but already looses some precision.
As shown above conversion from an Int to Float works, but from FloatLiteral to an Int is not that easy. (How ??)

### 3.7.1.3 The String types
Mojo has no equivalent of a char type.
It has a `StringLiteral` type, which is built-in. In `strings.mojo` a value of that type is made in line 1. (Predict the error when you try to give it the value 20 and test it out.)  
It is written directly into the data segment of the binary. When the program starts, it's loaded into read-only memory, which means it's constant and lives for the duration of the program.
String literals are all null-terminated for compatibility with C APIs (but this is subject to change). String literals store their length as an integer, and this does not include the null terminator.
They can be converted to a Bool value (see lines 1B-C): an empty string is False, an non-empty is True. (Bool() doesn't work here).

See `strings.mojo`:
```py
fn main():
    # StringLiteral:
    var lit = "This is my StringLiteral"   # 1
    print(lit)  # => This is my StringLiteral

    # lit = 20  # => error: Expression [9]:26:11: cannot implicitly convert 'Int' value to 'StringLiteral' in assignment

    # Conversion to Bool:
    var x = ""
    print(x.__bool__())  # 1B => False
    var y = "a"
    print(y.__bool__())  # 1C => True

    var x = "abc"
    var y = "abc"
    var z = "ab"
    print(x.__eq__(y))  # 1D => True  
    print(x.__eq__(z))  # => False
    print(x == y)       # 1E => True

    var x = "abc"
    var y = "abc"
    var z = "ab"
    print(x.__ne__(y))  # => False
    print(x.__ne__(z))  # => True
    print(x != y)       # => False

    let x = "hello "
    let y = "world"
    var c = x.__add__(y)
    var d = x + y
    print(c)  # => hello world
    print(d)  # => hello world

    var x = "string"
    print(x.__len__())  # => 6
    print(len(x))       # => 6

    var x = "string"
    var y = x.data()
    x = "alo"
    print(y)  # => string
    print(x)  # => alo
    print(y)  # => string
```

Equality is tested with the dunder method __eq__ or the == operator. (1D-E). Not equality with __ne__ or != .
You can join or concatenate two two StringLiterals with __add__ or the + operator.
The length of a string is given by the __len__ method or len() function.

data get the raw pointer to the underlying data.
pointer<scalar<si8>> is the return type of the method. It means that the method returns a pointer to the underlying data of the string literal. The `si8`` indicates that the data is a sequence of 8-bit signed integers, which is a common way to represent characters in a string.

So, if you have a StringLiteral object, you can call data() on it to get a pointer to its underlying data. This could be useful if you need to pass the string data to a function that requires a pointer, or if you want to perform low-level operations on the string data.

The `String` type is not imported by default (see line 2); it represents a ]mutable string*. The `String` module contains basic methods for working with strings.
The string value is heap-allocated, but the String itself is actually a pointer to heap allocated data. This means we can load a huge amount of data into it, and change the size of the data dynamically during runtime. (Picture ??)

```py
# String:
    from String import String   # 2
    from String import ord

    s = String("Mojo🔥")       # 3
    print(s)            # => Mojo🔥
    print(s[0])         # 4 => M
    print(ord(s[0]))    # => 77
```

One way to make a String is to convert a StringLiteral value with 
`String(value)`, as in line 3.  
Strings are 0-index based, and the i-th ASCII character  can be read with  
`s[i]` (see line 4). The `ord` function gives the corresponding ASCII value of the character. (?? Doesn't work with Unicode characters).

This works because a String has an underlying data structure known as `DynamicVector[SIMD[si8, 1]]`. This is similar to a Python list, here it's storing multiple int8's that represent the characters.  
You can build a string starting from a DynamicVector, see line 5, and add two ASCII characters to it. 
To display it, print(vec) doesn't work. To do that, we can use a `StringRef` to get a pointer to the same location in memory, but with the methods required to output the numbers as text, see lines 6-7.

```py
# building a string with a DynamicVector:
    from Vector import DynamicVector
    let vec = DynamicVector[Int8](2)    # 5
    vec.push_back(78)
    vec.push_back(79)

    from Pointer import DTypePointer
    from DType import DType
    # 6:
    let vec_str_ref = StringRef(DTypePointer[DType.int8](vec.data).address, vec.size)
    print(vec_str_ref) # 7 => NO
```

Because it points to the same location in heap memory, changing the original vector will also change the value retrieved by the reference:

```py
vec[1] = 78
print(vec_str_ref)  # 8 => NN
```

In line (9) we make a deep copy `vec_str` of the string
Having made a copy of the data to a new location in heap memory, we can now modify the original and it won't effect our copy (see line 10):

```py
let vec_str = String(vec_str_ref)  # 9
print(vec_str)      # => NN

vec[0] = 65
vec[1] = 65
print(vec_str_ref)  # => AA
print(vec_str)      # 10 => NN
```

A value of type `StringRef` represents a constant reference to a string, namely: a sequence of characters and a length, which need not be null terminated.
See the code examples for how this can be used, directly or by using the pointer .data(), optionally with the length:  
* data: A pointer to the beginning of the string data being referenced
* length: The length of the string being referenced.
It has the methods getitem, equal, not equal and length:  
* getitem: gets the string value at the specified position. It receives the index of the character to get, using the brackets notation.  
* equal: compares two strings for equality

```py
    var isref = StringRef("i")
    # var isref : StringRef = StringRef("a")
    print(isref.data)      # => i
    print(isref.length)    # => 1
    print(isref)           # => i

    ## by using the pointer:
    let x = "Mojo"
    let ptr = x.data()
    let str_ref = StringRef(ptr)
    print(str_ref) # => Mojo

    let y = "string_2"
    let ptry = y.data()
    let length = len(y)
    let str_ref2 = StringRef(ptry, length)
    print(str_ref2.length) # => 8
    print(str_ref2)        # => string_2

    var x2 = StringRef("hello")
    print(x2.__getitem__(0)) # => h
    print(x2[0])             # => h

    var s1 = StringRef("Mojo")
    var s2 = StringRef("Mojo")
    print(s1.__eq__(s2))  # => True
    print(s1 == s2)       # => True
    print(s1.__ne__(s2))  # => False
    print(s1 != s2)       # => False
    print(s1.__len__())   # => 4
    print(len(s1))        # => 4
```

Emojis are actually four bytes, so we need a slice of 4 to have it print correctly (see line 11):

```py
emoji = String("🔥😀")
print("fire:", emoji[0:4])    # 11 => fire: 🔥
print("smiley:", emoji[4:8])  # => smiley: 😀
```

## 3.8 Using for loops
The following program shows how to use a for in range-loop:

See `for_range.mojo`:
```py
def main():
    for x in range(9, 0, -3):   # 1
        print(x)

# =>
# 9
# 6
# 3
```

The loop in line 1 goes from start 9 to end 0, step -3. The end value is not included.

## 3.9 Improving performance with SIMD
Mojo can use SIMD (Single Instruction, Multiple Data) on modern hardware that contains special registers. These registers allow you do the same operation across a vector in a single instruction, greatly improving performance. Here is some code using this feature (see simd.mojo):

```py
from DType import DType                 # 1

y = SIMD[DType.uint8, 4](1, 2, 3, 4)    # 2
print(y)  # => [1, 2, 3, 4]

y *= 10                                 # 3
print(y)  # => [10, 20, 30, 40]

z = SIMD[DType.uint8, 4](1)             # 4
print(z)  # => [1, 1, 1, 1]

from TargetInfo import simdbitwidth
print(simdbitwidth())  # => 512         # 5
```

SIMD is a pre-defined type (??) in Mojo. In order to use it, we need to import the `DType` module (see line 1).  
SIMD is also a generic type, indicated with the [ ] braces. We need to indicate the item type and the number of items, as is done in line 2 when declaring the SIMD-vector y.  
DType.uint8 and 4 are known as *parameters* (??); they must be known at compile-time. (1, 2, 3, 4) are the *arguments*, which can be compile-time or runtime known (for example: user input or data retrieved from an API).

y is now a vector of 8 bit numbers that are packed into 32 bits. We can perform a single instruction across all of it instead of 4 separate instructions, like *= shown in line 3.  
If all items have the same value, use the shorthand notation as for z in line 4.  

To show the SIMD register size on the current machine, use the function `simdbitwidth` from module `TargetInfo` as in line 5. The result `512` means that we can pack 64 x 8bit numbers together and perform a calculation on all of these with a single instruction!

**Exercises**
1- Initialize two single floats with 64 bits of data and the value 2.0, using the full SIMD version, and the shortened alias version, then multiply them together and print the result.
(see `exerc3.3.🔥`)
2- Create a loop using SIMD that prints four rows of data that looks like this:
    [1,0,0,0]
    [0,1,0,0]
    [0,0,1,0]
    [0,0,0,1]

Use a loop like this: for i in range(4):
                        pass
(see `exerc3.4.🔥`)


## 3.10 The ListLiteral type
This is implemented in module `BuiltinList`.  
A list consists of zero or more possibly heterogeneous values, separated by commas and enclosed in []. Because list items can be of any type, their type is `AnyType`. The types can be explicitly specified, also between [].
The items are immutable, it only includes getter methods for accessing them, nothing can be modified post-initialization.

When you initialize the list the types can be inferred (as shown in line 1), however when retrieving an item with `get` you need to provide the item's index as well as the type as parameters (lines 2A,2B):

See `listliteral.mojo`:
```py
    let list: ListLiteral[Int, FloatLiteral, StringLiteral] = [1, 5.0, "Mojo🔥"]  # 1
    print(list.get[2, StringLiteral]())  # 2A => Mojo🔥

    # much simpler:
    let list2 = [1, 5.0, "Mojo🔥"]
    print(list2.get[2, StringLiteral]())  # 2B => Mojo🔥
```

`storage` is the MLIR type that stores the literals (!pop.pack<[!kgen.declref<_"$Builtin"::_"$Int"::_Int>, !kgen.declref<_"$Builtin"::_"$FloatLiteral"::_FloatLiteral>, !kgen.declref<_"$Builtin"::_"$String"::_String>]>)


The `List` module, which is not built-in, provides methods for working with static and variadic lists.

## 3.11 The Tuple type
This is implemented in the built-in module `Tuple`.  
A tuple consists of zero or more, possibly heterogeneous (of different type) values, separated by commas and enclosed in ().  
The len function returns the number of items.
The get method together with an index and a type allows you to extract the item at that index.

See `tuple.mojo`:
```py
    @value
    struct Coord:
        var x: Int
        var y: Int


fn main():
    let t1 = (1, 2, 3)
    # let t1 = Tuple(1, 2, 3)  # type is inferred because of ()
    let tup = (42, "Mojo", 3.14)
    # let tup: Tuple[Int, StringLiteral, FloatLiteral] = (42, "Mojo", 3)
    print(tup.get[0, Int]())    # => 42
    print("Length of the tuple:", len(tup))   # => 3

    var x = (Coord(5, 10), 5.5) # 4
    # Exercise:
    print(return_tuple().get[1, Int]())  # => 2
    
fn return_tuple() -> (Int, Int):
    return (1, 2)
```

    A tuple can contain struct instances, as shown in line 4.

## 3.12 The Slice type
Slices are defined in the built-in module `BuiltinSlice`. They are the way to get substrings out of a string, or ?? sublists out of Lists.
A slice expression follows the Python convention of [start:end:step].
If we don't specify a start, it will default to 0. We can initialize slices by specifying where it should stop. The step is the number of elements to skip between each element. If we don't specify a step, it will default to 1. 
So for example using Python syntax, you could write as in line 1:

See ``slice.mojo`:
```py
    from String import String

    let original = String("MojoDojo")
    print(original[0:4])  # => Mojo
    print(original[0:8])  # => MojoDojo
    print(original[1:8:2])  # => oooo
    print(original[0:4:2])  # => Mj

    print(original[slice(0, 4)])      # => Mojo
    let slice_expression = slice(0, 4)
    print(original[slice_expression]) # => Mojo
```

[0:4] can also be written as slice(0,4). [1:8:2] as slice(1, 8, 2). This syntax is used in the bottom examples:

```py
    print(original[slice(0, 4)])      # => Mojo
    let slice_expression = slice(0, 4)
    print(original[slice_expression]) # => Mojo

    var x = String("slice it!")
    var a : slice = slice(5)
    var b : slice = slice(5, 9)
    var c : slice = slice(1, 4, 2)

    print(x[a])  # => slice
    print(x[b])  # =>  it!
    print(x[c])  # => lc
```

## 3.13 The Error type
The Error type (defined in built-in module Error) is used to handle errors in Mojo.
Code can raise an error with the `Error` type, which accepts a String message. When raise is executed, "Error: error_message" is displayed:

See `error.mojo`:
```py
fn main():
    return_error()

def return_error():
    raise Error("This returns an Error type") 
    # => Error: This returns an Error type
```

Errors can be initialized as empty, with custom messages, or even with string references:

```py
var err : Error = Error()
raise err

var custom_err : Error = Error("my custom error")
raise custom_err

var `ref` : StringRef = StringRef("hello")
var errref : Error = Error(`ref`)

raise errref
```

If the program still contains code after raising the error, you get the: `warning: unreachable code after raise statement`

The `value` field is the error message itself (see line 1).

```py
var err2 : Error = Error("something is wrong")
print(err2.value) # 1 => something is wrong
```

An internal method __copyinit__ allows an error to be copied:

```py
var err3 : Error = Error("hey")
var other : Error = err3
raise other  # => Error: hey
```

## 3.10 Overloaded functions and methods



