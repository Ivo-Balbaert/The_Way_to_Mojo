# 10 Standard library examples

## 10.4 Type Buffer from module memory.buffer
A buffer (defined in module memory.buffer) doesn't own the underlying memory, it's a view over data that is owned by another object.

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

## 10.8 Vectors from the module collections.vector
(?? Table schema with properties ?)

InlinedFixedVector: small-vector optimization
UnsafeFixedVector: fixed-capacity vector without bounds checks


### 10.8.2 Sorting a List
The sort module in package algorithms implements different sorting functions. Here is an example of usage:  

See `sorting1.mojo`:
```py
from algorithm.sort import sort

fn main():
    var v = List[Int](3)

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
```

These functions sort the vector in-place.

### 10.8.3 InlinedFixedVector
This type is a vector type with small-vector optimization.
It allocates memory statically for a fixed number of elements, which eliminates the need for dynamic memory allocation for small vectors.
It does not resize or implement bounds checks, it is initialized with both a small-vector size (statically known) number of slots, and when it is deallocated, it frees its memory.
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
    vec[6] = 10
    vec.clear()
    print(len(vec))     # => 0
    print(vec2.size)        # => 0
```

In line 1, we statically allocate 4 elements, and reserve a capacity of 8 elements. To add elements to the vector, use the append method (line 2).
Access and assign elements using indexes. 

>Notes: 
> when setting new elements with vec[i]= , len doesn't change. If you need len, only use append
> ?? until now (2023 Sep 19) there is no bounds checking

To make a shallow or deep copy, or clear all elements, tee § 10.8.1


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


