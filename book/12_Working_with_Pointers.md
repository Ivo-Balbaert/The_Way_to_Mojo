# 12 – Working with Pointers
**Don’t be afraid of pointers.**

Mojo needs the concept of *pointer* as a low-level systems language.  

Pointers are really needed to efficiently access memory, instead of having to move around big chunks of data in memory all the time.
To do low-level things and get the best performance, we need direct access to memory locations, just like C and other low-level languages. That's what pointers are for. Mojo gives you the power to do whatever you want with pointers.

We already encountered some examples of Pointer use, particularly in § 7 when defining Structs.

>Note: If you work with pointers in Mojo, this is unsafe and can cause undefined behavior (UB). Also you have to free their memory explicitly with `pointer.free()`

## 12.1 - What is a pointer?
A pointer to a variable contains the memory address of that variable, it _points to_ the variable. So it is a  reference to a memory location, which can be on the stack or on the heap (For a good discussion about these two types of memory, see [Stack vs Heap](https://hackr.io/blog/stack-vs-heap)). 
In other words: a pointer stores an address to any type, allowing you to allocate, load and modify single instances or arrays of the type on the heap.
(?? schema)
In Mojo, a Pointer is defined as a parametric struct that contains an address of any *mlirtype*. Pointer[element_type] type is defined in module memory.unsafe, and is implemented with an underlying 
!kgen.pointer<element_type> type in MLIR.

## 12.2 - Defining and using pointers
Coding with pointers is inherently unsafe, so you have to import the Pointer type and its methods as follows:  

See `pointers1.mojo`:  
```py
from memory.unsafe import Pointer
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

All the values will in the allocated memory will be garbage. We need to manually zero them if there is a chance we might read the value before writing it, otherwise it'll be undefined behavior (UB). This is done with the `memset_zero` function from module memory.


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

If we want to use get the struct instance with `p1[0]`, we must annotate the struct with @register_passable:

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
    let coord = p1[0]
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

Lets add 5 to it and store it at offset 1, and then print both the records:
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
    let third_coord = p1.load(2)
    print(third_coord.x)  # => 7
    print(third_coord.y)  # => 7
```

The values printed out are garbage values, we've done something very dangerous that will cause undefined behavior, and allow attackers to access data they shouldn't.

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

## 12.3 - Writing safe pointer code
As we saw in the previous §, it's easy to make mistakes when playing with pointers. So let's make the code of our struct more robust to reduce the surface area of potential errors. We enclose our struct Coord in another struct Coords which contains a data field that is a Pointer[Coord]. Then we can build in safeguards, for example in the __getitem__ method we make sure that the index stays within the bounds of the length of Coords.

See `pointers2.mojo`:  
```py
from memory.unsafe import Pointer
from memory import memset_zero

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

    fn __del__(owned self):
        return self.data.free()

fn main() raises:
    let coords = Coords(5)
    print(coords[5].x)

# =>
# Unhandled exception caught during execution: Trying to access index out of bounds
# mojo: error: execution exited with a non-zero result: 1
```

## 12.4 - Working with DTypePointers
A DTypePointer stores an address with a given DType, allowing you to allocate, load and modify data with convenient access to SIMD operations.

See `dtypepointer1.mojo`:
```py
from memory.unsafe import DTypePointer
from random import rand
from memory import memset_zero

fn main():
    var p1 = DTypePointer[DType.uint8].alloc(8)    # 1
    let p2 = DTypePointer[DType.uint8].alloc(8)

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
    var all_data = p1.simd_load[8](0)  # 4
    print(all_data) # => [0, 0, 0, 0, 0, 0, 0, 0]
    rand(p1, 4)             # 5
    print(all_data) # => [0, 0, 0, 0, 0, 0, 0, 0]
    all_data = p1.simd_load[8](0)  # 6
    print(all_data) # => [0, 33, 193, 117, 0, 0, 0, 0]
     
    var half = p1.simd_load[4](0)  # 7
    half = half + 1
    p1.simd_store[4](4, half)
    all_data = p1.simd_load[8](0)
    print(all_data) # => [0, 33, 193, 117, 1, 34, 194, 118]

    # pointer arithmetic:
    p1 += 1         # 8
    all_data = p1.simd_load[8](0)
    print(all_data) # => [33, 193, 117, 1, 34, 194, 118, 0]

    p1 -= 1         # 9
    all_data = p1.simd_load[8](0)
    print(all_data) # => [0, 33, 193, 117, 1, 34, 194, 118]
    p1.free()       # 10

    all_data = p1.simd_load[8](0)
    print(all_data) # 11 => [67, 32, 35, 40, 83, 85, 0, 0]
```

In line 1, we create two variables to store a new address on the heap and allocate 8 bytes. Then we perform some operations with the two pointers.  
In line 3, we first zero out all the values to be able to clearly see what is happening in the next calculations. This zeroes 8 bytes as p1 is a pointer of type UInt8, and we have allocated 8 of them. Now we print these out in line 4.  
In line 5, we store some random data in only half of the 8 bytes.  
Notice that the all_data variable does not contain a reference to the heap, it's a sequential 8 bytes on the stack or in a register, so we don't see the changed data yet.  
We need to load the data from the heap to see what's now at the address. (see line 6).  
Now lets grab the first half, add 1 to the first 4 bytes with a single instruction SIMD, and store it in the second half (line 7).  Load the data and print it out again.  
( You're now taking advantage of the hardware by using specialized instructions to perform an operation on 32/64 bytes of data at once, instead of 4 separate operations, and these operations can also run through special registers that can significantly boost performance. ?? --> SIMD )

Let's now do some pointer arithmetic (line 8).  
You can see we're now starting from the 2nd byte, and we have a garbage value at the end that we haven't allocated! Be careful as this is undefined behavior (UB) and a security vulnerability, attackers could take advantage of this. You need to be very careful not to introduce a problem like this when using pointers.
Lets move back to where we were (line 9).
In line 10 we free the memory.  
In line 11, we introduce a security vulnerability by using the pointer after free and accessing the garbage data that's not allocated, don't do this in real code!

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

    # This allows you to use let x = obj[1]
    fn __getitem__(self, row: Int) -> SIMD[DType.uint8, 8]:
        return self.data.simd_load[8](row * 8)

    # This allows you to use obj[1] = SIMD[DType.uint8]()
    fn __setitem__(self, row: Int, data: SIMD[DType.uint8, 8]):
        return self.data.simd_store[8](row * 8, data)

    fn print_all(self):
        print("--------matrix--------")
        for i in range(8):
            print(self[i])

fn main():
    let matrix = Matrix()       # 1
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
