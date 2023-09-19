# 6 Functions

A key trick in Mojo is that you can opt in at any time to a faster 'mode' as a developer, by using `fn` instead of `def` to create your function. In this mode, you have to declare exactly what the type of every variable is, and as a result Mojo can create optimized machine code to implement your function.

## 6.1 Difference between fn and def
`def` is defined by necessity to be very dynamic, flexible and generally compatible with Python: arguments are mutable, local variables are implicitly declared on first use, and scoping isn’t enforced. This is great for high level programming and scripting, but is not always great for systems programming.  
To complement this, Mojo provides an `fn` declaration which is like a "strict mode" for def.

`fn`'s have a number of limitations compared to def functions:
* Argument values default to being immutable in the body of the function (like a let), instead of mutable (like a var). This catches accidental mutations, and permits the use of non-copyable types as arguments.
* Argument values require a type specification (except for self in a method), catching accidental omission of type specifications. Similarly, a missing return type specifier is interpreted as returning `None` instead of an unknown return type. Note that both can be explicitly declared to return `object`, which allows one to opt-in to the behavior of a def if desired.
* Implicit declaration of local variables is disabled, so all locals must be declared. This catches name typos with the scoping provided by let and var.
* Both support raising exceptions, but this must be explicitly declared on an fn with the `raises` keyword.

## 6.2  A fn that calls a def needs a try/except
Consider the following example: 

See `try_except.mojo`:
```mojo
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
```mojo
fn main() raises:
    _ = func1(2, 3)
```

or

```mojo
fn main():
    try:
        _ = func1(2, 3)
    except:  
        print("error")
```

## 6.3 Function arguments and return type
Functions declared as `fn` in Mojo must specify the types of their arguments. If a value is returned, its type must be specified after a `->` symbol and before the body of the function.

Here is a function that returns a Float32 value:
```mojo
fn func() -> Float32:     
    return 3.14
```

This is illustrated in the `sum` function in the following example (see line 1), which returns an Int value:  
See `sum.mojo`:
```mojo
fn sum(x: Int, y: Int) -> Int:  # 1
    return x + y

fn main():
    _ = sum(1, 2).
    let z = sum(1, 2)
    print(z)    # => 3
```

Change `let z = sum(1, 2)` to just `sum(1, 2)`. Now you don't use the return value of a function, so you get a  `warning: 'Int' value is unused`.
You can print out the return value, or just discard the value with _ = sum(1, 2). `_ =` is called the *discard pattern*, and can be used for just that, to indicate that you receive the returned value, but that you don't want to use it.

If a function has no return value (example ??), you could write this as `-> None`. In normal cases you can leave this out, and the compiler will understand this. But if you need to write the function type (as in higher order functions), writing `-> None` is needed.

By default, a function cannot modify its arguments values. They are immutable (read-only) references. 

Try it out: make x change in sum.
You are stopped by the following compiler errors:
    x = 42        # => expression must be mutable in assignment
    var x = 42    # => invalid redefinition of 'x'


## 6.4 Argument passing: control and memory ownership

### 6.4.1 General rules for def and fn arguments
* All values passed into a `Python def` function use *reference semantics*. This means the function can modify mutable objects passed into it and those changes are visible outside the function. 

* All values passed into a `Mojo def` function use *value semantics* by default. Compared to Python, this is an important difference: a Mojo def function receives a copy of all arguments. So it can modify arguments inside the function, but the changes are not visible outside the function.
A def argument without an explicit type annotation defaults to object.

* All values passed into a `Mojo fn` function are *immutable (read-only)references* by default. This means it is not a copy and the function can read the original object, but it cannot modify the object at all: this is called *borrowing*.
The default argument convention for fn functions is *borrowed*. You can make this explicit by prefixing the argument's names with the word `borrowed`:  

```mojo
fn sum(borrowed x: Int, borrowed y: Int) -> Int:  
    return x + y
```
(See also § 7.6)

But what if we want a function to be able to change its arguments?

### 6.4.2 Making arguments changeable with inout 
For a function's arguments to be mutable, you need to declare them as *inout*. This means that changes made to the arguments inside the function are visible outside the function.  
This is illustrated in the following example:  

See `inout.mojo`:
```mojo
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

See also § 7.8, where inout is used with struct arguments.

This behavior is a potential source of bugs, that's why Mojo forces you to be explicit about it with the keyword *inout*.

### 6.4.2 Making arguments owned
An even stronger option is to declare an argument as *owned*. Then the function gets full ownership of the value, so that it’s mutable, but also guaranteed unique. This means the function can modify the value and not worry about affecting variables outside the function.  
For example:  

See `owned.mojo`:
```mojo
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
```mojo
let b = set_fire(a^)   # this doesn't make a copy
print(a)               # => error: use of uninitialized value 'a'
```

we get the error: use of uninitialized value 'a'
because the transfer operator effectively destroys the variable a, so when the following print() function tries to use a, that variable isn’t initialized anymore.
If you delete or comment out print(a), then it works fine.

See also § 7.8 for an example with a struct.

>Note: Currently (Aug 17 2023), Mojo always makes a copy when a function returns a value.

## 6.5 Closures
Mojo considers closures capturing by default, even if it's not capturing anything. Capturing means that if there were any variables in context, the closure would know their values, in the example in § 6.5.1 there are no variables to be captured.

## 6.5.1 Example of a closure
The following example shows an example of a nested (or inner) function in line 1. This is also called a *clojure*. The outer function that calls the closure in line 3 has as argument the function type of the closure:  
`f: fn() capturing -> None` 
So the inner function must conform to this type. 
Here -> None is required, as well as the keyword capturing.

See `closure1.mojo`:
```mojo
fn outer(f: fn() capturing -> None):   # 2
    f()                                # 3

fn call_it():
    fn inner():             # 1
        print("inner")

    outer(inner) 

fn main():
    call_it()  # => inner
```

>Note: If you forget the capturing keyword, you get the error:
```
closure1.mojo:8:10: error: invalid call to 'outer': argument #0 cannot be converted from 'fn() capturing -> None' to 'fn() -> None'
    outer(inner) 
    ~~~~~^~~~~~~
closure1.mojo:1:1: note: function declared here
fn outer(f: fn() -> None):   # 2
^
```

Because here inner is not really capturing any variables, you can leave out the capturing keyword by decorating the function with @noncapturing (see lines 2B and 3B).

See `closure1.mojo`:
```mojo
fn outer(f: fn() -> None):   # 2B
    f()                      # 3

fn call_it():
    @noncapturing           # 3B
    fn inner():             # 1
        print("inner")

    outer(inner) 

fn main():
    call_it()  # => inner
```

## 6.5.2 Example of a capturing closure
See `closure2.mojo`:
```mojo
fn outer(f: fn() capturing -> Int):
    print(f())

fn call_it():
    let a = 5               # 1
    fn inner() -> Int:      # 2  
        return a

    outer(inner) 

fn main():
    call_it()  # => 5
```
You can see that we captured the a variable (line 1) in the inner closure (line 2) and returned it to the outer function. Note that the closure has the function type: `f: fn() capturing -> Int`.

The keyword capturing is necessary.