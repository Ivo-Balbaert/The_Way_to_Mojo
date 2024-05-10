# 9 - Collection types
These include basic collection types like List, Dict, Set and Optional, with which you can build more complex data-structures. They are stored in the `collections` package.

The collection types are *generic types*: while a given collection can only hold a specific type of value (such as Int or Float64), you specify the type at compile time using a parameter. For example, you can create a List of Int values like this: `var l = List[Int](1, 2, 3, 4)`
In this case, Mojo can infer the type, so you can write: `var l = List(1, 2, 3, 4)`

Let's start with the List types.

## 9.1 ListLiteral
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

## 9.2 VariadicList
In § 6.4.1 we encountered the VariadicList type, which is typically used to take in the variable number of arguments *args in a variadic function. It is stored in the same module as ListLiteral. In other words: it provides a "list" view of the function arguments. Each of the arguments and the number of arguments are accessable.

## 9.3 DimList
The DimList type represents a list of dimensions. It is imported with: 
`from buffer.list import DimList`.  
For example, the Tensor type uses it in the second argument of its definition: `struct Tensor[rank: Int, shape: DimList, type: DType]` 
Look at the complete programs with Tensors to see DimList used.

## 9.4 List
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

## 9.5 Implementing a list-like behavior with PythonObject
This snippet shows how we could use a PythonObject to create a list, just for fun (or mihjt there be some use-cases ??):

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


## 9.6  Sorting a List
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

This function sortsthe list in-place.


## 9.7 Dict
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


## 9.8 Set
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

## 9.9 Optional
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

## 9.10 Tuple 
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

## 9.11 Variant 
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

fn main():
    # They have to be mutable for now, and implement CollectionElement
    var an_int = IntOrString(4)
    var a_string = IntOrString(String("I'm a string!"))
    var who_knows = IntOrString(0)
    import random
    if random.random_ui64(0, 1):
        who_knows.set[String]("I'm actually a string too!")

    print(to_string(an_int))    # =>  4
    print(to_string(a_string))  # =>I'm a string!
    print(to_string(who_knows)) # =>0
```

A variant type is defined in line 1.

## 9.12 InlinedFixedVector 
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
    print(vec.dynamic_data[0])      # => 1  (??)
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

## 9.13 Slice
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

XYZ

## 9.14 Buffer 
A buffer (defined in module buffer.buffer) doesn't own the underlying memory, it's a view over data that is owned by another object.

See `buffer1.mojo`:
```py
from memory.buffer import Buffer
from memory.unsafe import DTypePointer

fn main():
   varp = DTypePointer[DType.uint8].alloc(8)  
   varx = Buffer[8, DType.uint8](p)           # 1
    x.zero()
    print(x.simd_load[8](0))                    # 2
    # => [0, 0, 0, 0, 0, 0, 0, 0]
    for i in range(len(x)):                     # 3
        x[i] = i
    print(x.simd_load[8](0))                    # 4
    # => [0, 1, 2, 3, 4, 5, 6, 7]
    var y = x
    y.dynamic_size = 4
    for i in range(y.dynamic_size):
        y[i] *= 10 
    print(y.simd_load[4](0)) # => [0, 10, 20, 30]
    print(x.simd_load[8](0))                    # 5
    # => [0, 10, 20, 30, 4, 5, 6, 7]    

    # SIMD:
   varfirst_half = x.simd_load[4](0) * 2
   varsecond_half = x.simd_load[4](4) * 10

    x.simd_store(0, first_half)
    x.simd_store(4, second_half)
    print(x.simd_load[8](0))
    # => [0, 20, 40, 60, 40, 50, 60, 70]        # 6
    
    x.simd_nt_store(0, second_half)
    print(x.simd_load[8](0))
    # => [40, 50, 60, 70, 40, 50, 60, 70]       # 7
    x.simd_fill[8](10)
    print(x.simd_load[8](0))
    # => [10, 10, 10, 10, 10, 10, 10, 10]
    var z = x.stack_allocation()
    print(x.simd_load[8](0))
    # => [10, 10, 10, 10, 10, 10, 10, 10]
    print(x.bytecount())  # => 8
    x.aligned_simd_store[8, 8](0, 5)
    print(x.aligned_simd_load[8, 8](0))
    # => [5, 5, 5, 5, 5, 5, 5, 5]
    z = x.aligned_stack_allocation[8]()

