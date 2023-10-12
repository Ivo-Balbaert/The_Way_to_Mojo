# 3 Starting to program

## 3.1 Some preliminary remarks
* Mojo source code files must have the extension **.mojo** or **.🔥**. Otherwise, the compiler gives you an `error: no such command 'sourcefile'`.

* Source files follow the Python syntax code conventions. For example:  
    no need for semi-colons to end lines, 
    no curly braces around functions or methods,
    each new level of code is indented with 4 spaces, 
    use only spaces: convert all tabs to spaces if necessary 
    (?? other noteworthy conventions)

* Code file names are written usually in lowercase, separated by _ if needed, like *deviceinfo.mojo* or *simple_interop.mojo*. 
Never use Python or Mojo or their keywords as a filename, this will result in an error by confusing the Mojo compiler!
Never use space characters in a Mojo filename, several OS's don't like that!  
  > Note:
  > If you really need to work with a source file containing spaces (like in *space invaders.mojo*), you can use "" on Windows to compile the source like this: `mojo "space invaders.mojo"`.  
  
* For a list of keywords, see *keywords.txt*. Keywords normally cannot be used as identifiers. It is not recommended, but if it is really necessary, you can enclose a keyword in backticks `` to force its use as an identifier (see error.mojo in § 9.4 where keyword ref is used as a variable name).


## 3.2 Comments and Doc comments
Documenting your code is crucial for maintenance. This can be done in Mojo with *comments* or *docstrings*.

## 3.2.1 Normal comments with #
As in Python, code comments start with the `#` symbol. This can be used for a single-line comment, at the start of the line or in the middle of a line. Subsequent uses of # at the start of lines form a multi-line comment.   

## 3.2.2 Doc comments with """
Use `docstrings` if you need more structured comments that can be gathered by the mojo tool.
These are defined with the symbol `""" ... """`, and can be multi-line comments. They are mostly written after the header of a function, like here for the __init__ function:

```mojo
fn __init__(inout self, x: Float32):
    """Construct a complex number given a real number."""
    self.re = x
    self.im = 0.0
```

Comments are not compiled. Use comments sparingly, in general names of variables should show what they contain, and names of functions should tell us what they do.

## 3.3 The main function
To start, let's create a folder *mojo_projects*.
Open this folder in VSCode by selecting File, Open Folder.
Now create a new (empty) text file, and save it as 
*hello_world.mojo*. 

## 3.3.1 The main function is necessary
Now try to compile this empty file: `mojo hello_world.mojo`
(You can do this on the command-line, or from within VSCode (see § 2.7.2.1))

The compiler protests with:  
`mojo: error: module does not `@export` any symbols; nothing to codegen`
In other words: the mojo compiler doesn't find any code, so cannot generate any compiled code/

What does this mean?
Every Mojo program contained in a source file needs a so called *entry point* called **main**.  This is the starting point for code execution, as in many other languages.  
After all, the computer needs to know where to start executing your program!

In Mojo syntax, this looks like:

```mojo
fn main(): 
```
This is simply a *function* with name `main`.
>Note: This can also be a `def main():`.

Not only is the main function a starting point, it also envelops the complete program execution from start to end.  
() is the parameter list, which is empty for main. We also don't see a -> after the ) brace. This means main has no return value, unlike C.  
Then comes a : to mark the beginning of the function body, which contains the code to execute line by line.

Now try `mojo hello_world.mojo`. As you probably expect, it doesn't produce any output. Because there is no code in `fn main`, it doesn't do anything. But this is the first Mojo program which can be compiled!  

Let's now add a Mojo statement:

See `hello_world.mojo`:
```mojo
fn main(): 
    print("Hello World from Mojo!")
```

Run it again, and now we see the following output:  
```
[Running] mojo hello_world.mojo
Hello World from Mojo!

[Done] exited with code=0 in 0.052 seconds
```

>Note: In Python main() is not necessary, and you can use stand-alone top-level statements. If you try this in Mojo:

```mojo
print("Hello World from Mojo!")
```

you get the error:  
```
[Running] mojo top_level.mojo
top_level.mojo:1:1: error: TODO: expressions are not yet supported at the file scope level
print("Hello World from Mojo!")
^
mojo: error: failed to parse the provided Mojo

[Done] exited with code=1 in 0.033 seconds
```

This suggests that someday this will also be possible in Mojo, as it is already in a Jupyter notebook or in the Mojo REPL, where code is JIT-compiled. But right now, a `main()` function is required as the entry point to a program in a Mojo code file.  

For clarity it is best to place the `main` function at the bottom of the code file, beneath all data and other function definitions.


## 3.3.2 print and print_no_newline
The `print` function displays any string (enclosed in "") Try out if you can also use '' to envelop strings. This `print` function automatically adds a new line. So if you just want a newline, use `print()`.
If you don 't want a newline, use the function `print_no_newline`. This function can also be used to print a series of elements, joined by spaces (see the last line in the following example).

