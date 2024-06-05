# 6 Functions

As we've seen, in Mojo you can both use `def` or `fn` functions, unlike in Python. Choose the one which you think is best for the project at hand.

A key trick in Mojo is that you can opt in at any time to a faster and safer 'mode' as a developer, by using `fn` instead of `def` to create your function. In the `fn` mode Mojo can create optimized machine code to implement your function.

A handy way to build up your code is to first write only the function signatures. Write the ellipsis constant `...` in the empty function bodies, and you already get a nice compileable overview of your program.

> Try it out: write a program with a function that has only `pass` in its body, and call that function.

## 6.1 Difference between fn and def
`def` is defined to be very dynamic, flexible and generally compatible with Python: arguments are copied and mutable, local variables are implicitly declared on first use, and scoping isn't enforced. The default argument type is `object` (see § 4.5), representing a particular Mojo type designed for dynamic code.

Example:
```py
def calc(a, b):
    return (a + b) * (a - b)
```

In this code, the types of `a` and `b` are `object`, as is the return type.
This is great for high level programming and scripting, but is not always great for systems programming.  

Mojo additionally provides an `fn` declaration, which is like a "strict mode" for def.
With fn, explicit specification of argument types (except for the `self` argument in struct methods, see § 7), parameters, and the return value is mandatory.
Also arguments are so-called `borrowed`, they are *immutable references*. This means that argument values by default cannot be changed in the body of the function. 
>Note: In § 6.4 some more detail on function arguments is given.

Example:
```py
fn calc(a: Int, b: Int) -> Int:
    return (a + b) * (a - b)
```

We see here that the argument type of `a` and `b`, and the return type are both restricted to `Int`.
If the value of `a` or `b` would not fit that type, `fn` would give an error at compile-time, `def` would crash the running program!


" This is called a type annotation. This declaration says that the function argument text will contain only String literals. More importantly, it will never contain any other content than String literals. This gives the Mojo compiler a very important hint. Without such a hint, the Mojo compiler has to accommodate many different scenarios. For example, if we do not declare that the text is of type StringLiteral, it will have to assume that the text may contain numbers or other types of objects. Then it has to generate a very generic executable code that is able to handle many other types of values. However, when we tell Mojo compiler that the text will take only StringLiterals, it can generate a very specific and highly optimized code that handles only StringLiterals.

Similarly, a missing return type specifier is interpreted as returning `None` (instead of an unknown return type). `None` means there the function has no return value.  

>Note that both can be explicitly declared to return `object`, which allows one to opt-in to the behavior of a def if desired.

Both `def` and `fn` support raising exceptions, but this must be explicitly declared on an fn with the `raises` keyword, as shown in the following section.

Benefits of fn over def:
    - produce highly performant code
    - to enforce program correctness, to enhance program safety and robustness

Benefits of def over fn:
    - to prototype something and you are not sure what types to use, you can leave that decision for a later time and focus on the algorithm itself
    - when you really need the flexibility and dynamism of Python



## 6.2  An fn that calls a def needs the raises keyword
Consider the following example: 

See `try_except.mojo`:
```py
def func1(a, b):
    var c = a
    if c != b:
        var d = b
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

Because def functions are more dynamic and not so strictly controlled, there is a greater chance that an exception will occur inside them. The notes suggest how to fix this:  
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

*Exercise:*
Write a complete program with a main() function, and call both the def and the fn functions from § 6.1. Experiment with the types of the arguments a and b (see exc6.1.mojo)


## 6.3 Function arguments and return type
### 6.3.1 Function type
Functions declared as `fn` must specify the types of their arguments. If a value is returned, its type must be specified after a `->` symbol and before the body of the function.

Here is a function that returns a Float32 value:
```py
fn func() -> Float32:     
    return 3.14
```

This is illustrated in the `sum` function in the following example , which returns an Int value (see line 1):  
See `sum.mojo`:
```py
fn sum(x: Int, y: Int) -> Int:  # 1
    return x + y

fn main():
    _ = sum(1, 2).
    var z = sum(1, 2)
    print(z)    # => 3
