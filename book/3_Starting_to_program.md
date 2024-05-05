# 3 Starting to program

## 3.1 Some preliminary remarks
* Mojo source code files must have the extension **.mojo** or **.🔥**. Otherwise, the compiler gives you an `error: no such command 'sourcefile'`.

* Source files follow the Python syntax code conventions. For example:  
    no need for semi-colons to end lines, 
    no curly braces around functions or methods,
    each new level of code (a so-called *code block*) is indented with 4 spaces, 
        an indentation mistake will result in a compiler error.
        a code block can contain a number of consecutive code lines with the same indentation
        code blocks can be nested: the nested block is indented as a whole (see also § 5.1). 

    use only spaces: convert all tabs to spaces if necessary 
    (?? other noteworthy conventions)

* Code file names are written usually in lowercase, separated by _ if needed, like *deviceinfo.mojo* or *simple_interop.mojo*. 
Never use Python or Mojo or their keywords as a filename, this will confuse the Mojo compiler and result in an error. 
Never use space characters in a Mojo filename, several OS's don't like that!  
  > Note:
  > If you really need to work with a source file containing spaces (like in *space invaders.mojo*), you can use "" on Windows to compile the source like this: `mojo "space invaders.mojo"`.  
  
* For a list of keywords, see *keywords.txt*. Keywords normally cannot be used as identifiers. It is not recommended, but if it is really necessary, you can enclose a keyword in backticks `` to force its use as an identifier (see error.mojo in § 9.4 where keyword ref is used as a variable name).



## 3.2 Comments and Doc comments
Documenting your code is crucial for maintenance. This can be done in Mojo with *comments* or *docstrings*.

## 3.2.1 Normal comments with #
As in Python, code comments start with the `#` symbol. This can be used for a single-line comment, at the start of the line or in the middle of a line. Subsequent uses of # at the start of lines form a multi-line comment.   

## 3.2.2 Doc comments with """
Use `docstrings` if you need more structured comments (for example: API documentation) that can be gathered by the `mojo doc` tool.
These are defined with the symbol `""" ... """`, and can be multi-line comments. They are mostly written after the header of a function, like here for the __init__ function:

Here is a program with docstrings: (see § 7.4.1  overloading.mojo)
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

The command `mojo doc overloading.mojo` currently shows the following JSON output (it is planned to also generate HTML in the future):

```
{
  "decl": {
    "aliases": [],
    "description": "",
    "functions": [
      {
        "kind": "function",
        "name": "main",
        "overloads": [
          {
            "args": [],
            "async": false,
            "constraints": "",
            "description": "",
            "isDef": false,
            "isStatic": false,
            "kind": "function",
            "name": "main",
            "parameters": [],
            "raises": false,
            "returnType": null,
            "returns": "",
            "signature": "main()",
            "summary": ""
          }
        ]
      }
    ],
    "kind": "module",
    "name": "overloading",
    "structs": [
      {
        "aliases": [],
        "constraints": "",
        "description": "",
        "fields": [
          {
            "description": "",
            "kind": "field",
            "name": "re",
            "summary": "",
            "type": "SIMD[f32, 1]"
          },
          {
            "description": "",
            "kind": "field",
            "name": "im",
            "summary": "",
            "type": "SIMD[f32, 1]"
          }
        ],
        "functions": [
          {
            "kind": "function",
            "name": "__init__",
            "overloads": [
              {
                "args": [
                  {
                    "description": "",
                    "inout": true,
                    "kind": "argument",
                    "name": "self",
                    "owned": false,
                    "passingKind": "pos",
                    "type": "Self"
                  },
                  {
                    "description": "",
                    "inout": false,
                    "kind": "argument",
                    "name": "x",
                    "owned": false,
                    "passingKind": "pos_or_kw",
                    "type": "SIMD[f32, 1]"
                  }
                ],
                "async": false,
                "constraints": "",
                "description": "",
                "isDef": false,
                "isStatic": false,
                "kind": "function",
                "name": "__init__",
                "parameters": [],
                "raises": false,
                "returnType": null,
                "returns": "",
                "signature": "__init__(inout self: Self, x: SIMD[f32, 1])",
                "summary": "Construct a complex number given a real number."
              },
              {
                "args": [
                  {
                    "description": "",
                    "inout": true,
                    "kind": "argument",
                    "name": "self",
                    "owned": false,
                    "passingKind": "pos",
                    "type": "Self"
                  },
                  {
                    "description": "",
                    "inout": false,
                    "kind": "argument",
                    "name": "r",
                    "owned": false,
                    "passingKind": "pos_or_kw",
                    "type": "SIMD[f32, 1]"
                  },
                  {
                    "description": "",
                    "inout": false,
                    "kind": "argument",
                    "name": "i",
                    "owned": false,
                    "passingKind": "pos_or_kw",
                    "type": "SIMD[f32, 1]"
                  }
                ],
                "async": false,
                "constraints": "",
                "description": "",
                "isDef": false,
                "isStatic": false,
                "kind": "function",
                "name": "__init__",
                "parameters": [],
                "raises": false,
                "returnType": null,
                "returns": "",
                "signature": "__init__(inout self: Self, r: SIMD[f32, 1], i: SIMD[f32, 1])",
                "summary": "Construct a complex number given its real and imaginary components."
              }
            ]
          }
        ],
        "kind": "struct",
        "name": "Complex",
        "parameters": [],
        "parentTraits": [
          "AnyType"
        ],
        "summary": ""
      }
    ],
    "summary": "",
    "traits": []
  },
  "version": "24.2.0"
  ```

