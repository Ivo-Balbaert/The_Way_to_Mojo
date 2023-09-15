# 5 Control flow

## 5.1 if else and Bool values

The general format follows the Python syntax: `if cond:  ... else:  ... `
Here is a first example of using the if-else flow in Mojo, using several numerical types and two functions:

See `if_else1.mojo`:
```py
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
```py
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

## 5.2 Using for loops
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

The loop in line 1 goes from start 9 to end 0, step -3. The end value 0 is not included.

## 5.3 Using while loops
Just like in Python, you can make a loop with a condition through `while`:

See `while.mojo`:
```py
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
```py
    try:
        # possible dangerous code
    except:
        # what to do when an exception occurs
    finally:
        # optional: what to do in ant case, such as clean up resources.
```

For a concrete example, see `try_except.mojo` in § 6.2 