```

x and y are called *positional-only arguments*. This means that when calling the function, the order in which values are passed matters: x gets the value 1 and y the value 2. 
Change `var z = sum(1, 2)` to just `sum(1, 2)`. Now you don't use the return value of a function, so you get a  `warning: 'Int' value is unused`.
You can print out the return value, or just discard the value with _ = sum(1, 2). `_ =` is called the *discard pattern*, and can be used for just that, to indicate that you receive the returned value, but that you don't want to use it.
> Note: Assigning a value to the _ discard variable tells the compiler that this is the last use of that value, so it can be destroyed immediately.

>Note: You can force Mojo to keep a value alive up to a certain point by assigning the value to the _ "discard" pattern at the point where it's okay to destroy it (see https://docs.modular.com/mojo/manual/lifecycle/death.html)

If a function has no return value (example !!), you could write this as `-> None`. In normal cases you can leave this out. But if you need to write the function type (as in higher order functions), writing `-> None` is needed.

By default, a function cannot modify its arguments values. They are immutable (read-only) references. 

Try it out: make x change in sum.
You are stopped by the following compiler errors:
    x = 42        # => expression must be mutable in assignment
    var x = 42    # => invalid redefinition of 'x'

The *function type* of a function is its *signature*, that is: the argument-list and the return type.
Example: function sum from owned.mojo:
`fn sum(owned a: Int8, owned b: Int8) -> Int8:`
function type: `(owned a: Int8, owned b: Int8) -> Int8`

### 6.3.2 Optional arguments
(synonym: default arguments)
You can give arguments a default value, in case it doesn't get a value when the function is called, in other words: when the argument is *optional* (see line 1). 
In the following example, the argument `exp` has a default value 2 (line 1), so it is optional when the function `pow` is called. For example line 2, only a value for base is given.

See `optional_args.mojo`:
```py
fn pow(base: Int, exp: Int = 2) -> Int:    # 1
    return base ** exp

fn main():
    var z = pow(3) # 2 # Uses the default value for `exp`, which is 2
    print(z) # => 9
```

>Note: An inout argument cannot have a default value.
>Note: Optional arguments must come after any required arguments.

### 6.3.3 Keyword arguments
When a function takes a lot of arguments, the code that calls the function is much more readable if the name of the argument is specified. 
So you pass the argument explicitly with an assignment using its name as in lines 2 and 3:
`message = "Mojo"`.
These are called *keyword arguments* (or named arguments), and they are specified using the format *argument_name = argument_value*. 

See `keyword_args.mojo`:
```py
fn greet(times: Int = 1, message: String = "!!!"):  # 1
    for i in range(times):
        print("Hello " + message)


fn main():
    greet()                    # => Hello !!!
    greet(message = "Mojo")    # 2 => Hello Mojo
    greet(times = 2)           # 3 => Hello !!! 
                               # => Hello !!!
```
You can pass keyword arguments in any order, as showin in line 2 of the following example:
See `keyword_args2.mojo`:
```py
fn pow(base: Int, exp: Int = 2) -> Int:    # 1
    return base ** exp

fn main():
    var z = pow(exp=3, base=2) # 2 # Uses keyword argument names (with order reversed)
    print(z) # => 8
```

Keyword arguments make APIs ergonomic, as the programmer does not have to remember in which position what value need to be passed. It improves code readability and maintainability. It also reduces accidental mistakes when programmer wrongly assumes the order of the arguments.

### 6.3.4 Positional-only arguments
Sometimes you want to write a function with positional-only arguments, because:
* The argument names aren't meaningful for the the caller.
* You want the freedom to change the argument names later on without breaking backward compatibility.

You can indicate that all arguments in the argument list are positional-only by separating them with a `/` from possible other arguments. For example:

```py
fn min(a: Int, b: Int, /) -> Int:
    return a if a < b else b
```    

This min() function can be called with min(1, 2) but can't be called using keywords, like min(a=1, b=2). So the arguments that come before the / cannot be called as keyword arguments!

**Before the / you can only use positional arguments.**

After the /, you can use arguments like `third` as keyword arguments or as positional arguments:
> Try out this code (see `position_keyword.mojo`):
```py
fn func1(first: Int, second: Int, /, third: Int) -> Int:
    return first + second + third