```

In line 1, we allocate 8 uint8 and pass that pointer into the buffer. Then we initialize all the values to zero to make sure no garbage data is used (line 2). Loop through the buffer and set each item in line 3-4.
Now copy the buffer x to y, change the dynamic size to 4, and multiply all the values by 10.  
Now print the values from the original buffer x, to show they point to the same data (line 5).  
Utilize SIMD to manipulate 32 bytes of data at the same time (see lines 6- ).
`simd_nt_store` (nt is non-temporal): Skips the cache for memory that isn't going to be accessed soon, so if you have a large amount of data it doesn't fill up the cache and block something else that would benefit from quick access.  
`simd_fill`: Store the value in the argument for chunks of the width provided in the parameter.  
`stack_allocation`: Returns a buffer with the data allocated to the stack.
`aligned_simd_store`: Some registers work better with different alignments e.g. AVX-512 performs better with 64 bit alignment, so you might want padding for a type like a UInt32.
`aligned_simd_load`: see above
`aligned_stack_allocation`: Allocate to the stack with a given alignment for extra padding


## 10.5 Type NDBuffer from module memory.buffer
This is an N-dimensional Buffer, that can be used both statically, and dynamically at runtime.  
NDBuffer can be parametrized on rank, static dimensions and Dtype. It does not own its underlying pointer.

See `ndbuffer1.mojo`:  (see also § 10.9 for Tensor from stdlib, use that!)
```py
from utils.list import DimList
from memory.unsafe import DTypePointer
from memory.buffer import NDBuffer
from memory import memset_zero
from utils.list import DimList
from algorithm.functional import unroll

struct Tensor[rank: Int, shape: DimList, type: DType]:      # 1
    var data: DTypePointer[type]
    var buffer: NDBuffer[rank, shape, type]

    fn __init__(inout self):
       varsize = shape.product[rank]().get()
        self.data = DTypePointer[type].alloc(size)
        memset_zero(self.data, size)
        self.buffer = NDBuffer[rank, shape, type](self.data)

    fn __del__(owned self):
        self.data.free()

    fn __getitem__(self, *idx: Int) raises -> SIMD[type, 1]:   # 8
        for i in range(rank):
            if idx[i] >= shape.value[i].get():
                raise Error("index out of bounds")
        return self.buffer.simd_load[1](idx)

    fn get[*idx: Int](self) -> SIMD[type, 1]:               # 10
        @parameter
        fn check_dim[i: Int]():
            constrained[idx[i] < shape.value[i].get()]()

        unroll[rank, check_dim]()

        return self.buffer.simd_load[1](VariadicList[Int](idx))

fn main() raises:
   varx = Tensor[3, DimList(2, 2, 2), DType.uint8]()          # 2
    x.data.simd_store(0, SIMD[DType.uint8, 8](1, 2, 3, 4, 5, 6, 7, 8))
    print(x.buffer.num_elements())  # 3  => 8

    print(x.buffer[0, 0, 0])        # 4  => 1
    print(x.buffer[1, 0, 0])        # 5  => 5
    print(x.buffer[1, 1, 0])        # 6  => 7

    x.buffer[StaticIntTuple[3](1, 1, 1)] = 50
    print(x.buffer[1, 1, 1])        # => 50  
    print(x.buffer[1, 1, 2])        # 7 => 88

   varx2 = Tensor[3, DimList(2, 2, 2), DType.uint64]()
    x2.data.simd_store(0, SIMD[DType.uint64, 8](0, 1, 2, 3, 4, 5, 6, 7))
    # print(x2[0, 2, 0])              # 9 
    # => Unhandled exception caught during execution: index out of bounds
    # print(x.get[1, 1, 2]())         # 11
    # => note:                             constraint failed: param assertion failed
    #        constrained[idx[i] < shape.value[i].get()]()

    print(x.buffer.simd_load[4](0, 0, 0))  # => [1, 2, 3, 4]
    print(x.buffer.simd_load[4](1, 0, 0))  # => [5, 6, 7, 50]
    print(x.buffer.simd_load[2](1, 1, 0))  # => [0, 0]

    print(x.buffer.dynamic_shape)  # => (2, 2, 2)
    print(x.buffer.dynamic_stride) # => (4, 2, 1)
    print(x.buffer.is_contiguous)  # => True

    print(x.buffer.bytecount())    # => 8
    print(x.buffer.dim[0]())       # => 2
    print(x.buffer[1, 1, 1])       # => 10
   vary = x.buffer.flatten()
    print(y[7])                    # => 10    
    print(x.buffer.get_nd_index(5)) # => (1, 0, 1)
    print(x.buffer.get_rank())     # => 3
    print(x.buffer.get_shape())    # => (2, 2, 2) 
    print(x.buffer.size())         # => 8
   varnew = x.buffer.stack_allocation()
    print(new.size())              # => 8
    print(x.buffer.stride(0))      # => 4
    print(x.buffer.get_nd_index(4)) # => (1, 0, 0)
    x.buffer.zero()
    print(x.get[0, 0, 0]())         # => 0