Comments are not compiled. Use comments sparingly, in general names of variables should show what they contain, and names of functions should tell us what they do.

## 3.3 The main function
To start, let's create a folder *mojo_projects*.
Open this folder in VSCode by selecting File, Open Folder.
Now create a new (empty) text file, and save it as 
*hello_world.mojo*. 

Now try to compile this empty file: `mojo hello_world.mojo`
(You can do this on the command-line, or from within VSCode (see § 2.10.3))

The compiler protests with:  
`mojo: error: error: module does not define a `main` function`
In other words: the mojo compiler doesn't find a main() function from where to start execution.

What does this mean?
Every executable Mojo program contained in a source file needs a so called *entry point* called **main**.  This is the starting point for code execution, as in many other languages.  
After all, the computer needs to know where to start executing your program!

In Mojo syntax, this looks like:

```py
fn main(): 
```
This is simply a *function* with name `main`.
>Note: This can also be a `def main():`.

Not only is the main function a starting point, it also envelops the complete program execution from start to end.  
() is the parameter list, which is empty for main. We also don't see a -> after the `)` brace. This means main has no return value, unlike C.  
Then comes a `:` to mark the beginning of the function body, which contains the code to execute line by line.

Now try `mojo hello_world.mojo`. As you probably expect, it doesn't produce any output. Because there is no code in `fn main`, it doesn't do anything. But this is the first Mojo program which can be compiled!  

Let's now add a Mojo statement:

See `hello_world.mojo`:
```py
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

```py
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


## 3.4 The print function
We need a way to show us the values of variables: `print` does that for us.
The `print` function displays any string (enclosed in "", try out if you can also use '' to envelop strings). `print` can also be used to print a series of elements, joined by spaces (see the last line in the following example).
  
The `print` function automatically adds a new line. So if you just want a newline, use `print()`.
`print` takes sep and end keyword arguments. This means that you can write:

```
print("Hello", "Mojo", sep=", ", end="!!!\n") # prints Hello, Mojo!!!
```
sep defaults to the empty string and end defaults to "\n".

See `hello_world.mojo`:
```py
fn main():
    print("Hello World from Mojo!")
    print("  - starts at the same line as the following print: ", end="")
    print('Hello World from Mojo! - 2')
    print("A", "B", "42", 3.14, end="") # => A B 42 3.1400000000000001
```

which displays:  
```
Hello World from Mojo!
  - starts at the same line as the following print: Hello World from Mojo! - 2
A B 42 3.1400000000000001
```
## 3.5 Using assert_equal
Instead of printing out two variables a and b to see whether they are equal: `print(a == b)`,   
we can also use `assert_equal(a, b)` from module testing.

See `assert_eq.mojo`:
```py
from testing import assert_equal

fn main() raises:
    var a = 1
    var b = 2   # 2
    # var b = a   # 3
    assert_equal(a, b)  

# =>
# Unhandled exception caught during execution: AssertionError: `left == right` comparison failed:
#   left: 1
#   right: 2
```

This now will only print out a message with AssertionError when a is not equal to b. 
(In fact it is even worse, it crashed the program!)
Replace line 2 by line 3 to make the message disappear. So normally using assert_equal, we trust that a == b and no output is produced.
(Look in the docs for the other assert_ functions in module testing)

## 3.6 Building a Mojo source file
The command `mojo source.mojo` compiles and then runs the compiled code. It works exactly the same as `mojo run source.mojo`.   
If you want to get a compiled binary, use `mojo build source.mojo`.
For example: `mojo build hello_world.mojo`

>Note: When developing, you probably don't want to bother with building an executable. You will only start to need this when you're going to deploy into a test or production environment. But also for benchmarking it is important to do this: an executable runs at higher performance than mojo (run) itself.

