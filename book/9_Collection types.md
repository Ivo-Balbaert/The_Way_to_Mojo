# 9 - Collection types
These include basic collection types like List, Dict, Set and Optional, with which you can build more complex data-structures. They are stored in the `collections` package.

The collection types are *generic types*: while a given collection can only hold a specific type of value (such as Int or Float64), you specify the type at compile time using a parameter. For example, you can create a List of Int values like this: `var l = List[Int](1, 2, 3, 4)`
In this case, Mojo can infer the type, so you can write: `var l = List(1, 2, 3, 4)`

Let's start with the List types.

## 9.1 List
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
In § 6.4.1 we encountered the VariadicList type, which is typically used to take in the variable number of arguments *args in a variadic function. It is stored in the same module as ListLiteral. In other words: it provides a "list" view of the function arguments. Each of the arguments and the number of arguments are accessable.

### 9.1.3 DimList
The DimList type represents a list of dimensions. It is imported with: 
`from buffer.list import DimList`.  
For example, the Tensor type uses it in the second argument of its definition: `struct Tensor[rank: Int, shape: DimList, type: DType]` 
Look at the complete programs with Tensors to see DimList used.

### 9.1.4 List
(see also § 4.3.1.1, 4.5.2, 7.9.2)
This is really the most useful list-like type. It lives in the `collections.list` module.

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

    var inputs = List(1.2, 5.1, 2.1)
    var weights = List(3.1, 2.1, 8.7)
    var bias = 3
    var output = inputs[0]*weights[0] + inputs[1]*weights[1] + inputs[2]*weights[2] + bias
    print(output) # => 35.699999999999996
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

### 9.1.5 Implementing a list-like behavior with PythonObject
This snippet shows how we could use a PythonObject to create a list, just for fun (or mihjt there be some use-cases !!):

See `list_pythonobject.mojo`:
```py
fn main() raises:
    var x = PythonObject([])
    x.append("hello")
    x.append(1.1)
    var s = x[0]          # same as x[0].__str__()
    var f = x[1].to_float64()  # var f: Float64 = ...
    print(x)  # => ['hello', 1.1]
```


### 9.1.6  Sorting a List
The sort module in package algorithms implements different sorting functions. Here is an example of usage:  

See `sorting1.mojo`:
```py
from algorithm.sort import sort

fn main():
    var v = List[Int](108)   # 108 is the first item in the List

    v.push_back(20)
    v.push_back(10)
    v.push_back(70)

    sort(v)

    for i in range(v.size):
        print(v[i])
# =>
# 10
# 20
# 70
# 108
```

This function sort the list in-place.


## 9.2 Dict
The Dict type is an associative array that holds key-value pairs, also called dictionary or map in other languages. Create an empty Dict by specifying the key and value type in that order as parameters:
`var dict = Dict[String, Float64]()`

The keys must implement the KeyElement trait, and the values conform to the CollectionElement trait.

See `dict.mojo`:
```py
from collections import Dict

fn main() raises:
    var d = Dict[String, Float64]()
    d["plasticity"] = 3.1                   # 1
    d["elasticity"] = 1.3
    d["electricity"] = 9.7
    for item in d.items():
        print(item[].key, item[].value)     # 2
    # =>
    # plasticity 3.1000000000000001
    # elasticity 1.3
    # electricity 9.6999999999999993

    var d1 = Dict[String, Int]()
    d1["a"] = 1
    d1["b"] = 2
    print(len(d1))      # => 2
    print(d1["a"])      # => 1
    print(d1.pop("b"))  # => 2
    print(len(d1))      # => 1
```

It also has a __contains__, find and update method.


## 9.3 Set
This type represent a set of *unique* values. You can add and remove elements from the set, test whether a value exists in the set, and perform set algebra operations, like unions and intersections between two sets.

Sets are generic and the element type must conform to the KeyElement trait.

See `set.mojo`:
```py
from collections import Set

fn main():
    var i_like = Set("sushi", "ice cream", "tacos", "pho")
    var you_like = Set("burgers", "tacos", "salad", "ice cream")
    var we_like = i_like.intersection(you_like)

    print("We both like:")
    for item in we_like:
        print("-", item[])
    # We both like:
    # - ice cream
    # - tacos
```

## 9.4 Optional
This type represents a value that may or may not be present. In the last case, it has value `None`.
Like the other collection types, it is generic, and can hold any type that conforms to the CollectionElement trait.

