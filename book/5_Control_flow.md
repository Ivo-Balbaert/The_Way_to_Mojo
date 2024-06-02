# 5 Control flow

## 5.1 Code blocks
Functions have a code block as their body. But also conditions and loops have a code block.
The block starts indented (with 4 spaces) at the line following the `:` symbol, as in the following code snippet: 

See `code_block.mojo`:
```py
def loop():                 # level 1
    for x in range(5):      # <-- new code block, level 2 
        if x % 2 == 0:      # <-- new code block, level 3
            print(x, end=" / ") # <-- new code block, level 4

fn main() raises:
    loop()  # => 0 / 2 / 4 /
```

A code statement can span several lines if you indent the following lines. For example: 
See `mult_lines.mojo`:
```py
def print_line():
    long_text = "This is a long line of text that is a lot easier to read if"
                " it is broken up across two lines instead of one long line."
    print(long_text)

fn main() raises:
    print_line()
    # => This is a long line of text that is a lot easier to read if it is broken up across two lines instead of one long line.
```

This is because adjacent string literals are concatenated together.

Function calls can also be chained across multiple lines:
See `mult_func_calls.mojo`:
```py
def print_hello():
    text = String(",")
          .join("Hello", " world!")
    print(text) 
    
fn main() raises:
    print_hello()
    # => Hello, world!
```

## 5.2 if else and Bool values
The general format follows the Python syntax: `if cond:  ... else:  ... `, the else or elif branches are optional.
Here is a first example of using the if-else flow in Mojo, using several numerical types and two functions:

See `if_else1.mojo`:
```py
fn func1():
   var x: Int = 42
   var y: Float64 = 17.0
   var z: Float32   

    if x != 0:       # 1
        z = 1.0      
    else:            # 2
        z = func2()    
    print(z)      # => 1.0

fn func2() -> Float32:     # 3
    return 3.14

fn main():
    func1()
```

The condition `cond` can be an expression using all the boolean operators (see § 4.2).

The 2nd example `guess.mojo` shows a function that returns a Bool value (line 1). We define a temporary variable of type `StringLiteral` in line 2. Lines 3 and 4 then contain the if-else condition:  

See `guess.mojo`:
```py
fn main():
    print(guessLuckyNumber(37)) # => True

fn guessLuckyNumber(guess: Int) -> Bool:    # 1
    varluckyNumber: Int = 37
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

Just like in Python, this can be expanded with one or more elif branches:
```py
if cond1:
    ...
elif cond2:
    ...
elif cond3:
    ...
else:
    ...
```

(In a __init__) You can also use constructs like:  
`self.height = height if height > 0 else 1`

If statements can be nested inside each other.

If an Int or a Float value does not equal 0 or 0.0, it returns True in an if statement:
See `if_number.mojo`:
```py
if 1.0:
    print("not 0.0")  # => not 0.0

if not 0.0:
    print("is 0.0")   # => is 0.0

if 0:       # or 0.0
    print("this does not print!")
```

Note that these if statements generate a warning: 
```
warning: if statement with constant condition 'if True'
    if 1.0:
       ^
/home/ivo/mojo/test/floats.mojo:33:8: warning: if statement with constant condition 'if False'
    if 0:                 # or 0.0
       ^
```

if can be used in one line as an expression.
See `if_expr.mojo`:
```py
fn main():
    var x = 42
    var message = "x is positive" if x >= 0 else "x is negative"
    print(message)  # => x is positive
```

### 5.2.1 The walrus operator :=
The walrus operator now works in if/while statements without parentheses, e.g.:  
`if x := function():`

Example: !!


## 5.2 Using for loops
The following program shows how to use a for in range-loop:
(see also previous exemples: String)

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

The loop in line 1 goes from start 9 to end 0, step -3. The end value 0 is not included, so a range(n) goes from 0 to n-1.

for can have an optional else: block, executed exactly once when the iteration is finished.

for is based on something called an iterator.
In the most simple term, an iterator is something that returns an element when its next method is called. The expression that comes after in within the for loop statement must resolve to an iterable. 
!! What comes after in must be an interable. An iterable is anything that returns an iterator when its iter method is called. In effect, when the for loop is executed, it calls the iterable’s iter method which returns the iterator the for loop works with. For each repetition of the loop, the iterator’s next is called and its result assigned to the variable coming before the in keyword. The iterator must keep track of the state so that the for loop advances to the next element when next is called.

## 5.3 Using while loops
Just like in Python, you can make a loop with a condition through `while`:

See `while.mojo`:
```py
fn main():
    var n = 0
    while n <= 10_000_000:
        n += 1
    else:
        print("n is now greater than 10_000_000") # => n is now greater than 10_000_000
    print(n) # => 10_000_001
