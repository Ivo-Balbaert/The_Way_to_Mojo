# 11 – Decorators

Decorators are a powerful feature in many programming languages that allow you to modify the behavior of a function, method, struct or class without changing its source code. This is known as metaprogramming, since a part of the program (the decorator) tries to modify another part of the program §the struct or class) at compile time.

Mojo also uses decorators to modify the properties and behaviors of types (like structs) and functions.

Currently, the following decorators exist:  
`@adaptive`     see matmul
`@always_inline` see matmul
`@noncapturing`
* `@register_passable` --> 11.2
`@unroll`
* `@value` --> 11.1

## 11.1 - @value
The @value decorator makes defining simple aggregates of fields very easy; it synthesizes a lot of boilerplate code for you.
You cannot make a struct instance without having defined an __init_ method. If you try, you get the error: `'Coord' does not implement any '__init__' methods in 'let' initializer`

See `value.mojo`:
```py
struct Coord:
    var x: Int
    var y: Int

fn main():
    let p = Coord(0, 0)  # error!
```

However, this is easily remedied by prefixing the struct with the `@value` decorator.
@value generates a member-wise initializer, a move constructor, and(or ??) a copy constructor for you.

```py
@value
struct Coord:
    var x: Int
    var y: Int

fn main():
    let p = Coord(0, 0)
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

You can still write your own versions of these, while leaving the generated ones in place.


## 11.2 - @register_passable
This decorator is used to specify that a struct can be passed in a register instead of passing through memory, which generates much more efficient code.

In § 3.11 we saw an example of a tuple that contains a struct instance.  
You can't get items from such a tuple however: 

```py
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
```py
@value
@register_passable
struct Coord:
    var x: Int
    var y: Int

var x = (Coord(5, 10), 5.5)
print(x.get[0, Coord]().x) # => 5
```

The `@register_passable("trivial")` decorator is a variant of @register_passable for trivial types like like Int, Float, and SIMD. It indicates that the type is register passable, so the value is passed in CPU registers instead of through normal memory, which needs an extra indirection. But it also says that the value is be copyable and movable, although it has no user-defined copy/move/destroy logic.  

## 11.3 - @parameter if
`@parameter` if is an if statement that runs at compile-time.
Some examples:

You can use it to define a debug_only assert.  
See `parameter1.mojo`:
```py
from testing import assert_true

fn main():
    alias my_debug_build = 1  # Set it to 0 for production
    @parameter
    if my_debug_build == 1:
        _ = assert_true(1==2, "assertion failed")
    # => ASSERT ERROR: assertion failed
```

see § 7.9.6 (ctime_logic.mojo).

## 11.4 - @staticmethod
`@staticmethod` can (only ??) be used in a struct that cannot be instantiated, for an example see § 7.10.1

