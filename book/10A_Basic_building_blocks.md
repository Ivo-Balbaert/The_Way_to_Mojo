If the return value of a function is not used, you get a  `warning: 'Bool' value is unused` see guess.mojo, with guessLuckyNumber(37). You can print out the return value, or just discard the value with _ = guessLuckyNumber(37).

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

The default argument convention for fn functions is *borrowed*. You can make this explicit by writing:  

```py
fn sum(borrowed x: Int, borrowed y: Int) -> Int:  
    return x + y
```

## 3.3 Can a function change its arguments? - Argument passing control and memory ownership
* All values passed into a Python def function use reference semantics. This means the function can modify mutable objects passed into it and those changes are visible outside the function. 
* All values passed into a Mojo def function use value semantics by default. Compared to Python, this is an important difference: A Mojo def function receives a copy of all arguments—it can modify arguments inside the function, but the changes are not visible outside the function.
* All values passed into a Mojo fn function are immutable references by default. This means the function can read the original object (it is not a copy), but it cannot modify the object at all: this is called *borrowing*.

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
An even stronger option is to declared an argument as *owned*. Then the function gets full ownership of the value, so that it’s mutable, but also guaranteed unique. This means the function can modify the value and not worry about affecting variables outside the function.  
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
    The ^ operator ends the lifetime of a value binding and transfers the value ownership to something else

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

>Note: Python classes are dynamic: they allow for dynamic dispatch, monkey-patching (or "swizzling"), and dynamically binding instance properties at runtime. However, Mojo structs are completely static - they are bound at compile-time and you cannot add methods at runtime, so they do not allow dynamic dispatch or any runtime changes to the structure. Structs allow you to trade flexibility for performance while being safe and easy to use.

Example § 4: inout2.mojo - two ways to declare struct instance: A and B

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
All methods like it that start and end with __ are called *dunder*  (double-underscore) methods. They are widely used in internal code in MojoStdLib. They can be used directly (always ??) as a method call, but there are often shortcuts or operators to call them (see the StringLiteral examples in strings.mojo).  
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

### 3.5.2 Running Python code in the interpreter mode or in the Mojo mode
This has numerous performance implications:
* All the expensive allocation, garbage collection, and indirection is no longer required
* The compiler can do huge optimizations when it knows what the numeric type is
* The value can be passed straight into registers for mathematical operations
* There is no overhead associated with compiling to bytecode and running through an interpreter
* The data can now be packed into a vector for huge performance gains

There is a great difference between running Python inside Mojo (through a Python object or %%python), and running Mojo code, although the Mojo code may be exactly the same as the Python code.  

In the 1st case, the Python code is interpreted at compile-time through a CPython interpreter, which communicates with the Mojo compiler.
In the 2nd case, the code is compiled to native code, and then run, which is obviously a lot faster. More in detail, here are the performance optimizations in this case:

### 3.5.3 Working with Python modules

```py
from python import Python           # 1

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


Now you can use numpy as if writing in Python, see lines 3-4.

You can import any other Python module in a similar manner. Keep in mind that you must import the whole Python module.  However, you cannot import individual members (such as a single Python class or function) directly - you must import the whole Python module and then access members through the module name.

### 3.5.4 Mojo types in Python
Mojo primitive types implicitly convert into Python objects. Today we support lists, tuples, integers, floats, booleans, and strings.


See `mojo_types.mojo`: (works only in a cell in Jupyter notebook)
```py
%%python
def type_printer(my_list, my_tuple, my_int, my_string, my_float):
    print(type(my_list))
    print(type(my_tuple))
    print(type(my_int))
    print(type(my_string))
    print(type(my_float))