See `optional.mojo`:
```py
from collections import Optional


fn main():
    # Two ways to initialize an Optional with a value
    var opt1 = Optional(5)  # 1
    var opt2: Optional[Int] = 5
    # Two ways to initalize an Optional with no value
    var opt3 = Optional[Int]()
    var opt4: Optional[Int] = None

    var opt: Optional[String] = str("Testing")
    if opt:  # 2
        var value_ref = opt.value()
        print(value_ref[])  # => Testing

    var custom_greeting: Optional[String] = None
    print(custom_greeting.or_else("Hello"))  # => Hello

    custom_greeting = str("Hi")
    print(custom_greeting.or_else("Hello"))  # => Hi
```

An Optional evaluates as True when it holds a value, False otherwise. If the Optional holds a value, you can retrieve a reference to the value using the `value()` method. But calling value() on an Optional with no value results in undefined behavior, so you should always guard a call to value() inside a conditional that checks whether a value exists, as done in line 2.  
An alternative is the or_else() method, which returns the stored value if there is one, or a user-specified default value otherwise (see line 3).

## 9.5 Tuple 
This is implemented in the built-in module `tuple`. 
A tuple consists of zero or more, possibly heterogeneous values, separated by commas and enclosed in ().  

>Note: There is also a static_tuple module in package utils, which defines the tpe `StaticTuple`, which is a statically sized tuple type containing elements of the **same types**. It is imported with: `from utils import StaticTuple`.

The `len` function returns the number of items.
The `get` method together with an index and a type allows you to extract the item at that index.

See `tuple.mojo`:
```py
@value
struct Coord:
    var x: Int
    var y: Int

fn main():
    var t1 = (1, 2, 3)          # type is inferred because of (), same as: var t1 = Tuple(1, 2, 3)  
    var tup = (42, "Mojo", 3.14)
    # same as: var tup: Tuple[Int, StringLiteral, FloatLiteral] = (42, "Mojo", 3.14)
    print(tup.get[0, Int]())    # => 42
    print("Length of the tuple:", len(tup))   # => Length of the tuple: 3

    var x = (Coord(5, 10), 5.5)     # 4
    print(return_tuple().get[1, Int]())  # => 2
    
fn return_tuple() -> (Int, Int):    # 5
    return (1, 2)
```

A tuple can contain struct instances, as shown in line 4. In line 5, we see a function that returns a tuple.

## 9.6 Variant 
This type is used to implement a run-time sum (variant) types. It is imported with `from utils import Variant`.
The following code shows some of its possibilities:

See `variant.mojo`:
```py
from utils import Variant

alias IntOrString = Variant[Int, String]   # 1

fn to_string(inout x: IntOrString) -> String:
    if x.isa[String]():                    # 2
        return x.get[String]()[]
    # x.isa[Int]()
    return x.get[Int]()[]

fn print_value(value: Variant[Int, Float64], end: StringLiteral) -> None:
    if value.isa[Int]():
        print(value.get[Int]()[], end=end)
    else:
        print(value.get[Float64]()[], end=end)

fn main():
    # They have to be mutable for now, and implement CollectionElement
    var an_int = IntOrString(4)
    var a_string = IntOrString(String("I'm a string!"))
    var who_knows = IntOrString(0)
    import random
    if random.random_ui64(0, 1):
        who_knows.set[String]("I'm actually a string too!")

    print(to_string(an_int))    # => 4
    print(to_string(a_string))  # => I'm a string!
    print(to_string(who_knows)) # => 0

    var a = List[Variant[Int, Float64]](1, 2.5, 3, 4.5, 5) # 2A
    var b = List[Variant[Int, StringLiteral]](1, "Hi", 3, "Hello", 5)   # 2B
    print("List(", end="")
    for i in range(len(a) - 1):
        print_value(a[i], ", ")
    print_value(a[-1], "")
    print(")") # => List(1, 2.5, 3, 4.5, 5)
```

A variant type is defined in line 1.  
Lines 2A-B show a way to define a heterogeneous List with a Variant:  
`List[Variant[Int, Float64]]`

## 9.7 InlinedFixedVector 
This defines the InlinedFixedVector type. You can import it with: `from collections.vector import InlinedFixedVector`.
This type is a vector with small-vector optimization, which is dynamically allocated.
It does not resize or implement bounds checks. It is initialized with both a small-vector size (statically known) number of slots, and when it is deallocated, it frees its memory.
This data structure is useful for applications where the number of required elements is not known at compile time, but once known at runtime, is guaranteed to be equal to or less than a certain capacity.

