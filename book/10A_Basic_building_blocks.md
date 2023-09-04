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
