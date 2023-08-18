# 3 Basic building blocks
We'll start by discussing the last code snippet of § 2.

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

We also declare a variable `n` with the keyword `var`, which means it is a real mutable variable whose value can change. If you need to define an immutable variable (a constant), use `let` instead.

>Note: Take care to only use var when really needed!

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
* variable and function names start with a lowercase letter
* types (like `Int`) start with an uppercase letter, and follow PascalCase style.

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

## 3.3.3  owned and transferred with ^
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
However, Mojo structs are completely static - they are bound at compile-time, so they do not allow dynamic dispatch or any runtime changes to the structure.

Here is a basic struct example (see `struct1.mojo`):  
```py
struct IntPair:   
    var first: Int          # 1
    var second: Int         # 2

    fn __init__(inout self, first: Int, second: Int):   # 3
        self.first = first
        self.second = second
    
    fn dump(inout self):
        print(self.first)
        print(self.second)

def pair_test() -> Bool:
    let p = IntPair(1, 2)   # 4 
    dump(p)                 # => 1
                            # => 2
    return True

fn main():
    pair_test()
```

The fields of a struct (here lines 1-2) need to be defined as var when they are not initialized (?? are let fields allowed), and a type is necessary.  
The `fn __init__` function (line 3) is an "initializer" - it behaves like a constructor in other languages. It is called in line 4. All methods like it that start and end with __ are called *dunder* methods.  
`self` refers to the current instance of the struct, it is similar to the `this` keyword used in some other languages.

?? fn dump(inout self):    inout is not needed?

Try out:
Add the following line just after instantiating the struct:
`return p < 4`          
What do you see?
-- gives a compile time error

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

    arr = np.ndarray([5])
    print(arr)  # => [0.   0.25 0.5  0.75 1.  ]
    arr = "this will work fine"
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
Mojo's basic types are defined in the Built-in modules, which are automatically imported in code.




## 3.8 Improving performance with SIMD
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




