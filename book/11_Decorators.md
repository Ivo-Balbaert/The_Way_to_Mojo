# 11 – Decorators

Decorators are a powerful feature in many programming languages that allow you to modify the behavior of a function, method, struct or class without changing its source code. This is known as *metaprogramming*, since a part of the program (the decorator) tries to modify another part of the program (for example: the struct or class) at compile time.

Mojo also uses decorators to modify the properties and behaviors of types (like structs) and functions.

Currently, the following decorators exist:  
`@adaptive`     see matmul
`@unroll`


## 11.1 - @value
The @value decorator makes defining simple aggregates of fields very easy; it synthesizes a lot of boilerplate code for you.
@value generates a member-wise initializer, a copy constructor and a move constructor.

You cannot make a struct instance without having defined an __init_ method. If you try, you get the error: `'Coord' does not implement any '__init__' methods in 'let' initializer`

See `value.mojo`:
```mojo
struct Coord:
    var x: Int
    var y: Int

fn main():
    let p = Coord(0, 0)  # error!
```

(https://mojodojo.dev/guides/decorators/value.html elaborates this further:
- implement __init__ --> let pair = Pair(5, 10) works
- let pair2 = pair doesn't work, error: not copyable
- implement __moveinit__ and __copyinit__
- now # Move object let pair2 = pair^ and # Copy object let pair3 = pair2 works
- but you can achieve the same by just using @value)

However, this is easily remedied by prefixing the struct with the `@value` decorator.

```mojo
@value
struct Coord:
    var x: Int
    var y: Int

fn main():
    let p = Coord(0, 0)
    print(p.y) # => 0
```

So if you write the following:  
```mojo
@value
struct MyPet:
    var name: String
    var age: Int
```

the compiler generates the following boilerplate code:

```mojo
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
```mojo
@value
struct Pet:
    var name: String
    var age: Int

fn main():
    # Creating a new pet
    let myCat = Pet("Wia", 6)
    print("Original cat name: ", myCat.name)
    print("Original cat age: ", myCat.age)
    # Copying a pet
    let copiedCat = Pet(myCat.name, 7)
    print("Copied cat name: ", copiedCat.name)
    print("Copied cat age: ", copiedCat.age)
    let movedCat = myCat
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

You can still write your own versions of these, while leaving the generated ones in place.


## 11.2 - @register_passable
A String contains a pointer that requires special constructor and destructor behavior to allocate and free memory, so it's memory only, it cannot be passed into registers.
A UInt32 is just 32 bits for the actual value and can be directly copied into and out of machine registers.
If you have a struct which contains only field values that can be passed into registers, mark the struct with @register_passable to enable this behavior for the whole struct, for example:

```mojo
@register_passable
struct Pair:
    var a: UInt32
    var b: UInt32
```

This decorator is used to specify that a struct can be passed in a register instead of passing through memory, which generates much more efficient code.

In § 3.11 we saw an example of a tuple that contains a struct instance.  
You can't get items from such a tuple however: 

```mojo
@value
struct Coord:
    var x: Int
    var y: Int

var x = (Coord(5, 10), 5.5)
print(x.get[0, Coord]())
```

This gives the compiler `error: invalid call to 'get': result cannot bind generic !mlirtype to memory-only type 'Coord'`
A memory-only type means it can't be passed through registers.

Marking the struct with the decorator `@register_passable` solves this:

See `register_passable.mojo`:
```mojo
@value
@register_passable
struct Coord:
    var x: Int
    var y: Int

var x = (Coord(5, 10), 5.5)
print(x.get[0, Coord]().x) # => 5
```

The `@register_passable("trivial")` decorator is a variant of @register_passable for trivial types like Int, Float, and SIMD.
Trivial means: it is always passed by copy/value.
Examples of trivial types:
* Arithmetic types such as Int, Bool, Float64 etc.
* Pointers (the address value is trivial, not the data being pointed to)
* Arrays of other trivial types including SIMD
* Struct types decorated with @register_passable("trivial"), that can only contain other trivial types:

It indicates that the type is register passable, so the value is passed in CPU registers instead of through normal memory, which needs an extra indirection. But it also says that the value is be copyable and movable, you can't define __init__, __copyinit__, __moveinit__ and __del__.  

>Note: mostly @value and @register_passable are used together.

For another example: see § 14.2

## 11.3 - @parameter if
`@parameter if` is an if statement that runs at compile-time.
Some examples:

You can use it to define a debug_only assert, as in lines 1 and 1B.  

See `parameter1.mojo`:
```mojo
from testing import assert_true

alias debug_mode = True  # 1


fn example():
    @parameter
    if debug_mode:     # 2
        print("debug")


fn main():
    @parameter
    if debug_mode:      # 1B
        _ = assert_true(1 == 2, "assertion failed")
    # => ASSERT ERROR: assertion failed

    example()  # => debug
```

The decorator is also used on nested functions that capture runtime values, creating "parametric" capturing closures (example matmul1.mojo § 20.3).
In line 2, only if true will the code will be "included" at compile time. The if statement will never run again during runtime.
See also § 7.9.6 (ctime_logic.mojo), § 10.6 (os_is_linux)

See `parameter3.mojo`:  (not yet fully understood)
```mojo
from testing import assert_true

fn example[T: AnyType](arg: T):
    @parameter
    if T == Float64:
        print("Float64")
        print(rebind[Float64](arg))

    @parameter
    if T == Int:
        print("Integer")
        print(rebind[Int](arg))    # 1


fn main():
    _ = example[Int]
    _ = example[AnyType]
```

`rebind` implements a type rebind. For example in line 1, it rebinds the value of arg to Int.

(?? Why is "Integer" not printed out? What is rebind?)


## 11.4 - @parameter 
**Using @parameter in a function**
See `parameter2.mojo`:
```mojo
fn add_print[a: Int, b: Int](): 
    @parameter
    fn add[a: Int, b: Int]() -> Int:
        return a + b

    let x = add[a, b]()
    print(x)

fn main():
    add_print[5, 10]()  # => 15
```

The above code will run at compile time, so that you pay no runtime price for anything inside the function. This translates at compile-time to:
```mojo
fn add_print(): 
    let x = 15
    print(x)

add_print()
```
The add calculation ran at compile time, so those extra instructions don't happen at runtime!

## 11.5 - @staticmethod
`@staticmethod` can be used:
* in a struct that cannot be instantiated, for an example see § 7.10.1
* to indicate that the following is a static method, to be called on the struct itself, not on an instance, example (see § 20.6 - `ray_tracing.mojo`):

```mojo
struct Vec3f:
    var data: SIMD[DType.float32, 4]

    ...
    @always_inline
    @staticmethod
    fn zero() -> Vec3f:
        return Vec3f(0, 0, 0)
```
The zero method is called as:  Vec3f.zero()


## 11.6 - @always_inline
Normally the compiler will do inlining automatically where it improves performance.
But you can force this behavior with @always_inline:
This decorator forces the compiler to always inline the decorated function, directly into the body of the calling function for the final binary.  

This improves the runtime performance by reducing function call overhead (eliminates jumping to a new point in code). The downside is that it can increase the binary size for the duplicated functions.

The version `@always_inline("nodebug")` works the same, but doesn't include debug information so you can't step into the function when debugging, but it will reduce debug build binary size.

See matmul

## 11.7 - @noncapturing
Marks a closure as not capturing variables from the outer scope. See § 6.5.1

## 11.8 - @unroll
Examples: see `nbody.mojo`:

```mojo
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