fn main():
    print(func1(1, 2, third=3))  # => 6
    print(func1(1, 2, 3))  # => 6
    # print(func1(first=1, 2, 3))  # error: positional argument follows keyword argument
```


### 6.3.5 Keyword-only arguments
Keyword-only arguments can only be specified by keyword. They often have default values, but if not, the argument is required.

**After the `*` you can only use keyword-only arguments.**

See `keyword_only.mojo`:
```py
fn kw_only_args(a1: Int, a2: Int, *, double: Bool = True) -> Int:
    var product = a1 * a2
    if double:
        return product * 2
    else:
        return product

fn main():
    print(kw_only_args(2, 3))                       # => 12
    # print(kw_only_args(2, 3, False))                # error: invalid call to 'kw_only_args': expected at most 2 positional arguments, got 3
    print(kw_only_args(a1=2, a2=3))                 # => 12
    print(kw_only_args(a1=2, a2=3, double = False)) # => 6
```

What happens if double doesn't have a default value? 

## 6.4 Functions with a variable number of arguments.
### 6.4.1 Using variadic arguments
You can pass a variable number of values if you prefix an argument with a *, like in the following example (see line 1):

See `variadic.mojo`:   
```py
fn sum(*values: Int) -> Int:   # 1
  var sum: Int = 0
  for value in values:
    sum = sum + value
  return sum

fn main():
    print(sum(1,2,3))  # => 6
    print(sum(1,2,3,4,5,6,7))  # => 28
    print(sum(1))  # => 1
    print(sum())   # => 0
```

We can call sum with any number of integers.

*args_w in the function my_func is also a variadic parameter:

See `variadic1.mojo`:   print out doesn't work anymore (2023 Nov 5), removed from test_way
```py
fn my_func(*args_w: String):  # 1
    for i in args_w:
        print(i[]) 
    # var args = VariadicList(args_w)
    # for i in range(len(args)):
    #     pass
    #     # print(args[i])   # error: no matching value in call to print
        # print(args.__getitem__(i))   # error: no matching value in call to print
        
fn main():
    my_func("hello", "world", "from", "Mojo!")

# =>
# hello
# world
# from
# Mojo!
```

You can define zero or more arguments before the variadic argument.  
The variadic argument then takes in any remaining values in the function call.
If you want to declare arguments after the variadic argument (probably not a good idea), they must be specified by keyword.

### 6.4.2 Homogeneous variadic arguments
*Homogeneous* means that all of the passed arguments are the same type, for example all Int, or all String.

Register-passable types, such as Int, are available as a VariadicList. As shown in the previous example `variadic.mojo`, you can iterate over the values using a for..in loop.

Memory-only types, such as String, are available as a VariadicListMem. Iterating over this list directly with a for..in loop currently produces a Reference for each value instead of the value itself. You must add an empty subscript operator [] to dereference the reference and retrieve the value (see line 1):

See `variadic_string.mojo`:   
```py
def make_worldly(inout *strs: String):
    for i in strs:
        i[] += " world"  # 1 # Requires extra [] to dereference the reference for now.

fn make_worldly2(inout *strs: String):
    # This "just works" as you'd expect!
    for i in range(len(strs)):  # 2
        strs[i] += " world"
    
fn main() raises:
    var s1: String = "hello"
    var s2: String = "konnichiwa"
    var s3: String = "bonjour"
    # make_worldly(s1, s2)
    make_worldly2(s1, s2, s3)
    print(s1)  # => hello world
    print(s2)  # => konnichiwa world
    print(s3)  # => bonjour world