type_printer([0, 3], (False, True), 4, "orange", 3.4)
```

## 3.5.5 Importing local Python modules
see matmul.mojo

**Exercises**
1- Use the Python interpreter to calculate 2 to the power of 8 in a PythonObject and print it
(see `exerc3.1.🔥`)
2- Using the Python math module, return pi to Mojo and print it
(see `exerc3.2.🔥`)


## 3.9 Improving performance with SIMD
Mojo’s SIMD type ID defined as a struct and exposes the common SIMD operations in its methods, making the SIMD data type and size values parametric. This allows you to directly map your data to the SIMD vectors on any hardware.

SIMD struct is a generic type definition (see § ??)

Mojo can use SIMD (Single Instruction, Multiple Data) on modern hardware that contains special registers. These registers allow you do the same operation across a vector in a single instruction, greatly improving performance. Here is some code using this feature (see simd.mojo):

General format: SIMD[DType.type, size]  
* type specifies the data type, for example: uint8, float32 
* the `len` is the size ( which must be a power of 2), and it specifies the length of the SIMD vector, for example 1, 2, 4, and so on

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



## 3.13 Overloaded functions and methods
Like in Python, you can define functions in Mojo without specifying argument data types and Mojo will handle them dynamically. This is nice when you want expressive APIs that just work by accepting arbitrary inputs and let *dynamic dispatch* decide how to handle the data. However, when you want to ensure type safety, as discussed above, Mojo also offers full support for overloaded functions and methods.  
This allows you to define multiple functions with the same name but with different arguments. This is a common feature called *overloading*, as seen in many languages, such as C++, Java, and Swift.  
When resolving a function call, Mojo tries each candidate and uses the one that works (if only one works), or it picks the closest match (if it can determine a close match), or it reports that the call is ambiguous if it can’t figure out which one to pick. In the latter case, you can resolve the ambiguity by adding an explicit cast on the call site.  

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
```

Here we see how the __init__ constructor is overloaded.

You can overload methods in structs and classes and overload module-level functions.

Mojo doesn’t support overloading solely on result type, and doesn’t use result type or contextual type information for type inference, keeping things simple, fast, and predictable.  
Again, if you leave your argument names without type definitions, then the function behaves just like Python with dynamic types. As soon as you define a single argument type, Mojo will look for overload candidates and resolve function calls as described above.

Although we haven’t discussed parameters yet (they’re different from function arguments), you can also overload functions and methods based on parameters.  

## 3.15 Difference between fn and def
`def` is defined by necessity to be very dynamic, flexible and generally compatible with Python: arguments are mutable, local variables are implicitly declared on first use, and scoping isn’t enforced. This is great for high level programming and scripting, but is not always great for systems programming.  
To complement this, Mojo provides an `fn` declaration which is like a "strict mode" for def.

fns have a number of limitations compared to def functions:
* Argument values default to being immutable in the body of the function (like a let), instead of mutable (like a var). This catches accidental mutations, and permits the use of non-copyable types as arguments.
* Argument values require a type specification (except for self in a method), catching accidental omission of type specifications. Similarly, a missing return type specifier is interpreted as returning `None` instead of an unknown return type. Note that both can be explicitly declared to return `object`, which allows one to opt-in to the behavior of a def if desired.
* Implicit declaration of local variables is disabled, so all locals must be declared. This catches name typos and dovetails(??) with the scoping provided by let and var.
* Both support raising exceptions, but this must be explicitly declared on a fn with the `raises` keyword.

**Functions parameters and arguments**
FunctionName[parameters](arguments)
Example: 
`SIMD[DType.uint8, 4](1, 2, 3, 4)`
The parameters serve to define which type(s) are used in a generic type.
The arguments are used as values within the function

----------------------------------------------------------------------------------
* from the error that results in assigning a StringLiteral value: `cannot implicitly convert 'StringLiteral' value to 'SIMD[ui8, 1]' in assignment`  
we see that UInt8 is just a *type alias* for SIMD[DType.uint8, 1], which is the same as SIMD[ui8, 1].  
Indeed, it is defined in the `SIMD` module as `UInt8 = SIMD[ui8, 1]`, just as all other numeric types.