Now an executable `hello_world` is build. This can be run with: `./hello_world` (on Linux/MacOS) or hello_world, producing the same output as above.
?? Output is relatively big some 44Mb ?? issue 
[BUG]: Mojo hello world binary size unreasonably large #599 
(closed - open a new issue ??)

>Note: A Mojo app can be compiled into a small, standalone, fast-launching binary, making it easy to deploy while taking advantage of available cores and acceleration. 

In development, the simple `mojo` command is just fine. But when you want to deploy your program to another environment, you need the executable. Luckily, this is only one binary with a small size, so easily deployable to cloud or embedded environments.


## 3.7 Compile-time and runtime
Using `mojo build` splits compilation from execution. This means we can also make the difference between:  
* *Compile-time*: here the compiler scans your program and generates errors or warnings. If no errors are found, an executable (native code) is generated. 
Data that is known at compile-time is said to be *statically known*.
For example: you can execute a function during compile-time, which performs a heavy calculation to end up with some value(s) or a data structure. This result can be bound to a variable with `alias` (see § 4.6.1), so that it is immediately available at run-time.

* *Run-time*: when the executable runs on your machine.
Often data is not known at compile-time, but only at run-time, for example because it is read in or calculated at run-time. Such data is said to be *dynamically known*.

Later (see ??) we'll see that code can also be run at compile-time, to do what is called *meta-programming*. This enables Mojo to do simulate some types of dynamic programming.

## 3.8 Variables, types and addresses
### 3.8.1 Using def and fn
We'll now go back to discussing the last code snippet of § 2.

See `first.mojo`:
```py
fn main():
    var n: Int = 1      # 1
    n += 1              # 2
    print(n)            # => 2
```

In line 1 a variable `n` is declared with the keyword `var`, which means it is a real mutable variable whose value can change. The typing `n: Int` is optional, Mojo has type inference.

Like in Python, `main()` has no parameters and no return value.

Why didn't we write the Python form `def main()`, instead of `fn main()`? 
Here is the equivalent version with def main():

See `first_def.mojo`:
```py
def main():
    n = 1      # 1
    n += 1
    print(n)   # => 2
```

So both forms of function can be used in Mojo, but they have a different meaning: 
* `def` functions are dynamic, flexible and types are optional; using `var` is also not necessary.
* `fn` is meant for stricter code: it enforces strongly-typed and memory-safe behavior

Supporting both `def` and `fn` makes it easier to port Python functions to Mojo.

If var is omitted in line # 1 in the `fn` version, you get another error:
```
error: use of unknown declaration 'n', 'fn' declarations require explicit variable declarations
    n: Int = 1      # 1
    ^
```
Unlike in def functions, in `fn` functions you need to use var when a local variable is declared!

Why is this useful? Because Python doesn't give you an error if you mistype a variable name in an assignment, while Mojo does point this out when declaring variables with var in an `fn` function:

```py
var last_name = "Jones"
# ...
lst_name = "Carter"  # error: use of unknown declaration 'lst_name'
```

Also in line 1, we see that the type of n is declared as `Int`, an integer. *Declaring the type is not required for local variables in fn*, but it can be useful, making the code safer.

>Note: In a def function as well as in the REPL, you can declare untyped variables just by assigning them a value, and without using `var` (but you can also use var inside defs).

All variables in Mojo are *mutable*: their value can be changed. If you want to define constant values, use *alias* (see § 4.4).


### 3.8.2 Late initialization
Variables can also get a value some time after they have been declared (so-called late initialization):

See `late_initialization.mojo`:
```py
fn main():
    var discount_rate: Float64  # no initialization yet! 
    var book_id: Int = 123      # typing and initialization
    # Late initialization and pattern matching with if/else
    if book_id == 123:
        discount_rate = 0.2   # 20% discount for mystery books
    else:
        discount_rate = 0.05  # 5% discount for other book categories
    print("Discount rate for Book with ID ", book_id, "is:", discount_rate)
# => Discount rate for Book with ID  123 is: 0.20000000000000001
```

If line 1 is commented out like this:  #  1 - var discount_rate: Float64  # no initialization yet! 
you get the error: `error: use of unknown declaration 'discount_rate'`
So every variable must be declared before it is used.

See also as a more elaborate example: bookstore.mojo

Here is another example using where main() calls another function domath(), which uses explicit typing and inference:
See `var.mojo`:
```py
fn do_math():
    var x: Int = 1   # 1
    var y = 2        # 2
    var z = 7        # 3
    var w: Int       # 4
    print(x, y, x + y)     # => 1 2 3
    w = 42           # 5

fn main():
    do_math()
```

