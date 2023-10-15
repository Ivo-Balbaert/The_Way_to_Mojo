# 9 - Other built-in types

## 9.1 The ListLiteral type
This is implemented in module `builtin_list` in package `builtin`.  
A list consists of zero or more values that can be of the same or different type (a heterogeneous list), separated by commas and enclosed in []. Because list items can be of any type, their type is effectively `AnyType`. The types can be explicitly specified, also between [].
The items are immutable, ListLiteral only includes getter methods for accessing them, nothing can be modified post-initialization.

When you initialize the list the types can be inferred (as shown in line 1) or explicitly specified (see line 2). However when retrieving an item with `get` you need to provide the item's index as well as the type as parameters (lines 2A,2B):

See `listliteral.mojo`:
```mojo
fn main():
    let list = [1,2,3]                   # 1
    print(list) # => [1, 2, 3]
    let explicit_list: ListLiteral[Int, Int, Int] = [1, 2, 3]   # 2
    print(explicit_list) # => [1, 2, 3]

    let list2 = [1, 5.0, "Mojo🔥"]
    print(list2.get[2, StringLiteral]())       # 2A => Mojo🔥
    let mixed_list: ListLiteral[Int, FloatLiteral, StringLiteral] 
            = [1, 5.0, "Mojo🔥"] 
    print(mixed_list.get[2, StringLiteral]())  # 2B => Mojo🔥

    print(len(mixed_list)) # => 3
    print(mixed_list.get[0, Int]()) # => 1
```

The `list` module, which is not built-in and is stored in package `utils`, provides methods for working with static and variadic (= a variable number of items) lists. 
variadic is written as `*T`, which is a variable number of values of type T. 
Examples:  
`fn f1[a: Int](*b: Int):`: this parametric function f1 has a variable number of arguments of type Int  
`fn f2[*a: Int](b: Int)`:  
this parametric function f2 has a variable number of parameters of type Int


**Implementing a List like behavior with PythonObject**
See `list_pythonobject.mojo`:
```mojo
fn main() raises:
    let x = PythonObject([])
    _ = x.append("hello")
    _ = x.append(1.1)
    let s: String = x[0].to_string()
    let f: Float64 = x[1].to_float64()
    print(x)  # => ['hello', 1.1]
```

## 9.2 The Tuple type
This is implemented in the built-in module `tuple`. 
>Note: There is also a static_tuple module in package utils, which defines the tpe `StaticTuple`, which is a statically sized tuple type contains elements of the same types

A tuple consists of zero or more, possibly heterogeneous values, separated by commas and enclosed in ().  
The `len` function returns the number of items.
The `get` method together with an index and a type allows you to extract the item at that index.

See `tuple.mojo`:
```mojo
@value
struct Coord:
    var x: Int
    var y: Int

fn main():
    let t1 = (1, 2, 3)          # type is inferred because of ()
    # let t1 = Tuple(1, 2, 3)  
    let tup = (42, "Mojo", 3.14)
    # let tup: Tuple[Int, StringLiteral, FloatLiteral] = (42, "Mojo", 3.14)
    print(tup.get[0, Int]())    # => 42
    print("Length of the tuple:", len(tup))   # => Length of the tuple: 3

    let x = (Coord(5, 10), 5.5)     # 4
    # Exercise:
    print(return_tuple().get[1, Int]())  # => 2
    
fn return_tuple() -> (Int, Int):    # 5
    return (1, 2)
```

A tuple can contain struct instances, as shown in line 4. In line 5, we see a function that returns a tuple.


## 9.3 The slice type
Slices are defined in the built-in module `builtin_slice`. They can be used to get substrings out of a string.
A slice expression follows the Python convention of [start:end:step] or with a call to slice(start,end,step).
If we don't specify a start, it will default to 0. We can initialize slices by specifying where it should stop. The step is the number of elements to skip between each element. If we don't specify a step, it will default to 1. 
So for example using Python syntax, you could write as in line 1:

See ``slice.mojo`:
```mojo
fn main():
    let original = String("MojoDojo")
    print(original[0:4])  # => Mojo
    print(original[0:8])  # => MojoDojo
    print(original[1:8:2])  # => oooo
    print(original[0:4:2])  # => Mj

    print(original[slice(0, 4)])      # => Mojo
    let slice_expression = slice(0, 4)
    print(original[slice_expression]) # => Mojo

    let x = String("slice it!")
    let a: slice = slice(5)
    let b: slice = slice(5, 9)
    let c: slice = slice(1, 4, 2)

    print(x[a])  # => slice
    print(x[b])  # =>  it!
    print(x[c])  # => lc    ```
```

[0:4] can also be written as slice(0,4). [1:8:2] as slice(1, 8, 2). This syntax is used in the last examples.


## 9.4 The Error type
The Error type (defined in built-in module `error`) is used to handle errors in Mojo.
Code can raise an error with the `Error` type, which accepts a String message. When `raise` is executed, "Error: error_message" is displayed:

See `error.mojo`:
```mojo
fn main() raises:
    print(return_error())

def return_error():
    raise Error("This signals an important error!")   # 1
    # => Error: This signals an important error!
```

After executing line 1, the execution stops because we didn't handle the exception with try-except. It gives the following output:
```
Unhandled exception caught during execution: This signals an important error!
mojo: error: execution exited with a non-zero result: 1
```
Errors can be initialized as empty, with custom messages, or even with string references:

```mojo
var err : Error = Error()
raise err

var custom_err : Error = Error("my custom error")
raise custom_err

var `ref` : StringRef = StringRef("hello")
var errref : Error = Error(`ref`)

raise errref
```

The `value` field is the error message itself (see line 1).

```mojo
var err2 : Error = Error("something is wrong")
print(err2.value) # 1 => something is wrong
```

An internal method __copyinit__ allows an error to be copied:

```mojo
var err3 : Error = Error("hey")
var other : Error = err3
raise other  # => Error: hey
```