```mojo
fn main():
    print("Hello World from Mojo!")
    print_no_newline("  - starts at the same line as the following print: ")
    print('Hello World from Mojo! - 2')
    print_no_newline("A", "B", "42", 3.14) # => A B 42 3.1400000000000001
```

which displays:  
```
Hello World from Mojo!
  - starts at the same line as the following print: Hello World from Mojo! - 2
A B 42 3.1400000000000001
```

## 3.3.3 Building a Mojo source file
The command `mojo source.mojo` compiles and then runs the compiled code. It works exactly the same as `mojo run source.mojo`.   
If you want to get a compiled binary, use `mojo build source.mojo`.
For example: `mojo build hello_world.mojo`

>Note: When developing, you probably don't want to bother with building an executable. You will only start to need then when you're going to deploy into a test or production environment. But also for benchmarking it is important to do this: an executable runs at higher performance than mojo (run) itself.

Now an executable `hello_world` is build, with is quite small in size (some 23 Kb). This can be run with: `./hello_world` (on Linux) or ?? , producing the same output as above.
```
A Mojo app can be compiled into a small, standalone, fast-launching binary, making it easy to deploy while taking advantage of available cores and acceleration. 
```

In development the simple `mojo` command is just fine. But when you want to deploy your program to another environment, you need the executable. Luckily, this is only one binary with a small size, so easily deployable to cloud or embedded environments.

By splitting compilation from execution, we also make the difference between:  
* Compile-time: here the compiler scans your program and generates errors or warnings. If no errors are found, an executable is generated. 
Data that is known at compile-time is said to be *statically known*.

* Run-time: when the executable runs on your machine.
Data that is not known at compile-time but only at run-time is said to be *dynamically known*.

Later (see ??) we'll see that code can also be run at compile-time, to do what is called *meta-programming*.

## 3.4  Variables and types - def and fn
We'll now go back to discussing the last code snippet of § 2.

See `first.mojo`:
```mojo
fn main():
    var n: Int = 1      # 1
    n += 1              # 2
    print(n)            # => 2
```

Like in Python, `main()` has no parameters and no return value.

Why didn't we write the Python form `def main()`, instead of `fn main()`? It turns out that both forms of function can be used in Mojo, but they have different meaning: 
* `def` functions are dynamic, flexible and types are optional
* `fn` is meant for stricter code: it enforces strongly-typed and memory-safe behavior

Supporting both `def` and `fn` makes it easier to port Python functions to Mojo.

In line 1 a variable `n` is declared with the keyword `var`, which means it is a real mutable variable whose value can change. If you need to define an immutable variable (a constant, read-only), use `let` instead. This enhances type-safety and performance.

For both let and var the following is true:
* They create a new scoped runtime value.
* They support name shadowing, allowing variables in inner scopes to have the same name as variables in outer scopes.  
So in a nested scope, you can create a variable with a name that already exists in an outer scope. These variables will be totally independent of each other. Shadowing prevents unintended interference between variables of the same name in different scopes.
* They can include type specifiers, patterns, and late initialization.

See `late_initialization.mojo`:
```mojo
fn main():
    let discount_rate: Float64  # no initialization yet! 
    let book_id: Int = 123      # typing and initialization
    # Late initialization and pattern matching with if/else
    if book_id == 123:
        discount_rate = 0.2  # 20% discount for mystery books
    else:
        discount_rate = 0.05  # 5% discount for other book categories
    print("Discount rate for Book with ID ", book_id, "is:", discount_rate)
# => Discount rate for Book with ID  123 is: 0.20000000000000001
```

See also: bookstore.mojo

>Note: In `fn` functions all variables need to be declared with var or let.

Why is this also useful? Because Python doesn't give you an error if you mistype a variable name in an assignment, while Mojo does point this out when declaring variables with var or let.

What happens when you change var in line 1 to let? You get a compiler error:  
```
error: Expression [15]:7:5: expression must be mutable for in-place operator destination
    n += 1
    ^
```
Indeed in line 2, the value of n is incremented. The line is equivalent to: `n = n + 1`. `let` makes n immutable.

If var is omitted, you get another error:
```
error: use of unknown declaration 'n', 'fn' declarations require explicit variable declarations
    n: Int = 1      # 1
    ^
```

Unlike in def functions, in fn functions you need to use either var or let when a local variable is declared!

Also in line 1, we see that the type of n is declared as `Int`, an integer. *Declaring the type is not required for local variables in fn*, but it can be useful and increases performance.

>Note: A def used in Mojo allows to declare untyped variables just by assigning them a value. But you can also use var and let inside defs!

>Note: When using Mojo in a REPL environment (such as a Jupyter notebook), top-level variables (variables that live outside a function or struct) are treated like variables in a def, so they allow implicit value type declarations (they do not require var or let declarations, nor type declarations). This matches the Python REPL behavior.