Here we see how `main` calls another fn function `do_math`.
A constant x of type Int (integer) is declared and initialized in line 1.  
Note the general format: `var varname: Type = value`
In line 2, the type of variable `y` is not declared, but inferred by the compiler to be Int (we could do this also in line 1). Note that you cannot write: `var w` in line 4: the statement must contain either a type or an initializing value.
Lines 5 shows late initialization, a feature that does not exist in Python.

### 3.8.3 Lexical scoping and name shadowing
Let's examine the following code:
`scoping.mojo`:
```py
fn lexical_scopes():      # fn could also be def
    var num = 10
    var dig = 1
    if True:
        print("num:", num)  # Reads the outer-scope "num"
        var num = 20        # Creates new inner-scope "num"  # 1
        print("num:", num)  # Reads the inner-scope "num"
        dig = 2             # Edits the outer-scope "dig"
    print("num:", num)      # Reads the outer-scope "num"
    print("dig:", dig)      # Reads the outer-scope "dig"

def function_scopes():
    num = 1
    if num == 1:
        print(num)   # Reads the function-scope "num"
        num = 2      # Updates the function-scope variable # 2
        print(num)   # Reads the function-scope "num"
    print(num)       # Reads the function-scope "num"


fn main() raises:
    lexical_scopes() # =>
    # num: 10
    # num: 20
    # num: 10
    # dig: 2
    function_scopes() #  
    # 1
    # 2
    # 2
```

Variables declared with var as in `fn lexical_scopes()` obey so-called *lexical scoping* :
*  a nested code block can read and modify variables defined in an outer scope,
*  but an outer scope cannot read variables defined in an inner scope.

So name shadowing can occur: you can create a variable in a nested scope with a name that already exists in an outer scope. The variable `num` in line 1 shadows (or hides) the outer `num` variable. The inner `num` is only known inside the if-block.
These variables will be totally independent of each other. Shadowing prevents unintended interference between variables of the same name in different scopes.

In `def function_scopes()` the variables are NOT declared with var. The inner num variable in line 2 updates the value of the outer num variable, as you see in the last printed output. In this case, variables follow *function scoping* as in Python. 

### 3.8.4 Global variables
?? doesn't work as of 2024-04-20:
https://github.com/modularml/mojo/issues/1573
Mojo also supports *global variables*:  
See `global_vars.mojo`:
```py
var n = 42
var str = "Hello from Mojo!"

fn main():
    print(n)    # => 42
    print(str)  # => Hello from Mojo!
```

?? 2024-04-20: Output is 
0


The current design of Mojo does not support the use of global variables inside functions, except for main (see https://github.com/modularml/mojo/discussions/448)

Also alias is heavily used at the global level (see § 4.4).

### 3.8.5 Variable addresses
(?? Include images for the pointers)
Mojo variables are much more like C variables than like Python variables: a name in Mojo is attached to an object.

See `variable_addresses.mojo`:
```py
from memory.unsafe import Pointer

def print_pointer(ptr: Pointer):
    print(ptr.__int__())

def main():
    a = 1
    p1 = Pointer.address_of(a)  
    print_pointer(p1)           # => 140726871503576

    a = 2
    p2 = Pointer.address_of(a)
    print_pointer(p2)           # => 140726871503576
```
This means that there is only one integer variable a, which has been modified in-place with the statement a = 2. In contrast, in equivalent Python code:

```py
a = 1
print(id(a)) # => 140163769254128
a = 2
print(id(a)) # => 140163769254160
```

such that id(2) - id(1) is 32. The name (the reference) a first points towards the int object 1 . The statement a = 2 modifies the reference and not the integer object.

In Python, references are everywhere (the names are references, elements in a list/tuple are references, function arguments are passed as references). It does not work like that with Mojo, which has strong consequences. For example, in Python a = "py"; b = a creates two references pointing towards one object ( "py" ). In contrast, a = "mojo"; b = a creates two different objects at two different locations in memory so that:

```py
    a = "mojo"
    p = Pointer.address_of(a) # => 140722059283008
    print_pointer(p)

    b = a  # <- this copies the String object "mojo"
    p = Pointer.address_of(b) # => 140722059283024
    print_pointer(p)
```

## 3.9  Typing in Mojo
Mojo has so-called *progressive typing*: adding more types leads to better performance and error checking, the code becomes safer and more reliable.
If the type is omitted, it is inferred by the compiler, that is: derived from the type of value the variable is initialized with.

Mojo is also a *strongly-typed language", contrary to Python, which is *loosely typed*:

See `change_type.mojo`:
```py
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
*Exercise*:
Try this in Python, it will work without problem!

Finally, here is a naming convention, following Python's example:  
* variable and function names start with a lowercase letter, with words separated by underscores as necessary to improve readability (example: lucky_number).
* types (like `Int`) start with an uppercase letter, and follow PascalCase style (example: IntPair).


