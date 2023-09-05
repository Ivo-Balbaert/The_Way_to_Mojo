# 9 - Other builtin types

## 9.1 The ListLiteral type
This is implemented in module `BuiltinList`.  
A list consists of zero or more possibly heterogeneous values, separated by commas and enclosed in []. Because list items can be of any type, their type is `AnyType`. The types can be explicitly specified, also between [].
The items are immutable, it only includes getter methods for accessing them, nothing can be modified post-initialization.

When you initialize the list the types can be inferred (as shown in line 1), however when retrieving an item with `get` you need to provide the item's index as well as the type as parameters (lines 2A,2B):

See `listliteral.mojo`:
```py
    let list: ListLiteral[Int, FloatLiteral, StringLiteral] = [1, 5.0, "Mojo🔥"]  # 1
    print(list.get[2, StringLiteral]())  # 2A => Mojo🔥

    # much simpler:
    let list2 = [1, 5.0, "Mojo🔥"]
    print(list2.get[2, StringLiteral]())  # 2B => Mojo🔥
```

`storage` is the MLIR type that stores the literals (!pop.pack<[!kgen.declref<_"$Builtin"::_"$Int"::_Int>, !kgen.declref<_"$Builtin"::_"$FloatLiteral"::_FloatLiteral>, !kgen.declref<_"$Builtin"::_"$String"::_String>]>)


The `List` module, which is not built-in, provides methods for working with static and variadic lists.

## 3.11 The Tuple type
This is implemented in the built-in module `Tuple`.  
A tuple consists of zero or more, possibly heterogeneous (of different type) values, separated by commas and enclosed in ().  
The len function returns the number of items.
The get method together with an index and a type allows you to extract the item at that index.

See `tuple.mojo`:
```py
    @value
    struct Coord:
        var x: Int
        var y: Int


fn main():
    let t1 = (1, 2, 3)
    # let t1 = Tuple(1, 2, 3)  # type is inferred because of ()
    let tup = (42, "Mojo", 3.14)
    # let tup: Tuple[Int, StringLiteral, FloatLiteral] = (42, "Mojo", 3)
    print(tup.get[0, Int]())    # => 42
    print("Length of the tuple:", len(tup))   # => 3

    var x = (Coord(5, 10), 5.5) # 4
    # Exercise:
    print(return_tuple().get[1, Int]())  # => 2
    
fn return_tuple() -> (Int, Int):
    return (1, 2)
```

    A tuple can contain struct instances, as shown in line 4.

## 3.12 The Slice type
Slices are defined in the built-in module `BuiltinSlice`. They are the way to get substrings out of a string, or ?? sublists out of Lists.
A slice expression follows the Python convention of [start:end:step].
If we don't specify a start, it will default to 0. We can initialize slices by specifying where it should stop. The step is the number of elements to skip between each element. If we don't specify a step, it will default to 1. 
So for example using Python syntax, you could write as in line 1:

See ``slice.mojo`:
```py
    from String import String

    let original = String("MojoDojo")
    print(original[0:4])  # => Mojo
    print(original[0:8])  # => MojoDojo
    print(original[1:8:2])  # => oooo
    print(original[0:4:2])  # => Mj

    print(original[slice(0, 4)])      # => Mojo
    let slice_expression = slice(0, 4)
    print(original[slice_expression]) # => Mojo
```

[0:4] can also be written as slice(0,4). [1:8:2] as slice(1, 8, 2). This syntax is used in the bottom examples:

```py
    print(original[slice(0, 4)])      # => Mojo
    let slice_expression = slice(0, 4)
    print(original[slice_expression]) # => Mojo

    var x = String("slice it!")
    var a : slice = slice(5)
    var b : slice = slice(5, 9)
    var c : slice = slice(1, 4, 2)

    print(x[a])  # => slice
    print(x[b])  # =>  it!
    print(x[c])  # => lc
```

## 3.13 The Error type
The Error type (defined in built-in module Error) is used to handle errors in Mojo.
Code can raise an error with the `Error` type, which accepts a String message. When raise is executed, "Error: error_message" is displayed:

See `error.mojo`:
```py
fn main():
    return_error()

def return_error():
    raise Error("This returns an Error type") 
    # => Error: This returns an Error type
```

Errors can be initialized as empty, with custom messages, or even with string references:

```py
var err : Error = Error()
raise err

var custom_err : Error = Error("my custom error")
raise custom_err

var `ref` : StringRef = StringRef("hello")
var errref : Error = Error(`ref`)

raise errref
```

If the program still contains code after raising the error, you get the: `warning: unreachable code after raise statement`

The `value` field is the error message itself (see line 1).

```py
var err2 : Error = Error("something is wrong")
print(err2.value) # 1 => something is wrong
```

An internal method __copyinit__ allows an error to be copied:

```py
var err3 : Error = Error("hey")
var other : Error = err3
raise other  # => Error: hey
```
