# 9 - Useful types from the standard library

## 9.1 Collection types
These include basic collection types like List, Dict, Set and Optional, with which you can build more complex data-structures.

Summarized:
* List: a dynamically-sized array of items.
* Dict: an associative array of key-value pairs.
* Set: an unordered collection of unique items.
* Optional: represents a value that may or may not be present.
* Variant: to hold different types of values

The collection types are *generic types*: while a given collection can only hold a specific type of value (such as Int or Float64), you specify the type at compile time using a parameter. For example, you can create a List of Int values like this: `var l = List[Int](1, 2, 3, 4)`
In this case, Mojo can infer the type, so you can write: `var l = List(1, 2, 3, 4)`

Let's start with the List types.

### 9.1.1 ListLiteral
This is implemented in module `builtin_list` in package `builtin`. 
It is literally a list of values (possibly of different type), separated by commas and enclosed in [].
The items can be of any type and are immutable: ListLiteral only includes getter methods for accessing them, nothing can be modified post-initialization.

When you initialize the list the types can be inferred (as shown in line 1) or explicitly specified (see line 2). However when retrieving an item with `get` you need to provide the item's index as well as the type as parameters (lines 2A,2B):

See `listliteral.mojo`:
```py
fn main():
    var list = [1,2,3]                   # 1
    print(list) # => [1, 2, 3]
    var explicit_list: ListLiteral[Int, Int, Int] = [1, 2, 3]   # 2
    print(explicit_list) # => [1, 2, 3]

    var list2 = [1, 5.0, "Mojo🔥"]
    print(list2.get[2, StringLiteral]())       # 2A => Mojo🔥
    var mixed_list: ListLiteral[Int, FloatLiteral, StringLiteral] 
            = [1, 5.0, "Mojo🔥"] 
    print(mixed_list.get[2, StringLiteral]())  # 2B => Mojo🔥

    print(len(mixed_list)) # => 3
    print(mixed_list.get[0, Int]()) # => 1
```

### 9.1.2 VariadicList
In § 6.4.1 we encountered the VariadicList type, which is typically used to take in the variable number of arguments *args in a variadic function. In other words: it provides a "list" view of the function arguments. Each of the arguments and the number of arguments are accessable.

### 9.1.3 DimList
The DimList type represents a list of dimensions. For example, the Tensor type uses it in the second argument of its definition: `struct Tensor[rank: Int, shape: DimList, type: DType]` 
Look at the complete programs with Tensors to see DimList used.

### 9.1.4 List
(see also § 4.3.1.1, 4.5.2, 7.9.2)
It lives in the `collections.list` module.

List is a dynamically-sized array of elements; it dynamically allocates memory in the heap to store elements, resizing when needed.  
List elements need to conform to the *CollectionElement* trait, which just means that the items must be copyable and movable. Most of the common standard library primitives, like Int, String, and SIMD conform to this trait.  
You can create a List *by passing the element type as a parameter*, like this:
`var l = List[String]()`

It supports appending and popping from the back, resizing the underlying storage to accommodate more elements as needed. 

See `list1.mojo`:
```py
fn main():
    var lst = List[Int](8)  # 1 - same as List(8)
    lst.append(10)  # 1A
    lst.append(20)
    print(len(lst))  # 2 => 3
    print(lst.size)  # => 3
    print(lst.capacity)  # 3 => 4

    for idx in range(len(lst)):  # 3B
        print(lst[idx], end=", ")  # => 8, 10, 20,
    print()
    print(lst[0])  # => 8
    lst[1] = 42  # 5
    print(lst[1])  # => 42
    lst[6] = 10  # 6 - no boundaries check!

    var lst2 = lst  # 7 - deep copy
    lst[0] = 99
    print(lst2[0])  # => 8
    for idx in range(len(lst)):
        print(lst[idx], end=", ")  # => 99, 42, 20,
    print()
    for idx in range(len(lst2)):
        print(lst2[idx], end=", ")  # => 8, 20, 20,
    print()

    print(lst.pop())  # 9 => 20
    print(len(lst))   # => 2
    for idx in range(len(lst)):
        print(lst[idx], end=", ")  # => 99, 42,
    print()

    lst.reserve(16)      # 10
    print(lst.capacity)  # => 16
    print("after reserving: ", lst.size)  # => 2
    lst.resize(10, 0)    # 11
    print("after resizing: ", lst.size)  # => 10

    lst.clear()      # 12
    print(lst.size)  # => 0
    print(len(lst))  # => 0
    print(lst[1])    # => 42  - former items are not cleared

    var list = List(1, 2, 4)
    for item in list:   # 13
        print(item[], end=", ")  # => 1, 2, 4, 
```