```

Subscripting into a VariadicListMem, as in line 2, returns the argument value, and doesn't require any dereferencing:

### 6.4.3 Heterogeneous variadic arguments
*Heterogeneous* means that the passed arguments are of different types.
`def count_many_things[*ArgTypes: Intable](*args: *ArgTypes):`

See https://docs.modular.com/mojo/manual/functions#heterogeneous-variadic-arguments

### 6.4.4 Variadic keyword arguments
The syntax is `**kwargs`. This allows the user to pass an arbitrary number of keyword arguments.
Tis variadic argument is a dictionary (see §§).

See `variadic_kwargs.mojo`:   
```py
fn print_nicely(**kwargs: Int) raises:
    for key in kwargs.keys():
        print(key[], "=", kwargs[key[]])

fn main() raises:
    print_nicely(a=7, y=8)

# =>
# a = 7
# y = 8
```

### 6.4.5 Variadic argument followed by a keyword argument
Keyword-only arguments are necessary in the following case, where the first argument is variadic:
`fn sort(*values: Float64, ascending: Bool = True): ...`
the user can pass any number of Float64 values, optionally followed by the keyword argument ascending . For example: ``var a = sort(1.1, 6.5, 4.3, ascending=False)`.
If a function accepts variadic arguments, any arguments defined after the variadic arguments are treated as keyword-only.



## 6.5 Argument passing: control and memory ownership
There are three keywords to modify how arguments are passed to functions:

borrowed : immutable reference, which is the default
inout : mutable reference, it means any changes to the value *in*side the function are also visible *out*side the function.
owned : object given to the function, used with a deference operator ^ at the function call.

### 6.5.1 General rules for def and fn arguments
* All values passed into a `Python def` function use *reference semantics*. This means the function can modify mutable objects passed into it and those changes are visible outside the function. 

* All values passed into a `Mojo def` function use *value semantics* by default. Compared to Python, this is an important difference: a Mojo def function receives a copy of all arguments. So it can modify arguments inside the function, but the changes are not visible outside the function.
A def argument without an explicit type annotation defaults to object.

* All values passed into a `Mojo fn` function are *immutable (read-only)references* by default. This means it is not a copy and the function can read the original object, but it cannot modify the object at all: this is called *borrowing*.
The default argument convention for fn functions is *borrowed*. You can make this explicit by prefixing the argument's names with the word `borrowed`:  

```py
fn sum(borrowed x: Int, borrowed y: Int) -> Int:  
    return x + y
```
(See also § 7.6)

But what if we want a function to be able to change its arguments?

### 6.5.2 Making arguments changeable with inout 
For a function's arguments to be mutable, you need to declare them as *inout*. This means that changes made to the arguments inside the function are visible outside the function (**in**side - **out**side).  
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

See also § 7.8, where inout is used with struct arguments.

This behavior is a potential source of bugs, that's why Mojo forces you to be explicit about it with the keyword *inout*.

### 6.5.3 Making arguments owned
An even stronger option is to declare an argument as *owned*. Then the function gets full ownership of the value, so that it's mutable inside the function, but also guaranteed unique. This means the function can modify the value and not worry about affecting variables outside the function.  
For example:  

See `owned.mojo`:
```py
fn mojo():
    var a: String = "mojo"
    var b = set_fire(a)
    print(a)        # => "mojo"
    print(b)        # => "mojo🔥"

fn set_fire(owned text: String) -> String:   # 1
    text += "🔥"
    return text

fn main():
    mojo()
```

Our variable to be owned is of type `String` (see § 4.5.2). 
`set_fire` takes ownership of variable a in line 1 as argument `text`, which it changes and returns.  
From the output, we see that the return value b has the changed value, while the original value of a still exists. Mojo made a copy of a to pass this as the text argument.
(Better example by giving the parameters the same name as the argument !!)


### 6.5.4 Making arguments owned and transferred with ^
If however you want to give the function ownership of the value and do NOT want to make a copy (which can be an expensive operation for some types), then you can add the *transfer* operator `^` when you pass variable a to the function.  

>Note: to type a ^ on a NLD(Dutch) Belgian keyboard, tap 2x on the key right to the P-key.

The transfer operator effectively destroys the local variable name - any attempt to call it later causes a compiler error.  
The ^ operator *ends the lifetime of a value binding* and transfers the value ownership to something else.

If you change in the example above the call to set_fire() to look like this:

