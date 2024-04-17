# 5 Control flow

## 5.1 if else and Bool values

The general format follows the Python syntax: `if cond:  ... else:  ... `
Here is a first example of using the if-else flow in Mojo, using several numerical types and two functions:

See `if_else1.mojo`:
```mojo
fn func1():
    let x: Int = 42
    let y: Float64 = 17.0
    let z: Float32   

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

The condition cond can be an expression using all the boolean operators (see § 4.1).

The 2nd example `guess.mojo` shows function that returns a Bool value (line 1). We define a temporary variable of type `StringLiteral` in line 2. Lines 3 and 4 then contain the if-else condition:  
`guess == luckyNumber` compares the values of guess and luckyNumber with `==`. It returns a Bool value: if the values guess and luckyNumber are equal, the expression is `True` and the first block is executed, else its value is `False`, and the else block runs.
`!=` is the inverse of `==`.

See `guess.mojo`:
```mojo
fn main():
    print(guessLuckyNumber(37)) # => True

fn guessLuckyNumber(guess: Int) -> Bool:    # 1
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

Just like in Python, this can be expanded with one or more elif branches:
```mojo
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

Also if statements can be nested inside each other.

## 5.2 Using for loops
The following program shows how to use a for in range-loop:
(see also previous exemples: String)

See `for_range.mojo`:
```mojo
def main():
    for x in range(9, 0, -3):   # 1
        print(x)

# =>
# 9
# 6
# 3
```

The loop in line 1 goes from start 9 to end 0, step -3. The end value 0 is not included, so a range(n) goes from 0 to n-1.

## 5.3 Using while loops
Just like in Python, you can make a loop with a condition through `while`:

See `while.mojo`:
```mojo
fn main():
    var n = 0
    while n <= 10_000_000:
        n += 1
    print(n) # => 10_000_001
```

## 5.4 Catching exceptions with try-except-finally
?? better example
?? better move to § 9.4

If your code is expected to possibly raise an exception, either the enveloping function must be postfixed with `raises`, or you can enclose the code like this:  
```mojo
    try:
        # possible dangerous code
    except:
        # what to do when an exception occurs
    finally:
        # optional: what to do in ant case, such as clean up resources.
```

For a concrete example, see `try_except.mojo` in § 6.2 

Enhanced example: see `try_except2.mojo`:
```mojo
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
If and error is thrown, the execution continue at the beginning of the Except: block just below
**Except e:**
Here it is possible to inspect the error e, based on that, we can fix it.
If fixed, the the execution continue on the first line after the except block.
If it is not possible to fix it, it is possible to Raise an error: either the same or another.
The error will be transfered to the next Except: block. 



## 5.5 The with statement
In Python the with statement is used to create a context. Whatever statements we execute inside that context does not affect the outer environment. The with statement simplifies exception handling by encapsulating common preparation and cleanup tasks. 
It is commonly used as `with open(file)` to read a file and close it automatically at the end of the context (see § 10.12).  

For example:
```mojo
with open("my_file.txt", "r") as file:
    print(file.read())

    # Other stuff happens here (whether using `file` or not)...
    foo()
    # `file` is alive up to the end of the `with` statement.

# `file` is destroyed when the statement ends.
bar()
```

For any value defined at the entrance to a with statement (like `file` here), Mojo will keep that value alive until the end of the with statement.

In Mojo it is used to create a parallelization context (no longer the same code!), for example in mandelbrot_4.mojo:
```mojo
from runtime.llcl import num_cores, Runtime

with Runtime() as rt:

        @parameter
        fn bench_parallel[simd_width: Int]():
            parallelize[worker](rt, height, height)

        let parallelized_ms = Benchmark().run[bench_parallel[simd_width]]() / 1e6
```

## 5.6 The walrus operator :=
The walrus operator now works in if/while statements without parentheses, e.g.:  
`if x := function():`

Example: ??

## 5.7 Exiting from a program
This will eventually be implemented. For now you can use this function:

See `exit.mojo`:
```mojo
fn main():
    print("before exit")  # => before exit
    _ = exit(-2)          # exit the program
    print("after exit")


fn exit(status: Int32) -> UInt8:
    return external_call["exit", UInt8, Int32](status)
```

with output:  
```
[Running] mojo tempCodeRunnerFile.mojo
before exit

[Done] exited with code=254 in 0.113 seconds
```

external_call is a function defined in module intrinsics.