```

You can add an optional else: block (see line 1) which executes exactly once when the condition becomes False:

**Skipping and exiting early from loops**  
break can be used to jump out of a loop.
continue can be used to stop the current loop iteration and continue with the next iteration.

## 5.4 Catching exceptions with try-except-finally
!! better example
!! better move to § 9.4

If your code is expected to possibly raise an error (exception), either the enveloping function must be postfixed with `raises`, or you can enclose the code like this:  
```py
    try:
        # possible dangerous code
    except:
        # what to do when an exception occurs
    finally:
        # optional: what to do in ant case, such as clean up resources.
```

For a concrete example, see `try_except.mojo` in § 6.2 

Enhanced example: see `try_except2.mojo`:
```py
from random import random_float64, seed

alias flip_a_coin = random_float64
alias tail = 0.5


def say_three():
    raise Error("⚠️ no time to say three")


fn count_to_5() raises:
    print("count_to_5: one")
    print("count_to_5: two")
    try:
        _ = say_three()
    except e:
        print("\t count_to_5: error", e)

        if flip_a_coin() > tail:
            raise Error("⚠️ we stopped at three")
        else:
            print("count_to_5: three ⛑️")

    print("count_to_5: four")
    print("count_to_5: five")


fn main() raises:
    seed()

    try:
        count_to_5()
    except e:
        print("error inside main(): ", e)
        # main: error e
        if e.__repr__() == "⚠️ we stopped at three":
            print("main: three ⛑️")
            print("main: four ⛑️")
            print("main: five ⛑️")

    print("✅ main function: all good") 
# =>
# count_to_5: one
# count_to_5: two
# 	 count_to_5: error ⚠️ no time to say three
# count_to_5: three ⛑️
# count_to_5: four
# count_to_5: five
# ✅ main function: all good

# or:
# count_to_5: one
# count_to_5: two
# 	 count_to_5: error ⚠️ no time to say three
# error inside main():  ⚠️ we stopped at three
# main: three ⛑️
# main: four ⛑️
# main: five ⛑️
# ✅ main function: all good
```

**Raising**
def() functions can call raising functions and can raise by default
fn() raises is necessary in order to raise
fn() cannot call functions that might raise, for example: a def function that raises by default
**Try:**
Inside the try block, we can call functions that could raise and error. It is also possible to Raise an error.
If an error is thrown, the execution continue at the beginning of the except: block just below
**Except e:**
Here it is possible to inspect the error e, based on that, we can fix it.
If fixed, the the execution continues on the first line after the except block.
If it is not possible to fix it, it is possible to Raise an error: either the same or another.
The error will be transferred to the next Except: block. 



## 5.5 The with statement
In Python the with statement is used to create a context. Whatever statements we execute inside that context does not affect the outer environment. The with statement simplifies exception handling by encapsulating common preparation and cleanup tasks. 
It is commonly used as `with open(file)` to read a file and close it automatically at the end of the context (see § 10.12).  

For example:
See `with.mojo`
```py
with open("my_file.txt", "r") as file:
    print(file.read())

    # Other stuff happens here (whether using `file` or not)...
    foo()
    # `file` is alive up to the end of the `with` statement.

# `file` is destroyed when the statement ends.
bar()
```

For any value defined at the entrance of a with statement (like `file` here), Mojo will keep that value alive until the end of thestatement.

!! In Mojo it is used to create a parallelization context (no longer the same code!), for example in mandelbrot_4.mojo:
```py
from runtime.llcl import num_cores, Runtime

with Runtime() as rt:

        @parameter
        fn bench_parallel[simd_width: Int]():
            parallelize[worker](rt, height, height)

       varparallelized_ms = Benchmark().run[bench_parallel[simd_width]]() / 1e6
```


## 5.6 Exiting from a program
This will eventually be implemented. For now you can use this function:

See `exit.mojo`:
```py
fn main():
    print("before exit")  # => before exit
    _ = exit(-2)          # exit the program
    print("after exit")


fn exit(status: Int32) -> UInt8:
    return external_call["exit", UInt8, Int32](status)
```

with output:  
```
[Running] mojo exit.mojo
before exit

[Done] exited with code=254 in 0.391 seconds
```

`external_call` is a function defined in module sys.ffi.