See `owned_transfer.mojo`:
```py
let b = set_fire(a^)   # this doesn't make a copy
print(a)               # => error: use of uninitialized value 'a'
```

we get the error: use of uninitialized value 'a'
because the transfer operator effectively destroys the variable a, so when the following print() function tries to use a, that variable isn't initialized anymore.
If you delete or comment out print(a), then it works fine.

Simpler example:
```py
fn main():
    var counter = 0
    counter += 1
    print('counter is', counter)

    # the line below should not be changed
    var new_counter = counter^
    print('new_counter is ', new_counter)
    # counter += 1 # => error: use of uninitialized value 'counter'
    new_counter += 1
    print('new_counter is', new_counter)
```
See also § 7.8 for an example with a struct.


**Summary of the different ways arguments can be passed:**
See `inout.mojo`:
```py
fn sum(inout a: Int8, inout b: Int8) -> Int8:
    # with inout the values can be changed
    a = 3
    b = 2
    return a + b

fn main():
    var a: Int8 = 4
    var b: Int8 = 5

    # inout: values can be changed inside, and the changes are visible outside
    print(sum(a, b))  # => 5
    print(a, b)       # => 3 2
```

See `borrowed.mojo`:
```py
fn sum(borrowed a: Int8, borrowed b: Int8) -> Int8:
    # a = 3 # error: expression must be mutable in assignment
    return a + b

# same as:
# fn sum_borrowed(a: Int8, b: Int8) -> Int8:
#     return a + b

fn main():
    var a: Int8 = 4
    var b: Int8 = 5

    # borrowed: the values are used in computations, but they cannot be changed
    print(sum(a, b))  # => 9
    print(a, b)       # => 4 5
```

See `owned.mojo`:
```py
fn sum(owned a: Int8, owned b: Int8) -> Int8:
    a = 3
    b = 2
    return a + b

fn main():
    var a: Int8 = 4
    var b: Int8 = 5

    # owned: the functions 'owns' these variables, so it can change them, but the original
    # values remain unchanged
    print(sum(a, b))     # => 5 
    # if a and b would be declared with let, you would get error: uninitialized variable 'a'
    print(a, b)          # => 4 5
```

!! change example because of mojo warning:
See `owned_transfer.mojo`:
```py
fn sum(owned a: Int8, owned b: Int8) -> Int8:
    a = 3
    b = 2
    return a + b


fn main():
    var a: Int8 = 4
    var b: Int8 = 5

    # owned: the functions 'owns' these variables, so it can change them, but the original
    # values are no longer there, they are moved by the transfer operator
    #  warning: transfer from a value of trivial register type 'SIMD[int8, 1]' has no effect and can be removed
    print(sum(a^, b^))  # => 5
    # print(a, b)  # => error: use of uninitialized value 'a', error: use of uninitialized value 'b'
```

## 6.6 Overloading functions
Like in Python, you can define def functions in Mojo without specifying argument data types and Mojo will handle them dynamically. This is nice when you want expressive APIs that just work by accepting arbitrary inputs and let *dynamic dispatch* decide how to handle the data.

However, when you want to ensure type safety, Mojo also offers full support for overloaded functions, a feature that does not exist in Python.  
This allows you to define multiple functions with the same name but with different arguments. This is a common feature called *overloading*, as seen in many languages, such as C++, Java, and Swift. 
fn functions must specify argument types, so if you want a function to work with different data types, you need to implement separate versions of the function that each specify different argument types. 

Overloading a function occurs when two or more functions have the same name, but different argument (or parameter) lists, so a different signature. The result type doesn't matter.  

!! example when two overloading functions have same signature

*How does the compiler choose which of the overloaded function versions will be chosen?* 
The Mojo compiler selects the version that most closely matches the argument types:  
When resolving a function call, Mojo tries each candidate and uses the one that works (if only one works), or it picks the closest match (if it can determine a close match), or it reports that the call is ambiguous if it can't figure out which one to pick. In the latter case, you can resolve the ambiguity by adding an explicit cast on the call site.  

Overloading has no meaning for def functions without argument types.
In the following program the two versions of add are an example of overloading:

See `overloading_functions.mojo`:
```py
fn add(x: Int, y: Int) -> Int:              # 1
    return x + y

fn add(x: String, y: String) -> String:    # 2
    return x + y

fn main():
    print(add(1, 2)) # => 3
    print(add("Hi ", "Suzy!")) # => Hi Suzy!
    print(add(1, "Hi")) # 3 => 1Hi
    print(add(False, "Hi")) # 4 => FalseHi
```

Why does version #2 work, because "Hi" and "Suzy!" are of type StringLiteral, not String?
It works because StringLiteral can be implicitly casted to String. String includes an overloaded version of its constructor (__init__()) that accepts a StringLiteral value. Thus, you can also pass a StringLiteral to a function that expects a String. This works in general when the given type can be implicitly casted to the required type. That's why lines 3 and 4 also work.

!! What happens when two


*How does resolving an overloaded function call works?*
The Mojo compiler tries each candidate function and uses the one that works (if only one version works), or it picks the closest match (if it can determine a close match), or it reports that the call is ambiguous (if it can’t figure out which one to pick).
For example:

See `overloading_functions2.mojo`:
```py
```

The call in line 3 is ambiguous because the two `foo` functions 1 and 2 match it. We get the error: ambiguous call to 'foo', each candidate requires 1 implicit conversion, disambiguate with an explicit cast.
We can follow up on this error to corect it in lines 4 or 5.

>Note: Overloading also works with combinations of both fn and def functions.

>Remark: If a function needs to work with many types, defining all these versions can be a lot of work. A better solution is to work with a *generic* or *parametric* type, see § !!

>Note: you can also overload functions based on parameter types.


## 6.7 Running functions at compile-time and run-time
As we saw in § 3.7, there are two times of execution: compile-time and runtime.
Mojo has two 'spaces', the 'parameter' space (which operates during compile time) and the 'value' space (which operates during run time). Mojo functions can do computations in both spaces, the `[]` accepts arguments for the 'parameter' space, and `()` accepts arguments for the 'value' space:

See `compile_time1.mojo`:
```py
fn repeat[count: Int](msg: String):
    for i in range(count):
        print(msg)

fn main():
     repeat[3]("Hello")
    # => Hello
    # Hello
    # Hello
```

count is a compile-time parameter which becomes a run-time constant. The compiler makes a specific version of `repeat` with the count value set to 3, which is executed when running.

The following section shows that `alias` can do much more than just defining a constant value or type at compile-time.

## 6.7B Running a function at compile-time with alias
By using alias for the return variable, you can run a function at compile-time, to do a calculation or build a data structure.

See `compile_time2.mojo`:
```py
alias n_numbers = 5
alias precalculated = squared(n_numbers)     # 1
alias MY_VALUE = add(2, 3)                   # 1B
alias QUOTE = ord('"')                       # 1C

fn squared(n: Int) -> Pointer[Int]:
    var tmp = Pointer[Int].alloc(n)
    for i in range(n):
        tmp.store(i, i * i)
    return tmp

fn add(a: Int, b: Int) -> Int:
    return a + b

fn main():
    # var precalculated = squared(n_numbers) # 2
    for i in range(n_numbers):
        print(precalculated.load(i))

    print(MY_VALUE) # => 5
    print(QUOTE) # => 34
 

# =>
# 0
# 1
# 4
# 9
# 16
# 5
# 34
```

The function squared can be used both during compile-time and runtime. The alias in line 1 takes care that the calculation is done at compile-time. It returns a pointer with pre-calculated values during compilation and makes it usable at runtime. 
If we comment this line and uncomment line 2, precalculated is computed at runtime. The result is stored as an alias constant (here MY_VALUE) in the executable file. This means that when the program is run, it just takes the alias constant, saving valuable CPU-time during the execution.