See `fixedvectors.mojo`:
```py
from collections.vector import InlinedFixedVector

fn main():
    var vec = InlinedFixedVector[Int, 4](8)  # 1

    vec.append(10)      # 2
    vec.append(20)
    print(len(vec))     # => 2

    print(vec.capacity)             # => 8
    print(vec.current_size)         # => 2
    print(vec.dynamic_data[0])      # => 1  (!!)
    print(vec.static_data[0])       # => 10

    print(vec[0])       # => 10
    vec[1] = 42
    print(vec[1])       # => 42

    print(len(vec))     # => 2
    vec[6] = 10         # no boundaries check!
    vec.clear()
    print(len(vec))     # => 0
    print(vec2.size)        # => 0
```

In line 1, we statically allocate 4 elements, and reserve a capacity of 8 elements. To add elements to the vector, use the append method (line 2).
Access and assign elements using indexes. 

To make a shallow or deep copy, or clear all elements, see § 10.8.1

## 9.8 Slice
Slices are defined in the built-in module `builtin_slice`. They can be used to get substrings out of a string.
A slice expression follows the Python convention of [start:end:step] or with a call to slice(start,end,step).
If a start is not specified, it will default to 0. We can initialize slices by specifying where it should stop. The step is the number of elements to skip between each element. If we don't specify a step, it will default to 1. 
So for example using Python syntax, you could write as in line 1:

See ``slice.mojo`:
```py
fn main():
    var original = String("MojoDojo")
    print(original[0:4])  # => Mojo
    print(original[0:8])  # => MojoDojo
    print(original[1:8:2])  # => oooo
    print(original[0:4:2])  # => Mj

    print(original[slice(0, 4)])      # => Mojo
    var slice_expression = slice(0, 4)
    print(original[slice_expression]) # => Mojo

    var x = String("slice it!")
    var a: slice = slice(5)
    var b: slice = slice(5, 9)
    var c: slice = slice(1, 4, 2)

    print(x[a])  # => slice
    print(x[b])  # =>  it!
    print(x[c])  # => lc    ```
```

[0:4] can also be written as slice(0,4). [1:8:2] as slice(1, 8, 2). This syntax is used in the last examples.

There is also a built-in [0; end) Range type, returned by a range function.


## 9.9 Buffer 
A buffer (defined in module buffer.buffer) doesn't own the underlying memory, it's a view over data that is owned by another object. The most important operations are load and store, wherein the parametric int is a size, and the int argument is a (starting) index. All operations work with SIMD.

See `buffer1.mojo`:
```py
from buffer import Buffer
from memory.unsafe import DTypePointer

fn main():
    var p = DTypePointer[DType.uint8].alloc(8)  
    var buf = Buffer[DType.uint8, 8](p)           # 1
    buf.zero()                                    # 1B
    print(buf.load[width=8](0))                   # 2
    # => [0, 0, 0, 0, 0, 0, 0, 0]
    for i in range(len(buf)):                     # 3
        buf[i] = i
    print(buf.load[width=8](0))                   # 4
    # => [0, 1, 2, 3, 4, 5, 6, 7]

    var buf2 = buf
    buf2.dynamic_size = 4
    for i in range(buf2.dynamic_size):
        buf2[i] *= 10 
    print(buf2.load[width=4](0)) # => [0, 10, 20, 30]
    print(buf.load[width=8](0))                   # 5
    # => [0, 10, 20, 30, 4, 5, 6, 7]    

    var first_half = buf.load[width=4](0) * 2
    var second_half = buf.load[width=4](4) * 10

    buf.store(0, first_half)
    buf.store(4, second_half)
    print(buf.load[width=8](0))
    # => [0, 20, 40, 60, 40, 50, 60, 70]        # 6
    
    buf.simd_nt_store(0, second_half)
    print(buf.load[width=8](0))
    # => [40, 50, 60, 70, 40, 50, 60, 70]       # 7
    buf.fill(10)
    print(buf.load[width=8](0))
    # => [10, 10, 10, 10, 10, 10, 10, 10]
    var z = buf.stack_allocation()
    print(buf.load[width=8](0))
    # => [10, 10, 10, 10, 10, 10, 10, 10]
    print(buf.bytecount())  # => 8
