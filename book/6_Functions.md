# 6 Functions

A key trick in Mojo is that you can opt in at any time to a faster 'mode' as a developer, by using `fn` instead of `def` to create your function. In this mode, you have to declare exactly what the type of every variable is, and as a result Mojo can create optimized machine code to implement your function.

## 6.1 Difference between fn and def
`def` is defined by necessity to be very dynamic, flexible and generally compatible with Python: arguments are mutable, local variables are implicitly declared on first use, and scoping isn’t enforced. This is great for high level programming and scripting, but is not always great for systems programming.  
To complement this, Mojo provides an `fn` declaration which is like a "strict mode" for def.

`fn`'s have a number of limitations compared to def functions:
* Argument values default to being immutable in the body of the function (like a let), instead of mutable (like a var). This catches accidental mutations, and permits the use of non-copyable types as arguments.
* Argument values require a type specification (except for self in a method), catching accidental omission of type specifications. Similarly, a missing return type specifier is interpreted as returning `None` instead of an unknown return type. Note that both can be explicitly declared to return `object`, which allows one to opt-in to the behavior of a def if desired.
* Implicit declaration of local variables is disabled, so all locals must be declared. This catches name typos with the scoping provided by let and var.
* Both support raising exceptions, but this must be explicitly declared on a fn with the `raises` keyword.

## 6.2  A fn that calls a def needs a try/except
Consider the following example:

See `try_except.mojo`:
```py
def func1(a, b):
    let c = a
    if c != b:
        let d = b
        print(d)  # => 3

fn main():
    func1(2, 3)
```

This gives you an error when compiling: 
```
error: cannot call function that may raise in a context that cannot raise
    func1(2, 3)
    ~~~~~^~~~~~
```

Apparently Mojo thinks that calling a def function can give an exception. Through some notes we get some suggestions to fix this:  
```
note: try surrounding the call in a 'try' block
note: or mark surrounding function as 'raises'
```

So one of the following two forms solves this:
```py
fn main() raises:
    _ = func1(2, 3)
```

or

```py
fn main():
    try:
        _ = func1(2, 3)
    except:  
        print("error")
```

## 6.3 Function arguments and return type
Functions declared as `fn` in Mojo must specify the types of their arguments. If a value is returned, its type must be specified after a `->` symbol and before the body of the function.

Here is a function that returns a Float32 value:
```py
fn func() -> Float32:     
    return 3.14
```

This is illustrated in the `sum` function in the following example (see line 1), which returns an Int value:  
See `sum.mojo`:
```py
fn sum(x: Int, y: Int) -> Int:  # 1
    return x + y

fn main():
    let z = sum(1, 2)
    print(z)    # => 3
```

Change `let z = sum(1, 2)` to just `sum(1, 2)`. Now you don't use the return value of a function, so you get a  `warning: 'Int' value is unused`.
You can print out the return value, or just discard the value with _ = sum(1, 2).

By default, a function cannot modify its arguments values. They are immutable (read-only) references. 

Try it out: make x change in sum.
You are stopped by the following compiler errors:
    x = 42        # => expression must be mutable in assignment
    var x = 42    # => invalid redefinition of 'x'


## 6.4 Argument passing control and memory ownership

### 6.4.1 General rules for def and fn arguments
* All values passed into a `Python def` function use reference semantics. This means the function can modify mutable objects passed into it and those changes are visible outside the function. 
* All values passed into a `Mojo def` function use value semantics by default. Compared to Python, this is an important difference: a Mojo def function receives a copy of all arguments. So it can modify arguments inside the function, but the changes are not visible outside the function.
* All values passed into a `Mojo fn` function are immutable references by default. This means it is not a copy and the function can read the original object, but it cannot modify the object at all: this is called *borrowing*.
The default argument convention for fn functions is *borrowed*. You can make this explicit by prefixing the argument's names with the word `borrowed`:  

```py
fn sum(borrowed x: Int, borrowed y: Int) -> Int:  
    return x + y
```

But what if we want a function to be able to change its arguments?

### 6.4.2 Making arguments changeable with inout 
For a function's arguments to be mutable, you need to declare them as *inout*. This means that changes made to the arguments inside the function are visible outside the function.  
This is illustrated in the following example:  

See `inout.mojo`:
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

This behavior is a potential source of bugs, that's why Mojo forces you to be explicit about it with the keyword *inout*.

### 6.4.2 Making arguments owned
An even stronger option is to declare an argument as *owned*. Then the function gets full ownership of the value, so that it’s mutable, but also guaranteed unique. This means the function can modify the value and not worry about affecting variables outside the function.  
For example:  

See `owned.mojo`:
```py
fn mojo():
    let a: String = "mojo"
    let b = set_fire(a)
    print(a)        # => "mojo"
    print(b)        # => "mojo🔥"

fn set_fire(owned text: String) -> String:   # 1
    text += "🔥"
    return text

fn main():
    mojo()
```

Our variable to be owned is of type `String`. This type and its methods(??) are defined in module string, which is built-in.   
`set_fire` takes ownership of variable a in line 1 as argument `text`, which it changes and returns.  
From the output, we see that the return value b has the changed value, while the original value of a still exists. Mojo made a copy of a to pass this as the text argument.


### 6.4.3 Making arguments owned and transferred with ^
If however you want to give the function ownership of the value and do NOT want to make a copy (which can be an expensive operation for some types), then you can add the *transfer* operator `^` when you pass variable a to the function.  
The transfer operator effectively destroys the local variable name - any attempt to call it later causes a compiler error.  
The ^ operator ends the lifetime of a value binding and transfers the value ownership to something else.

If you change in the example above the call to set_fire() to look like this:

See `owned_transfer.mojo`:
```py
let b = set_fire(a^)   # this doesn't make a copy
print(a)               # => error: use of uninitialized value 'a'
```

we get the error: use of uninitialized value 'a'
because the transfer operator effectively destroys the variable a, so when the following print() function tries to use a, that variable isn’t initialized anymore.
If you delete or comment out print(a), then it works fine.

>Note: Currently (Aug 17 2023), Mojo always makes a copy when a function returns a value.