# => compare output !!
8
1
5
7
50
1
[1, 2, 3, 4]
[5, 6, 7, 50]
[7, 50]
(2, 2, 2)
(4, 2, 1)
True
8
2
50
50
(1, 0, 1)
3
(2, 2, 2)
8
8
4
(1, 0, 0)
0
```

The struct defined in line 1 allows you to carry around the pointer that owns the data the NDBuffer is pointing to.
In line 2 we create a shape statically and store data, but be careful there's no safety checks on our struct yet. The buffer is used in line 3 to display the number of elements.  
We can also access elements via it's 3D shape (see lines 4-6).
*Run-time bounds checking*
There are no safety checks on our struct yet so we can access data out of bounds, as seen in line 7.  
Let's make our own __get__ method that enforces bounds checking (see line 8). Line 9 shows that it works.  
This bounds checking isn't optimal because it has a runtime cost, we could create a separate function that checks the shape at compile time:

*Compile-time bounds checking*
This is implemented in the get() method from line 10.   
*idx is a variadic list of Int, so you can pass in as many as you like.
get() Creates a closure named check_dim decorated by @parameter so it runs at compile time, it's checking that each item in *idx is less then the same dimension in the static shape. unroll is used to run it at compile-time i amount of times. This is shown in line 11.




## 10.9 The Tensor type from module tensor
- From v 0.5.0: 
Tensor has new fromfile() and tofile() methods to save and load as bytes from a file.
The built-in print() function now works on the Tensor type.
TensorShape and TensorSpec now have constructors that take List[Int] and StaticIntTuple to initialize shapes.

A tensor is a higher-dimensional matrix, its type Tensor is defined in module tensor (see line 1).  
The tensor type manages its own data (unlike NDBuffer and Buffer which are just views), that is:  the tensor type performs its own memory allocation and freeing. Here is a simple example of using the tensor type to represent an RGB image and convert it to grayscale:
See video: [Introduction to Tensors](https://www.youtube.com/watch?v=3OWkXNdkx8E)
Tensorutils: see blogs_videos

See `tensor0.mojo`:
```py
from tensor import Tensor

fn main():
   vart = Tensor[DType.int32](2, 2)
    print(t.simd_load[4](0, 1, 2, 3)) # => [0, 1970038374, 26739, 33] 
    t.simd_store[4](0, 1)  # 4 values from start get value 1
    print(t)
    # =>
    # Tensor([[1, 1], [1, 1]], dtype=int32, shape=2x2)
```

See `tensor1.mojo`:
```py
from tensor import Tensor, TensorSpec, TensorShape
from utils.index import Index
from random import rand

let height = 256
let width = 256
let channels = 3

fn main():
    # Create the tensor of dimensions height, width, channels
    # and fill with random values.
   varimage = rand[DType.float32](height, width, channels) # -> Tensor

    # Declare the grayscale image.
   varspec = TensorSpec(DType.float32, height, width)
    var gray_scale_image = Tensor[DType.float32](spec)

    # Perform the RGB to grayscale transform.
    for y in range(height):
        for x in range(width):
           varr = image[y,x,0]
           varg = image[y,x,1]
           varb = image[y,x,2]
            gray_scale_image[Index(y,x)] = 0.299 * r + 0.587 * g + 0.114 * b

    print(gray_scale_image.shape().__str__()) # => 256x256
```

Nice example of vectorizing:
See `tensor2.mojo`:
```py
from tensor import Tensor
from random import rand
from math import sqrt, round
from algorithm import vectorize
from sys.info import simdwidthof

alias type = DType.float32
alias simd_width: Int = simdwidthof[type]()

fn tensor_math(t: Tensor[type]) -> Tensor[type]:
    var t_new = Tensor[type](t.shape())
    for i in range(t.num_elements()):
        t_new[i] = sqrt(t[i])  # some for round isntead of sqrt
    return t_new

fn tensor_math_vectorized(t: Tensor[type]) -> Tensor[type]:
    var t_new = Tensor[type](t.shape())
    
    @parameter
    fn vecmath[simd_width: Int](idx: Int) -> None:
        t_new.simd_store[simd_width](idx, sqrt(t.simd_load[simd_width](idx)))
    vectorize[simd_width, vecmath](t.num_elements())
    return t_new


fn main():
   vart = rand[type](2,2)
    print(t.shape().__str__()) # 3x3
    print(t.spec().__str__())  # 3x3xfloat32
    # print(t[0]) # => 0.1315377950668335
    # print(t[1]) # => 0.458650141954422
    # print(t[2]) # => 0.21895918250083923
    # print(t.num_elements()) # => 9

    # tensorprint() utility ?
    for i in range(t.num_elements()):
       print(t[i]) 

    print()
   vart1 = tensor_math(t)
    for i in range(t1.num_elements()):
       print(t1[i]) 

    print()
   vart2 = tensor_math_vectorized(t)
    for i in range(t2.num_elements()):
       print(t2[i]) 

    print(simd_width) # => 8
```

=========================================================================================
Summarized:
* List: a dynamically-sized array of items.
* Dict: an associative array of key-value pairs.
* Set: an unordered collection of unique items.
* Vector: a vector with small-vector optimization, dynamically allocated
* Tuple: zero or more, possibly heterogeneous values in ()
* Optional: represents a value that may or may not be present.
* Variant: to hold different types of values