```

In line 1, we allocate 8 uint8 and pass that pointer into the buffer. Then we initialize all the values to zero to make sure no garbage data is used (line 1B). In line 2, we load all elements in the buffer, starting from index 0. Loop through the buffer and set each item in line 3-4.
Now copy the buffer buf to buf2, change the dynamic size to 4, and multiply all the values by 10.  
Now print the values from the original buffer buf, to show they point to the same data (line 5).  

Utilize SIMD to manipulate 32 bytes of data at the same time (see lines 6-8).
`simd_nt_store` (nt is non-temporal): Skips the cache for memory that isn't going to be accessed soon, so if you have a large amount of data, it doesn't fill up the cache and block something else that would benefit from quick access.  
`fill`: Store the value in the argument for chunks of the width provided in the parameter.  
`stack_allocation`: Returns a buffer with the data allocated to the stack.
`aligned_stack_allocation`: Allocate to the stack with a given alignment for extra padding


## 9.10 NDBuffer
This is an N-dimensional Buffer, that can be used both statically, and dynamically at runtime (!!).  
NDBuffer can be parametrized on rank, static dimensions and Dtype. It does not own its underlying pointer.

`var ndbuf = NDBuffer[type, rank, shape]`
example:
```py
from buffer.buffer import NDBuffer

fn main():
    var ndbuf = NDBuffer[DType.uint8, 3, (2, 2, 2)]()
```
rank is an Int, the number of dimensions, for example: 3
shape is the size of each dimension, can be used as a variadic number or as a tuple.
NDBuffer has the same operations as Buffer.

## 9.11 The Tensor type from module tensor
A tensor is a higher-dimensional matrix, its type Tensor is defined in module tensor (see line 1).  
The tensor type manages its own data (unlike NDBuffer and Buffer which are just views), that is:  the tensor type performs its own memory allocation and freeing. 
Typically you'll need this import: `from tensor import Tensor, TensorSpec, TensorShape, rand`

A TensorShape contains the dimensions of a Tensor, like (2, 2) or (256, 256, 3)
A TensorSpec contains the DType of the elements of a Tensor, and its TensorShape
There are a lot of overloading constructors to create a Tensor. 
The rand function from tensor.random also automatically creates a Tensor.

A `var t = Tensor[DType.int32](10)` is a 1-dimensional Tensor or vector of 32 bits signed integers of length 10. print(t) shows us:
```
Tensor([[0, 0, 0, ..., 0, 0, 0]], dtype=int32, shape=10)
```


See `tensor0.mojo`:
```py
from tensor import Tensor


fn main():
    var t = Tensor[DType.int32](2, 2)  # shape = 2 x 2
    print(t.load[width=4]())  # => [0, 0, 0, 0]
    t.store[4](0, 1)  # stores value 1 on index 0
    t.store[4](2, 1)  # stores value 1 on index 2
    print(t)
    # =>
    # Tensor([[1, 0],[1, 0]], dtype=int32, shape=2x2)
```

Here is a simple example of using a tensor to represent an RGB image and convert it to grayscale. Both image and gray_scale_image are Tensors:
See `tensor1.mojo`:
```py
from tensor import Tensor, TensorSpec, TensorShape, rand
from utils.index import Index

var height = 256
var width = 256
var channels = 3


fn main():
    # Create the tensor of dimensions height, width, channels
    # and fill with random values - rand creates a Tensor
    var image = rand[DType.int64](height, width, channels)
    # Declare the grayscale image.
    var spec = TensorSpec(DType.int64, height, width)
    var gray_scale_image = Tensor[DType.int64](spec)

    # Perform the RGB to grayscale transform.
    for y in range(height):
        for x in range(width):
            var r = image[y, x, 0]
            var g = image[y, x, 1]
            var b = image[y, x, 2]
            gray_scale_image[Index(y, x)] = 0.299 * r + 0.587 * g + 0.114 * b

    print(gray_scale_image.shape().__str__())  # => 256x256
```

In the previous code, the Index function was used to point to a certain item in the Tensor. Here is some other simple example that demonstrates this:

See `index.mojo`:
```py
from utils.index import Index
from tensor import Tensor


def main():
    var tens = Tensor[DType.float32](3, 10, 10)
    tens[999] = 1
    tens[Index(2, 9, 9)] = 1
    print(tens[Index(2, 9, 9)])  # => 1.0
```

Tensor has fromfile() and tofile() methods to save and load as bytes from/to a file (see § 23.2, tensor2.mojo for an example).
The built-in print() function works on the Tensor type.
TensorShape and TensorSpec now have constructors that take List[Int] and StaticIntTuple to initialize shapes.

See video: [Introduction to Tensors](https://www.youtube.com/watch?v=3OWkXNdkx8E)
Tensorutils: see blogs_videos


Summarized:
* List: a dynamically-sized array of items.
* Dict: an associative array of key-value pairs.
* Set: an unordered collection of unique items.
* Vector: a vector with small-vector optimization, dynamically allocated
* Tuple: zero or more, possibly heterogeneous values in ()
* Optional: represents a value that may or may not be present.
* Variant: to hold different types of values
* Tensor: a higher-dimensional matrix of items.