Here is an example snippet which uses `let` for declarations: 

See `let.mojo`:
```mojo
fn do_math():
    let x: Int = 1   # 1
    let y = 2        # 2
    var z = 7        # 3
    # y = 5          # 4
    let w: Int       # 5
    print(x + y)     # => 3
    w = 42           # 6

fn main():
    do_math()
```

Here we see how `main` calls another fn function `do_math`.
A constant x of type Int (integer) is declared and initialized in line 1. Note the general format: `let/var varname: Type = value`
In line 2, the type of variable `y` is not declared, but inferred by the compiler to be Int (we could do this also in line 1). Note that you cannot write: `let w`, the statement must contain either a type or an initializing value.

In line 3 in the declaration of z, we get a useful warning:  
```
 warning: 'z' was declared as a 'var' but never mutated, consider switching to a 'let'
    var z = 7
    ^
```
>Note: Take care to only use var when really needed! The immutability of `let` is favored in the functional programming style.

If line 4 is uncommented, you get an error:
```
error: expression must be mutable in assignment
    y = 5            # 4
    ^
mojo: error: failed to parse the provided Mojo
```

Lines 5-6 show late initialization, a feature that does not exist in Python.

Mojo also supports *global variables*:  
See `global_vars.mojo`:
```mojo
var n = 42
let str = "Hello from Mojo!"

fn main():
    print(n)  # => 42
    print(str)  # => Hello from Mojo!
```

Also alias is heavily used at the global level (see § 4.4).

## 3.5  Typing in Mojo
Mojo has so-called *progressive typing*: adding more types leads to better performance and error checking, the code becomes safer and more reliable.
If the type is omitted, it is inferred by the compiler, that is: derived from the type of value the variable is initialized with (in let.mojo line 1 this was 1, an integer).

Mojo is also a *strongly-typed language", contrary to Python, which is *loosely typed*:

See `change_type.mojo`:
```mojo
fn main():
    var x = UInt8(1)          
    x = "will cause an error" # error
```

Trying to change a variable's type as in the code above leads to a compiler error.:  
```
# error: Expression [14]:20:9: cannot implicitly convert 'StringLiteral' value to 'SIMD[ui8, 1]' in assignment
#     x = "will cause an error"
#         ^~~~~~~~~~~~~~~~~~~~~
```
UInt8 is an unsigned, 1 byte integer value.

Finally, here is a naming convention:  
* variable and function names start with a lowercase letter, and follow camelCase style (example: luckyNumber).
* types (like `Int`) start with an uppercase letter, and follow PascalCase style (example: IntPair).

## 3.6 Importing modules
Mojo can import Python modules as well as modules written in Mojo itself. Here we show you the general syntax for doing so. We'll encounter many more concrete examples later on.

## 3.6.1 Mojo modules
The code of the standard library is written in *modules*. Modules are sometimes bundled together in *packages*. Module- and package names are written in all lowercase, like in Python.  
The most common code is stored in the package  `builtin`, like bool, int and dtype. Their code is automatically imported, so the types and functions of these modules are always available in your Mojo programs. 
Other modules can be imported like this:

```mojo
from benchmark import Benchmark
```

Then you can use the type Benchmark with the dot-notation to access its members like this:  
`Benchmark.num_warmup`

To avoid name-clashes or simply to shorten the name, you can use `as` to define an alias:  
```mojo
from benchmark import Benchmark as bm
```

Then access its members with: `bm.num_warmup`

`memory` is a package, containing the modules buffer, memory and unsafe. To import something from the unsafe module, write the following:

```mojo
from memory.unsafe import Pointer
```

>Note: These from ... statements can be written everywhere in code. Code clarity can be enhanced by grouping them at the start of a code file.

If you have many types to import, enclose them within (), like this:
```mojo
from sys.info import (
    alignof,
    bitwidthof,
    simdwidthof,
    simdbitwidth,
    simd_byte_width,
    sizeof
)
```
To import all types and functions from a module (say math), use:  
`from math import *`.  
However, it is recommended to only import the things you need.

You can also use:
```mojo
import benchmark
```

But then you have to access its members with: `benchmark.num_warmup`, prefixing the member name with the module name.

For some examples see: ??

## 3.6.2 Python modules
Mojo can access the whole Python ecosystem by importing Python modules.
Importing and using a Python package in Mojo is very easy.  
Here's an example (from a Jupiter notebook cell) of how to import the NumPy package:

```mojo
from python import Python            # 1

let np = Python.import_module("numpy")      # 2
```

First you have to import the Python module as in line 1: `from python import Python`.  
Then you can use the `Python.import_module()` function with the module name (see line 2). You give it a constant name (here `np`), which can be used later to call module methods.
(The equivalent of this line in Python would be: `import numpy as np`.) 
Note that the .py extension for the moudle is not needed.
For some concrete examples see: