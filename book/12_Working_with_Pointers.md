# 12 – Working with Pointers
**Don't be afraid of pointers.**

Pointers are a fundamental concept in many low-level systems programming languages, and they exist also in Mojo. They offer the following advantages:  
* Memory Efficiency: Pointers allow programs to use memory more efficiently. Instead of copying and storing entire data structures, a program can use pointers to reference these structures. This is particularly useful when dealing with large data structures.
* Dynamic Memory Allocation: Pointers enable dynamic memory allocation. This means that memory for variables can be allocated and deallocated during runtime, which provides flexibility and control over the memory usage of your program.
* Data Structures and Algorithms: Pointers are essential for creating complex data structures like trees and linked lists. They also enable efficient implementation of various algorithms.
* Function Arguments: Pointers can be used to pass arguments by reference to a function. This means that the function can modify the original data, not just a copy of it. In Mojo however (see 6.3.1) the default is that arguments are passed as borrowed, they are immutable references.

In Mojo, pointers are used with care to avoid potential errors. For example, the language provides an `UnsafePointer` type that cannot be copied, which helps prevent issues like dangling pointers or memory leaks. Mojo also allows you to define functions that take `owned` arguments, enabling you to transfer ownership of a pointer to another function.

To do low-level things and get the best performance, we need direct access to memory locations, just like C and other low-level languages. Mojo gives you the power to do whatever you want with pointers.

We already encountered some examples of Pointer use, particularly in § 7 when defining Structs.

>Note: If you work with pointers in Mojo, this is unsafe and can cause undefined behavior (UB). Also you have to free their memory explicitly with `pointer.free()`

## 12.1 - What is a pointer?
A pointer to a variable contains the memory address of that variable, it _points to_ the variable. So it is a  reference to a memory location, which can be on the stack or on the heap (For a good discussion about these two types of memory, see [Stack vs Heap](https://hackr.io/blog/stack-vs-heap)). 
In other words: a pointer stores an address to any type, allowing you to allocate, load and modify single instances or arrays of the type on the heap.
(?? schema)
In Mojo, a Pointer is defined as a parametric struct that contains an address of any *mlirtype*. UnsafePointer[element_type] type is defined in module memory.unsafe_pointer, and is implemented with an underlying 
!kgen.pointer<element_type> type in MLIR.

## 12.2 - Defining and using pointers
Better use UnsafePointer from memory.unsafe_pointer ??
Coding with pointers is inherently unsafe, so you have to import the Pointer type and its methods as follows:  

Simpler example, see `pointers0.mojo`:  
address_of / casting the type with bitcast 
```py
fn main() raises:
    # Create a Pointer to an existing variable:
    var x: Int = 42  # x must be mutable to pass as a reference
    var xPtr = Pointer[Int].address_of(x)
     # print the address:
    print(xPtr.__as_index()) # => 140722471124352
    # print the value (dereference the pointer):
    print(xPtr.load())  # => 42  


    # Casting type of Pointer with bitcast:
    var yPtr: Pointer[UInt8] = xPtr.bitcast[UInt8]()

    var array = Pointer[Int].alloc(3)
    array.store(0, 1)
    array.store(1, 2)
    print(array.load(0))  # => 1
    # how to print out?
    for i in range(3):
        print_no_newline(array.load(i), " - ")

# =>
# 140721558458944
# 42
# 1
# 1  - 2  - 0  -
```

See `pointers1.mojo`:  
```py
from memory import memset_zero
```

Create a struct Coord that we will use as the type for the pointer.  
Then in line 1, we define a pointer p1 to point to a Coord instance, and we allocate 2 bytes in memory for the 2 Uint8 fields (same for p2). 

```py
@register_passable
struct Coord:
    var x: UInt8 
    var y: UInt8

fn main():
    var p1 = Pointer[Coord].alloc(2)        # 1
    var p2 = Pointer[Coord].alloc(2)
```

All the values in the allocated memory will be garbage. We need to manually zero them if there is a chance we might read the value before writing it, otherwise it'll be undefined behavior (UB). This is done with the `memset_zero` function from module memory.


```py
fn main():
    # ...
    memset_zero(p1, 2)                 # 2 
    memset_zero(p2, 2)
```
As we see in lines 3 and 4, we can test if two pointers are equal with ==. A pointer that has been allocated tests True in an if statement.  

```py
fn main():
    # ...
    if p1:                             # 3
        print("p1 is not null") # => p1 is not null
    print("p1 and p2 are equal:", p1 == p2) 
    # 4 => p1 and p2 are equal: False
    print("p1 and p2 are not equal:", p1 != p2) 
    # => p1 and p2 are not equal: True
```

If we want to use the struct instance with `p1[0]`, we must annotate the struct with @register_passable:

```py
@register_passable
struct Coord:
    var x: UInt8 
    var y: UInt8
```

Then we can write:
```py
fn main():
    # ...
    var coord = p1[0]
    print(coord.x) # => 0
```

We can set the values, but p1[0] hasn't been modified. This is because coord is an identifier to memory on the stack or in a register. 
```py
fn main():
    # ...
    coord.x = 5
    coord.y = 5
    print(coord.x) # => 5
    print(p1[0].x) # => 0
```

We need to write the data with `store`:
```py
fn main():
    # ...
    p1.store(0, coord)
    print(p1[0].x) # => 5
```

Let's add 5 to it and store it at offset 1, and then print both the records:
```py
fn main():
    # ...
    coord.x += 5
    coord.y += 5
    p1.store(1, coord)
    for i in range(2):
        print(p1[i].x)
        print(p1[i].y)
    # =>
    # 5
    # 5
    # 10
    # 10
```

Here is an example to show how easy it is to get undefined behavior:  
```py
    var third_coord = p1.load(2)
    print(third_coord.x)  # => 7
    print(third_coord.y)  # => 7
```

The values printed out are garbage values, we've done something potentially very dangerous that will cause undefined behavior, and allow attackers to access data they shouldn't.

Let's do arithmetic with the pointer p1:
```py
 p1 += 2
    for i in range(2):
        print(p1[i].x)
        print(p1[i].y)
# =>
# 21
# 86
# 0
# 0
```
The values printed out are garbage!
Let's move back to where we were and free the memory, if we forget to free the memory, that will cause a memory leak if this code runs a lot:

```py
    p1 -= 2
    p1.free()
```

(idioms:
    data = Pointer[Float32].alloc(n)
    data.free()

    self.data.store(i, value)
    self.data.load(i) )

 var data: Pointer[Int]

Setting a pointer to null:
data = Pointer[Int].get_null()

Testing if a pointer is not null:
fn __del__(owned self):
        # Free the data only if the Pointer is not null
        if (self.data):
            self.data.free()

## 12.3 - Writing safe pointer code
As we saw in the previous §, it's easy to make mistakes when working with pointers. So let's make the code of our struct more robust to reduce the surface area of potential errors. We enclose our struct Coord in another struct Coords which contains a data field that is a Pointer[Coord]. Then we can build in safeguards, for example in the __getitem__ method we make sure that the index stays within the bounds of the length of Coords.

See `pointers2.mojo`:
```py
from memory import memset_zero

@value
@register_passable
struct Coord:
    var x: UInt8 
    var y: UInt8

struct Coords:
    var data: Pointer[Coord]
    var length: Int

    fn __init__(inout self, length: Int) raises:
        self.data = Pointer[Coord].alloc(length)
        memset_zero(self.data, length)
        self.length = length

    fn __getitem__(self, index: Int) raises -> Coord:
        if index > self.length - 1:
            raise Error("Trying to access index out of bounds")
        return self.data.load(index)

    fn __setitem__(inout self, index: Int, value: Coord) raises:
        if index >= self.length:
            raise Error("Trying to access index out of bounds")
        self.data.store(index, value)
    
    fn __del__(owned self):
        return self.data.free()

fn main() raises:
    var coords = Coords(5)

    var coord1 = Coord(1, 2)
    var coord2 = Coord(3, 4)
    var coord3 = Coord(5, 6)
    coords[0] = coord1
    coords[1] = coord2
    print(coords[0].x, coords[0].y, coords[1].x, coords[1].y,) # => 1 2 3 4

    coords[1] = coord3
    print(coords[0].x, coords[0].y, coords[1].x, coords[1].y,) # => 1 2 5 6

    var coords = Coords(5)
    print(coords[5].x)

# =>
# Unhandled exception caught during execution: Trying to access index out of bounds
# mojo: error: execution exited with a non-zero result: 1
```

## 12.4 - Working with DTypePointers
Much faster than Pointer!
    Pointer: data.load(i) / data.store(i)
	DTypePointer: data.load[width=], data.store
A DTypePointer stores an address with a given DType, allowing you to allocate, load and modify data with convenient access to SIMD operations.

See `dtypepointer1.mojo`:
```py
from memory.unsafe import DTypePointer
from random import rand
from memory import memset_zero

fn main():
    var p1 = DTypePointer[DType.uint8].alloc(8)    # 1
    var p2 = DTypePointer[DType.uint8].alloc(8)

    # 2 - Operations:
    if p1:
        print("p1 is not null")
    print("p1 is at a lower address than p2:", p1 < p2)
    print("p1 and p2 are equal:", p1 == p2)
    print("p1 and p2 are not equal:", p1 != p2)
# => p1 is not null
    #  p1 is at a lower address than p2: True
    #  p1 and p2 are equal: False
    #  p1 and p2 are not equal: True

    memset_zero(p1, 8)      # 3
    var all_data = p1.load[width=8](0)  # 4
    print(all_data) # => [0, 0, 0, 0, 0, 0, 0, 0]
    rand(p1, 4)             # 5
    print(all_data) # => [0, 0, 0, 0, 0, 0, 0, 0]
    all_data = p1.load[width=8](0)  # 6
    print(all_data) # => [0, 33, 193, 117, 0, 0, 0, 0]
     
    var half = p1.load[width=4](0)  # 7
    half = half + 1
    p1.store[](4, half)
    all_data = p1.load[width=8](0)
    print(all_data) # => [0, 33, 193, 117, 1, 34, 194, 118]

    # pointer arithmetic:
    p1 += 1         # 8
    all_data = p1.load[width=8](0)
    print(all_data) # => [33, 193, 117, 1, 34, 194, 118, 0]

    p1 -= 1         # 9
    all_data = p1.load[width=8](0)
    print(all_data) # => [0, 33, 193, 117, 1, 34, 194, 118]
    p1.free()       # 10

    all_data = p1.load[width=8](0)
    print(all_data) # 11 => [67, 32, 35, 40, 83, 85, 0, 0]
```

In line 1, we create two variables to store a new address on the heap and allocate 8 bytes. Then we perform some operations with the two pointers.  
In line 3, we first zero out all the values to be able to clearly see what is happening in the next calculations. This zeroes 8 bytes as p1 is a pointer of type UInt8, and we have allocated 8 of them. Now we print these out in line 4.  
In line 5, we store some random data in only half of the 8 bytes.  
Notice that the all_data variable does not contain a reference to the heap, it's a sequential 8 bytes on the stack or in a register, so we don't see the changed data yet.  
We need to load the data from the heap to see what's now at the address. (see line 6).  
Now lets grab the first half, add 1 to the first 4 bytes with a single instruction SIMD, and store it in the second half (line 7).  Load the data and print it out again.  
( You're now taking advantage of the hardware by using specialized instructions to perform a  SIMD operation on 32/64 bytes of data at once, instead of 4 separate operations, and these operations can also run through special registers that can significantly boost performance. )

Let's now do some pointer arithmetic (line 8).  
You can see we're now starting from the 2nd byte, and we have a garbage value at the end that we haven't allocated! Be careful as this is undefined behavior (UB) and a security vulnerability, attackers could take advantage of this. You need to be very careful not to introduce a problem like this when using pointers.
Lets move back to where we were (line 9).
In line 10 we free the memory.  
In line 11, we introduce a security vulnerability by using the pointer after freeing it and accessing the garbage data that's not allocated, don't do this in real code!

As in § 12.3, let's now write safe pointer code by building a safe struct abstraction around it that interacts with the pointer, so we have less surface area for potential mistakes:

See `dtypepointer2.mojo`:
```py
from memory.unsafe import DTypePointer
from random import rand
from memory import memset_zero

struct Matrix:
    var data: DTypePointer[DType.uint8]

    fn __init__(inout self):
        "Initialize the struct and set everything to zero."
        self.data = DTypePointer[DType.uint8].alloc(64)
        memset_zero(self.data, 64)

    fn __del__(owned self):
        return self.data.free()

    # This allows you to use var x = obj[1]
    fn __getitem__(self, row: Int) -> SIMD[DType.uint8, 8]:
        return self.data.load[width=8](row * 8)

    # This allows you to use obj[1] = SIMD[DType.uint8]()
    fn __setitem__(self, row: Int, data: SIMD[DType.uint8, 8]):
        return self.data.store[](row * 8, data)

    fn print_all(self):
        print("--------matrix--------")
        for i in range(8):
            print(self[i])

fn main():
    var matrix = Matrix()       # 1
    matrix.print_all()
# =>
# --------matrix--------
# [0, 0, 0, 0, 0, 0, 0, 0]
# [0, 0, 0, 0, 0, 0, 0, 0]
# [0, 0, 0, 0, 0, 0, 0, 0]
# [0, 0, 0, 0, 0, 0, 0, 0]
# [0, 0, 0, 0, 0, 0, 0, 0]
# [0, 0, 0, 0, 0, 0, 0, 0]
# [0, 0, 0, 0, 0, 0, 0, 0]
# [0, 0, 0, 0, 0, 0, 0, 0]

    for i in range(8):      # 2
        matrix[i] = i

    matrix.print_all()
# =>
# --------matrix--------
# [0, 0, 0, 0, 0, 0, 0, 0]
# [1, 1, 1, 1, 1, 1, 1, 1]
# [2, 2, 2, 2, 2, 2, 2, 2]
# [3, 3, 3, 3, 3, 3, 3, 3]
# [4, 4, 4, 4, 4, 4, 4, 4]
# [5, 5, 5, 5, 5, 5, 5, 5]
# [6, 6, 6, 6, 6, 6, 6, 6]
# [7, 7, 7, 7, 7, 7, 7, 7]

    for i in range(8):
        matrix[i][0] = 9
        matrix[i][7] = 9

    matrix.print_all()
# =>
# --------matrix--------
# [9, 0, 0, 0, 0, 0, 0, 9]
# [9, 1, 1, 1, 1, 1, 1, 9]
# [9, 2, 2, 2, 2, 2, 2, 9]
# [9, 3, 3, 3, 3, 3, 3, 9]
# [9, 4, 4, 4, 4, 4, 4, 9]
# [9, 5, 5, 5, 5, 5, 5, 9]
# [9, 6, 6, 6, 6, 6, 6, 9]
# [9, 7, 7, 7, 7, 7, 7, 9]

    var fourth_row = matrix[3]
    print("\nfourth row:", fourth_row)
# => fourth row: [9, 3, 3, 3, 3, 3, 3, 9]
    fourth_row *= 2
    print("modified:", fourth_row, "\n")
# => modified: [18, 6, 6, 6, 6, 6, 6, 18] 
    matrix[0] = fourth_row
    matrix.print_all()
# =>
# --------matrix--------
# [18, 6, 6, 6, 6, 6, 6, 18]
# [9, 1, 1, 1, 1, 1, 1, 9]
# [9, 2, 2, 2, 2, 2, 2, 9]
# [9, 3, 3, 3, 3, 3, 3, 9]
# [9, 4, 4, 4, 4, 4, 4, 9]
# [9, 5, 5, 5, 5, 5, 5, 9]
# [9, 6, 6, 6, 6, 6, 6, 9]
# [9, 7, 7, 7, 7, 7, 7, 9]
```

Initializing the matrix will set all the values to 0. Note that the matrix identifier is immutable with let, but we're still able to modify the data because the data member is var (line 1).  
We can loop through and set the values, one row at a time with SIMD using the abstraction we built. (line 2).  

Because it's returning a SIMD[DType.u8, 8], we can also modify the column value using __setitem__ from the SIMD implementation (line 3).  
As another example, lets take the fourth row, doubling it, and then writing that to the first row (line 4).

## 12.5 Random numbers
(Also examples in § 5.4 and § 9.6)
This functionality is implemented in the `random` package.


See `random1.mojo`:
```py
from random import seed, rand, randint, random_float64, random_si64, random_ui64
from memory import memset_zero

fn main():
    var p1 = DTypePointer[DType.uint8].alloc(8)    # 1
    var p2 = DTypePointer[DType.float32].alloc(8)  # 
    memset_zero(p1, 8)
    memset_zero(p2, 8)
    print('values at p1:', p1.load[width=8](0))
    # => values at p1: [0, 0, 0, 0, 0, 0, 0, 0]
    print('values at p2:', p2.load[width=8](0))
    # => values at p2: [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]

    rand[DType.uint8](p1, 8)        # 2A
    rand[DType.float32](p2, 8)      # 2B
    print('values at p1:', p1.load[width=8](0))
    # => values at p1: [0, 33, 193, 117, 136, 56, 12, 173]
    print('values at p2:', p2.load[width=8](0))
    # => values at p2: [0.93469291925430298, 0.51941639184951782, 0.034572109580039978, 0.52970021963119507, 0.007698186207562685, 0.066842235624790192, 0.68677270412445068, 0.93043649196624756]

    randint[DType.uint8](p1, 8, 0, 10)  # 3
    print(p1.load[width=8](0))
    # => [9, 5, 1, 7, 4, 7, 10, 8]

    print(random_float64(0.0, 1.0)) # 4 => 0.047464513386311948
    print(random_si64(-10, 10)) # 5 => 5
    print(random_ui64(0, 10)) # 6 => 3
```

In lines 1 and following we create two variables to store new addresses on the heap and allocate space for 8 values, note the different DType, uint8 and float32 respectively. Zero out the memory to ensure we don't read garbage memory.
Now in lines 2A-B, we fill them both with 8 random numbers.
To generate random integers in a range, for example 1 - 10, use the function randint (see line 3).  
The function random_float64 returns a single random Float64 value within a specified range e.g 0.0 to 1.0 (see line 4).
The function random_si64 returns a single random Int64 value within a specified range e.g -10 to +10 (see line 5).
The function random_ui64 returns a single random UInt64 value within a specified range e.g 0 to +10 (see line 6).