Adding elements to the back is done with the append method (line 1A), and `len` (line 2) gives the number of items, which is also given by the size field. 

The `capacity` is the memory already reserved for the list (in our example, in line 3, this is 4).  
Line 2B shows how to print out the items of a List in a for loop, the item at index idx is `lst[idx]`. Line 5 shows that we can also change an item through the index.  

Copying a List (line 7) will result in a deep copy. If we modify lst, then lst2 doesn't change with it.  
The inverse to append is the pop method, which will access the last element, deallocate it, and reduce the element size by 1 (see line 9).  

You can reserve memory to add elements without the cost of copying everything if it grows too large. 
The `reserve` method lets you change the capacity (line 10). If it's greater than the current capacity then data is reallocated and moved. If it's equal or smaller, nothing happens. 

The `resize` method discards elements if smaller than current size, or fills in the second argument as values if larger (line 11).
The `clear` method deallocates all items in the list and the size is set to 0 (the memory itself is not set to zeros).

If we do a for-loop over a List, we get References (see §  ) to the items, not the items themselves. To get the items, we can use the dereference operator `[]`.

*Try out* the insert and extend methods.
What happens when you try to print out a List?
*Try* to convert a ListLiteral to a List: `var list: List[Int] = [2, 3, 5]` ,what is the error?
Can a List contain elements of different types? 
*Try* to define a `var lst = List(1, 2, "a")` or List[AnyType]. Why do you get an error?



=============================================================================================
(see also §9 other builtin types and § 10)




Examples:  
`fn f1[a: Int](*b: Int):`: this parametric function f1 has a variable number of arguments of type Int  
`fn f2[*a: Int](b: Int)`:  
this parametric function f2 has a variable number of parameters of type Int


**Implementing a List like behavior with PythonObject** 
See `list_pythonobject.mojo`:
```py
fn main() raises:
   varx = PythonObject([])
    _ = x.append("hello")
    _ = x.append(1.1)
   vars: String = x[0]  # x[0].__str__()
   varf: Float64 = x[1].to_float64()
    print(x)  # => ['hello', 1.1]
```

(See also DimList from buffer.list, VariadicList from builtin_list.)





## 9.2 The Tuple type
This is implemented in the built-in module `tuple`. 
>Note: There is also a static_tuple module in package utils, which defines the tpe `StaticTuple`, which is a statically sized tuple type containing elements of the **same types**

A tuple consists of zero or more, possibly heterogeneous values, separated by commas and enclosed in ().  
The `len` function returns the number of items.
The `get` method together with an index and a type allows you to extract the item at that index.

See `tuple.mojo`:
```py
@value
struct Coord:
    var x: Int
    var y: Int

fn main():
   vart1 = (1, 2, 3)          # type is inferred because of ()
    #vart1 = Tuple(1, 2, 3)  
   vartup = (42, "Mojo", 3.14)
    #vartup: Tuple[Int, StringLiteral, FloatLiteral] = (42, "Mojo", 3.14)
    print(tup.get[0, Int]())    # => 42
    print("Length of the tuple:", len(tup))   # => Length of the tuple: 3

   varx = (Coord(5, 10), 5.5)     # 4
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
```py
fn main():
   varoriginal = String("MojoDojo")
    print(original[0:4])  # => Mojo
    print(original[0:8])  # => MojoDojo
    print(original[1:8:2])  # => oooo
    print(original[0:4:2])  # => Mj

    print(original[slice(0, 4)])      # => Mojo
   varslice_expression = slice(0, 4)
    print(original[slice_expression]) # => Mojo

   varx = String("slice it!")
   vara: slice = slice(5)
   varb: slice = slice(5, 9)
   varc: slice = slice(1, 4, 2)

    print(x[a])  # => slice
    print(x[b])  # =>  it!
    print(x[c])  # => lc    ```
```

[0:4] can also be written as slice(0,4). [1:8:2] as slice(1, 8, 2). This syntax is used in the last examples.


## 9.4 The Error type
The Error type (defined in built-in module `error`) is used to handle errors in Mojo.
Code can raise an error with the `Error` type, which accepts a String message. When `raise` is executed, "Error: error_message" is displayed:

See `error.mojo`:
```py
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

```py
var err : Error = Error()
raise err

var custom_err : Error = Error("my custom error")
raise custom_err

var `ref` : StringRef = StringRef("hello")
var errref : Error = Error(`ref`)

raise errref
```

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



