# 11 – Decorators

`@adaptive`     see matmul
`@always_inline` see matmul
`@noncapturing`
`@parameter` if   : an if statement that runs at compile-time.
- `@register_passable` --> 11.2
`@staticmethod`
`@unroll`
- `@value` --> 11.1


## 11.1 - @value
The @value decorator makes defining simple aggregates of fields very easy.
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
@value generates a member-wise initializer, a move constructor, and(or) a copy constructor for you.

```py
@value
struct Coord:
    var x: Int
    var y: Int

fn main():
    let p = Coord(0, 0)
    print(p.y) # => 0
```

## 11.2 - @register_passable
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

The `@register_passable` decorator tells Mojo that the type should be copyable and movable but that it has no user-defined logic for doing this. It also tells Mojo to prefer to pass the value in CPU registers, which can lead to efficiency benefits.  
Small values like Int, Float, and SIMD are passed directly in machine registers instead of through an extra indirection.




