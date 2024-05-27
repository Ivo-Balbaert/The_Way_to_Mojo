# 15 – Decorators
Decorators are a powerful feature in many programming languages (Python, C#, ...) that allow you to modify the behavior of a function, method, struct or class without changing its source code. This is known as *metaprogramming*, since a part of the program (the decorator) tries to modify another part of the program (for example: the struct or class) at compile time.

Mojo also uses decorators to modify the properties and behaviors of types (like structs) and functions.

There is a difference between `signature decorators` (like @value) and `body decorators` (like @register_passable):
If used like this:  
```py
@register_passable
@value
struct Coord:
```

you get the error: signature decorator cannot come after body decorator.

This is ok:
```py
@value
@register_passable
struct Coord:
```

Currently, the following decorators exist:  
`@export`       a function annotated with this decorator can be called from a C program
(see § 25) 


## 15.1 - @value
The @value decorator makes defining simple aggregates of fields very easy. Using it produces a lot of boilerplate code for you: @value generates a member-wise initializer (__init__), a copy constructor (__copyinit__) and a move constructor (__moveinit__). These allow you to construct, copy, and move your struct type in a manner that's value semantic and compatible with Mojo's ownership model.

>Note: @value only creates these methods if they are not yet present. You can still write your own versions of these methods, while leaving the generated ones in place.

You cannot make a struct instance without having defined an __init_ method. If you try, you get the error: `'Coord' does not implement any '__init__' methods in 'var' initializer`

See `value.mojo`:
```py
struct Coord:
    var x: Int
    var y: Int

fn main():
   var p = Coord(0, 0)  # error!
```

(https://mojodojo.dev/guides/decorators/value.html elaborates this further:
- implement __init__ --> var pair = Pair(5, 10) works
- var pair2 = pair doesn't work, error: not copyable
- implement __moveinit__ and __copyinit__
- now # Move objectvarpair2 = pair^ and # Copy objectvarpair3 = pair2 works
- but you can achieve the same by just using @value)

However, this is easily remedied by prefixing the struct with the `@value` decorator.

```py
@value
struct Coord:
    var x: Int
    var y: Int

fn main():
    var p = Coord(0, 0)
    print(p.y) # => 0
```

So if you write the following:  
```py
@value
struct MyPet:
    var name: String
    var age: Int
```

the compiler generates the following boilerplate code:

```py
struct MyPet:
    var name: String
    var age: Int

    fn __init__(inout self, owned name: String, age: Int):
        self.name = name^
        self.age = age

    fn __copyinit__(inout self, existing: Self):
        self.name = existing.name
        self.age = existing.age

    fn __moveinit__(inout self, owned existing: Self):
        self.name = existing.name^
        self.age = existing.age
```

Here is a complete example with the Pet struct:
See `value2.mojo`:
```py
@value
struct Pet:
    var name: String
    var age: Int

fn main():
    # Creating a new pet
    var myCat = Pet("Wia", 6)
    print("Original cat name: ", myCat.name)
    print("Original cat age: ", myCat.age)
    # Copying a pet
    var copiedCat = Pet(myCat.name, 7)
    print("Copied cat name: ", copiedCat.name)
    print("Copied cat age: ", copiedCat.age)
    var movedCat = myCat^
    print("Moved cat name: ", movedCat.name)
    print("Moved cat age: ", movedCat.age)
# =>
# Original cat name:  Wia
# Original cat age:  6
# Copied cat name:  Wia
# Copied cat age:  7
# Moved cat name:  Wia
# Moved cat age:  6
```

## 15.2 - @register_passable
(See § 4.8.1)
A String contains a pointer that requires special constructor and destructor behavior to allocate and free memory, so it's memory only, it cannot be passed into registers.
A UInt32 is just 32 bits for the actual value and can be directly copied into and out of machine registers.
If you have a struct which contains only field values that can be passed into registers, mark the struct with @register_passable to enable this behavior for the whole struct, for example:

```py
@register_passable
struct Pair:
    var a: UInt32
    var b: UInt32
```

This decorator is used to specify that a struct can be passed in a register instead of passing through memory, which generates much more efficient code.

Here (line 1) is an example of a tuple that contains a struct instance.  
You can't get items from such a tuple however: 

```py
@value
struct Coord:
    var x: Int
    var y: Int

var x = (Coord(5, 10), 5.5)  # 1
print(x.get[0, Coord]())
```

This gives the compiler `error: invalid call to 'get': result cannot bind generic !mlirtype to memory-only type 'Coord'`
A memory-only type means it can't be passed through registers.

Marking the struct with the decorator `@register_passable` solves this:

See `register_passable.mojo`:
```py
@value
@register_passable
struct Coord:
    var x: Int
    var y: Int

var x = (Coord(5, 10), 5.5)
print(x.get[0, Coord]().x) # => 5
```

The `@register_passable("trivial")` decorator is a variant of @register_passable for trivial types

>Note: mostly @register_passable are @value are used together.

For another example: see § 14.2

## 15.3 - @parameter if
`@parameter if` is an if statement that runs at compile-time.
Some examples:

You can use it to define a debug_only assert, as in lines 1 and 1B.  

See `parameter1.mojo`:
```py
from testing import assert_true

alias debug_mode = True  # 1


fn example():
    @parameter
    if debug_mode:     # 2
        print("debug")


fn main() raises:
    @parameter
    if debug_mode:      # 1B
        _ = assert_true(1 == 2, "assertion failed")
    # => ASSERT ERROR: assertion failed

    example()  # => debug
```

In line 2, only if true will the code will be "included" at compile time. The if statement will never run again during runtime.
See also § 7.9.5 (ctime_logic.mojo), § 10.6 (os_is_linux)



## 15.4 - @parameter
### 15.4.1 Closure
This decorator is also used on nested functions that capture runtime values, creating "parametric" capturing closures.
Examples: 
* § 23, where @parameter is used together with vectorize, see vectorize1.mojo
* § 24, where @parameter is used together with parallelize
* matmul.mojo § 30.3

### 15.4.2 Running a function at compile-time
@parameter can also run a function at compile-time, as shown here:
See `parameter2.mojo`:
```py
fn add_print[a: Int, b: Int](): 
    @parameter
    fn add[a: Int, b: Int]() -> Int:
        return a + b

    var x = add[a, b]()
    print(x)

fn main():
    add_print[5, 10]()  # => 15
```

The above code will run at compile time, so that you pay no runtime price for anything inside the function. The add calculation ran at compile time, so those extra instructions don't happen at runtime!
This translates at compile-time to:
```py
fn add_print(): 
    var x = 15
    print(x)

fn main():
    add_print()
```

## 15.5 - @staticmethod
`@staticmethod` can be used:
* in a struct that cannot be instantiated, for an example see § 7.10.1
* to indicate that the following is a static method, to be called on the struct itself, not on an instance, keeping the scope clean. The struct acts as a namespace.

Here is a simple example:
See `static_method1.mojo`
```py
struct Helpers:
    @staticmethod
    fn is_even(value: Int) -> Bool:
        return (value & 1) == 0

fn main():
    var x = 2
    print(Helpers.is_even(x))   # => True
```

Example (see § 20.6 - `ray_tracing.mojo`):
```py
struct Vec3f:
    var data: SIMD[DType.float32, 4]

    ...
    @always_inline
    @staticmethod
    fn zero() -> Vec3f:
        return Vec3f(0, 0, 0)
```
The zero method is called as:  Vec3f.zero()


## 15.6 - @always_inline
(!! Explain what is "inlining")
Normally the compiler will do inlining automatically where it improves performance.
But you can force this behavior with @always_inline:
This decorator forces the compiler to always inline the decorated function, directly into the body of the calling function for the final binary, avoiding function call overhead.  

This improves the runtime performance by reducing function call overhead (it eliminates jumping to a new point in code). The downside is that it can increase the binary size for the duplicated functions.

The version `@always_inline("nodebug")` works the same, but doesn't include debug information so you can't step into the function when debugging, but it will reduce debug build binary size.

Example: see § 11.3 / § 15.7
See matmul

## 15.7 - @unroll
See `unroll1.mojo`:
```py
@always_inline
fn print_and_increment(inout x: Int):
    print(x)
    x += 1

fn main():
    var i = 0
    @unroll
    while i < 3:
        print_and_increment(i)

# =>
# 0
# 1
# 2
```

After working out the decorators, this becomes:
```py
fn main():
    var i = 0
    print(i)
    i+=1
    print(i)
    i+=1
    print(i)
    i+=1
```

The program is faster by not doing `if i < 3` on each iteration and by not having to jump into print_and_increment. It also becomes bigger, but the point is that this is a choice.

Examples: see `nbody.mojo`:

```py
    @unroll
    for i in range(NUM_BODIES):
        p += bodies[i].velocity * bodies[i].mass
        ...

    @unroll
    for i in range(NUM_BODIES):
        for j in range(NUM_BODIES - i - 1):
            var body_i = bodies[i]
            var body_j = bodies[j + i + 1]
            ...
```