The same reasoning applies for line 1B.
In line 1C, we use an alias in order to use the ord function efficiently (it doesn't have to run at run-time anymore).  

Not every function can be run at compile-time however. In order to be able to do that, the function must be:  
* a fn type function
* the function must be a *pure function*. Such functions have no side effects. That is, the functions must use only the arguments passed to it and must not change any variables or state outside of the function body. 

A parameter enclosed in [] is a compile-time (or static) value (1).
An argument enclosed in () is a run-time (or dynamic) value (2).
If you get the error: `cannot use a dynamic value in a type parameter`, Mojo says that you used a runtime value as a compile-time parameter (case (1)).

## 6.8A Nested functions
Functions in Mojo can be 'nested' inside another function, as shown shere:
See `nested.mojo`:
```py
fn outer():
    fn nested():
        print("I am nested")

    nested()


fn main():
    outer()  # => I am nested
```

The inner function (called `nested` here) can only be called from the outer function in which it is nested. So it is like a helper function for the outer function only.

## 6.8B Closures
*Capturing* means that if there were any variables in context, the closure would know their values. Closures capture by default, even if it's not capturing anything. 
In the following example there are no variables to be captured.

### 6.8B.1 Example of a closure
The following snippet shows an example of a nested function in line 1. Here it is also called a *clojure*. The `outer` function that calls the closure in line 3 has as argument the function type of the closure:  
`f: fn() -> None` 
So the `inner` function must conform to this type. 

See `closure1.mojo`:
```py
fn outer(f: fn() -> None):   # 2    # Here -> None is required.
    f()                      # 3

fn call_it():
    fn inner():             # 1
        print("inner")

    outer(inner) 

fn main():
    call_it()  # => inner
```

### 6.8B.2 Example of a capturing closure
See `closure2.mojo`:
```py
fn outer(f: fn() escaping -> Int):   # 3
    print(f())

fn call_it():
    var a = 5             # 1
    fn inner() -> Int:    # 2  
        return a          # inner captures the context variable a

    outer(inner) 

fn main():
    call_it()  # => 5
```
You can see that we captured the a variable (line 1) in the inner closure (line 2) and returned it to the outer function. Note that the closure has the function type: `f: fn() escaping -> Int`.

The keyword `escaping` is necessary in line 3.


## 6.9 Callbacks through parameters
See `callbacks_params.mojo`:
(!! why is file used in the example)
```py
@value
struct Markdown:
    var content: String

    fn __init__(inout self):
        self.content = ""

    def render_page[f: def() -> object](self, file="none"):
        f()

    fn __ior__(inout self, t: String):
        self.content += t

var md = Markdown()

def readme():
    md |= '''
    # hello mojo
    this is markdown
    ```py
    fn main():
        print("ok")
    ```
    '''
    footer()

def footer():
    md |= '''
    > Page generated
    '''

def main():
    md.render_page[readme](file = "README.md")  # 1
    print(md.content)

# =>
# hello mojo
    # this is markdown
    # ```py
    # fn main():
    #     print("ok")
    # ```
    
    # > Page generated
```

This program generates markdown as an instance of struct Markdown.
In line 1, the Markdown method render_page is called with the compile-time parameter readme, which is itself a function of type def. 



A function can also be *recursive* (see Fibonacci example § 10.5)


## 6.10 Using pass and ...
At the start of this chapter, we mentioned the ellipsis constant `...` to represent an empty function body. It is mostly for defining empty methods in traits (see § 13), but it can also be used in functions. `...` is a placeholder: within a function, it just means that the body is not yet implemented and the Mojo compiler will not complain about the missing body.
Also, for the same purpose, the keyword `pass`is used, which represents a valid but empty function body. It tells the compiler that the implementation has been omitted.
They are both demoed in the following snippet:

See `pass_ellipsis.mojo`:
```py
fn test():
    pass


fn test1():
    ...


fn main():
    test()
    test1()
    print("Nothing happened!")  # => Nothing happened!
```

> The pass or `...` can also be written immediately after the : of the dunction signature, saving you one line.

When would you use pass and when `...`? A good thumb rule is to use pass where you know that there is no need for an implementation and use `...`​ when you are expecting some implementation in the future.




**Exercises**
1- Write a function is_palindrome that checks whether a word is a palindrome (like "otto" or "ava") (see `palindrome.mojo`).