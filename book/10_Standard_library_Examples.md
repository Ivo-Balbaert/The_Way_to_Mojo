    # 10 Standard library examples

## 10.1 Assert statements
Both constrained and debug_assert are built-in.

### 10.1.1 constrained
`constrained[cond, error_msg]` asserts that the condition cond is true at compile-time. It is used to place constraints on functions.

In the following example we ensure that the two parameters to `assert_positives` are both > 0:

See `constrained.mojo`:
```mojo
fn add_positives[x: Int, y: Int]() -> UInt8:
    constrained[x > 0, "use a positive number"]()     # 1A
    constrained[y > 0]()     # 1B
    return x + y

fn main():
    let res = add_positives[2, 4]()
    print(res)  # => 6
    # _ = add_positives[-2, 4]()  # 2
```

If the condition fails, you get a compile error, and optionally the error message is displayed.
Line 2 gives the error:  
```
constrained.mojo:2:23: note:               constraint failed: param assertion failed
    constrained[x > 0]()     # 1A
                      ^
```

Or if you supplied a custom error message:
```
constrained.mojo:2:23: note:               constraint failed: use a positive number
```

### 10.1.2 debug_assert
`debug_assert[cond, err_msg]` checks that the condition is true, but only in debug builds. It is removed from the compilation process in release builds. It works like assert in C++.

See `debug_assert.mojo`:
```mojo
fn test_debug_assert[x: Int](y: Int):
    debug_assert(x == 42, "x is not equal to 42")
    debug_assert(y == 42, "y is not equal to 42")

fn main():
    test_debug_assert[1](2)
```

When run as `mojo debug_assert.mojo` there is no output.
??`mojo --debug-level full debug_assert1.mojo` also doesn't give any output (2023 Sep 9)

>Note: debug_assert doesn't work in the Playground because this is not a debug build.

## 10.2 Module testing 


## 10.3 Module benchmark
The class allows to benchmark a given function (passed as a parameter) and configure various benchmarking parameters, such as number of warmup iterations, maximum number of iterations, minimum and maximum elapsed time.
Import it in your code through: `from benchmark import Benchmark`
We'll benchmark the execution of the fibonacci function, defined as follows:
(code: see `running_benchmark.mojo`)`

```mojo
from benchmark import Benchmark

fn fib(n: Int) -> Int:
    if n <= 1:
       return n 
    else:
       return fib(n-1) + fib(n-2)
```

To benchmark it, create a nested fn (here called `closure`) that takes no arguments and doesn't return anything, then pass it in as a parameter:  `Benchmark().run[closure]()`.
This returns the execution time in nanoseconds.

```mojo
fn bench():
    fn closure():
        let n = 35
        for i in range(n):
            _ = fib(i)

    let nanoseconds = Benchmark().run[closure]()
    print("Nanoseconds:", nanoseconds)
    print("Seconds:", Float64(nanoseconds) / 1e9)

fn main():
    bench()`
    
# =>
# Nanoseconds: 28052724
# Seconds: 0.028052724000000001
```

Let us now compare this to the iterative version (fib_iterative):

```mojo
fn fib_iterative(n: Int) -> Int:
    var count = 0
    var n1 = 0
    var n2 = 1

    while count < n:
       let nth = n1 + n2
       n1 = n2
       n2 = nth
       count += 1
    return n1

fn bench_iterative():
    fn iterative_closure():
        for i in range(n):
            _ = fib_iterative(i)

    let iterative = Benchmark().run[iterative_closure]()
    print("Nanoseconds iterative:", iterative)

fn main():
    bench_iterative()
# => Nanoseconds iterative: 0
```

The compiler has optimized away everything that took time in the previous version.

`bench_args()` demonstrates the maximum number of iterations (max_iters) here 5
`bench_args2()` demonstrates how to limit the max running time(max_time_ns) here 0.001, so it will never run over 0.001 seconds

As the 1st parameter, you can also set up the number of warmup iterations (num_warmup).  
As the 3rd parameter, you can also set up the minimum running time (min_time_ns).

## 10.4 Type Buffer from module memory.buffer
A buffer (defined in module memory.buffer) doesn't own the underlying memory, it's a view over data that is owned by another object.

See `buffer1.mojo`:
```mojo
from memory.buffer import Buffer
from memory.unsafe import DTypePointer

fn main():
    let p = DTypePointer[DType.uint8].alloc(8)  
    let x = Buffer[8, DType.uint8](p)           # 1
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
    let first_half = x.simd_load[4](0) * 2
    let second_half = x.simd_load[4](4) * 10

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

    from sys.intrinsics import PrefetchOptions
    x.prefetch[PrefetchOptions().for_read().high_locality()](0)
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
`prefetch`: Specifies how soon until the data will be visited again and how the data will be used, to optimize for the cache.

## 10.5 Type NDBuffer from module memory.buffer
This is an N-dimensional Buffer, that can be used both statically, and dynamically at runtime.  
NDBuffer can be parametrized on rank, static dimensions and Dtype. It does not own its underlying pointer.

See `ndbuffer1.mojo`:
```mojo
from utils.list import DimList
from memory.unsafe import DTypePointer
from memory.buffer import NDBuffer
from memory import memset_zero
from utils.list import VariadicList, DimList
from algorithm.functional import unroll

struct Tensor[rank: Int, shape: DimList, type: DType]:      # 1
    var data: DTypePointer[type]
    var buffer: NDBuffer[rank, shape, type]

    fn __init__(inout self):
        let size = shape.product[rank]().get()
        self.data = DTypePointer[type].alloc(size)
        memset_zero(self.data, size)
        self.buffer = NDBuffer[rank, shape, type](self.data)

    fn __del__(owned self):
        self.data.free()

    fn __getitem__(self, *idx: Int) raises -> SIMD[type, 1]:   # 8
        for i in range(rank):
            if idx[i] >= shape.value[i].get():
                raise Error("index out of bounds")
        return self.buffer.simd_load[1](VariadicList[Int](idx))

    fn get[*idx: Int](self) -> SIMD[type, 1]:               # 10
        @parameter
        fn check_dim[i: Int]():
            constrained[idx[i] < shape.value[i].get()]()

        unroll[rank, check_dim]()

        return self.buffer.simd_load[1](VariadicList[Int](idx))

fn main() raises:
    let x = Tensor[3, DimList(2, 2, 2), DType.uint8]()          # 2
    x.data.simd_store(0, SIMD[DType.uint8, 8](1, 2, 3, 4, 5, 6, 7, 8))
    print(x.buffer.num_elements())  # 3  => 8

    print(x.buffer[0, 0, 0])        # 4  => 1
    print(x.buffer[1, 0, 0])        # 5  => 5
    print(x.buffer[1, 1, 0])        # 6  => 7

    x.buffer[StaticIntTuple[3](1, 1, 1)] = 50
    print(x.buffer[1, 1, 1])        # => 50  
    print(x.buffer[1, 1, 2])        # 7 => 88

    let x2 = Tensor[3, DimList(2, 2, 2), DType.uint64]()
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
    x.buffer.fill(10)
    print(x.buffer[1, 1, 1])       # => 10
    let y = x.buffer.flatten()
    print(y[7])                    # => 10    
    print(x.buffer.get_nd_index(5)) # => (1, 0, 1)
    print(x.buffer.get_rank())     # => 3
    print(x.buffer.get_shape())    # => (2, 2, 2) 
    print(x.buffer.size())         # => 8
    let new = x.buffer.stack_allocation()
    print(new.size())              # => 8
    print(x.buffer.stride(0))      # => 4
    print(x.buffer.get_nd_index(4)) # => (1, 0, 0)
    x.buffer.zero()
    print(x.get[0, 0, 0]())         # => 0
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

## 10.6 Querying the host target info with module sys.info
Methods for querying the host target info are implemented in module `sys.info`.

See `target_info.mojo`:
```mojo
from sys.info import (
    alignof,
    bitwidthof,
    simdwidthof,
    simdbitwidth,
    simd_byte_width,
    sizeof,
    os_is_linux,
    os_is_macos,
    os_is_windows
)
from sys.info import (
    has_avx,
    has_avx2,
    has_avx512f,
    has_intel_amx,
    has_neon,
    has_sse4,
    is_apple_m1
)

struct Foo:
    var a: UInt8
    var b: UInt32

fn main():
    print(alignof[UInt64]())  # => 8
    print(alignof[Foo]())     # 1 => 4
    print(bitwidthof[Foo]())  # 2 => 64
    print(simdwidthof[DType.uint64]()) # 3 => 4
    print(simdbitwidth())     # 4 => 256
    print(simd_byte_width())  # 5 => 32
    print(sizeof[UInt8]())    # 6 => 1

    @parameter                # 7
    if os_is_linux():
        print("this will be included in the binary")
    # => this will be included in the binary
    else:
        print("this will be eliminated from compilation process")

    print(os_is_macos())     # => False
    print(os_is_windows())   # => False

    print(has_sse4())        # => True
    print(has_avx())         # => True
    print(has_avx2())        # => True
    print(has_avx512f())     # => False
    print(has_intel_amx())   # => False
    print(has_neon())        # => False
    print(is_apple_m1())     # => False
```

To check the alignment of any type, use the alignof function. In the struct Foo (line 1) it returns 4 bytes. This means each instance of Foo will start at a memory address that is a multiple of 4 bytes. There will also be 3 bytes of padding to accommodate the UInt8.  
bitwidthof in line 2 uses bits instead of bytes to show the width of the type in bits. Type Foo will take 24 bits of padding, as each object can only be placed at multiples of 64 in memory.

simdwidthof is used to show how many of the type can fit into the targets SIMD register, e.g. to see how many uint64's can be processed with a single instruction. For our system, the SIMD register can process 4 UInt64 values at once (see line 3). 
simd_bit_width is the total amount of bits that can be processed at the same time on the host systems SIMD register, line 4 shows 256.
simd_byte_width is the total amount of bytes that can be processed at the same time on the host systems SIMD register, , line 5 shows 32.  
The total size in bytes of an AnyType is given by the sizeof function. (line 6).

The same module also contains the values os_is_linux, os_is_macos, os_is_windows, which can be used to conditionally compile code based on the operating system (see line 7).

A number of other functions starting with has_ or is_ give info about the processor type/capabilities of the host system. (see line 8 and following).
* has_sse4(): SSE4 is the older SIMD instruction extension for x86 processors (introduced in 2006).
* has_avx(): AVX (Advanced Vector Extensions) are instructions for x86 SIMD support. They are commonly used in Intel and AMD chips (from 2011 onwards).
* has_avx2(): AVX2 (Advanced Vector Extensions 2) are instructions for x86 SIMD support, expanding integer commands to 256 bits (from 2013 onwards).
* has_avx512f(): AVX512 (Advanced Vector Extensions 512) added 512 bit support for x86 SIMD instructions (from 2016 onwards).
* has_intel_amx(): AMX is an extension to x86 with instructions for special units designed for ML workloads such as TMUL which is a matrix multiply on BF16 (from 2023 onwards).
* has_neon(): Neon also known as Advanced SIMD is an ARM extension for specialized instructions.
* is_apple_m1(): The Apple M1 chip contains an ARM CPU that supports Neon 128 bit instructions and GPU accessible through Metal API.

## 10.7 The time module

See `timing.mojo`:
```mojo
from time import now, sleep, time_function

fn sleep1ms():
    sleep(0.001)

fn measure():
    fn closure():
        sleep1ms()

    let nanos = time_function[closure]()   # 3
    print("sleeper took", nanos, "nanoseconds to run")
    # => sleeper took 1066729 nanoseconds to run

fn main():
    print(now())    # 1 => 227897314188

    # sleep()
    let tic = now()     # 2
    sleep(0.001)
    let toc = now() - tic
    print("slept for", toc, "nanoseconds")
    # => slept for 1160397 nanoseconds

    measure()   
```

The now() function (line 1) gets the current number of nanoseconds using the systems monotonic clock, which is generally the time elapsed since the machine was booted. Behavior will vary by platform for states like sleep etc.  
The sleep() function can be used to make a thread sleep for the duration in seconds, here 1 ms (see lines 2 and following).  

time_function() (used in line 3) tells you how long it takes (in nanoseconds) for a function closure to execute: pass in a nested function (also known as a closure that takes no arguments and returns None as a parameter), to time a function for example sleep1ms.

## 10.8 Vectors from the module utils.vector

## 10.8.1 DynamicVector
(see also § 4.2.1, 4.5, 7.9.2)
This is a dynamically-allocated vector.
It supports pushing and popping from the back resizing the underlying storage as needed. 

See `dynamicvector1.mojo`:
```mojo
from utils.vector import DynamicVector

fn main():
    var vec = DynamicVector[Int](8)  # 1

    vec.push_back(10)
    vec.push_back(20)
    print(len(vec))     # 2 => 2
    print(vec.size)     # => 2

    print(vec.capacity) # 3 => 8
    print(vec.data[0])  # 4 => 10
   
    print(vec[0])       # 5 => 10
    vec[1] = 42     
    print(vec[1])       # => 42
    print(len(vec))     # => 2
    vec[6] = 10         # 6
    print(len(vec))     # => 2

    let vec2 = vec      # 7
    vec[0] = 99
    print(vec2[0])      # => 99

    let vec3 = vec.deepcopy()  # 8
    vec[1] = 100
    print(vec3[1])      # => 42

    print(len(vec))     # => 2
    print(vec.pop_back()) # 9 => 
    print(len(vec))     # => 1

    vec.reserve(16)     # 10
    print(vec.capacity) # => 16

    vec.resize(10)      # 11
    print(vec.size)     # => 10
    
    vec.clear()         # 12
    print(vec[1])       # => 1  ??
    print(vec.size)     # => 0
    print(len(vec))     # => 0
```

You can reserve memory to add elements without the cost of copying everything if it grows too large. For example, we reserve 8 bytes in line 1 to store Int values.  
Adding elements to the back is done with the push_back method, and len (line 2) gives the number of items, which is also given by vec.size. 
(why are there two ways ??) 
Other useful variables are:
* capacity: the memory reserved for the vector
* the `data` field, which gives access to the underlying storage by indexing. But you can also use indexing by using the vector's name directly as in line 5.

>Notes: 
> when setting new elements with vec[i]=  (as in line 6), len doesn't change. If you need len, only use push_back
> ?? until now (2023 Sep 19) there is no bounds checking

Copying a DynamicVector (line 7) will result in a shallow copy. vec2 will be a pointer to the same location in memory (schema ??). If we modify vec, then vec2 will also be updated.  

Use a deep copy (line 8) to copy all the data to a different location in memory so it's independent from the original. Modifying the original then won't effect the new copy.

The inverse to push_back is the method pop_back, which will access the last element, deallocate it, and reduce the element size by 1 (see line 9).

The `reserve` method lets you change the capacity (line 10). If it's greater than the current capacity then data is reallocated and moved. If it's smaller, nothing happens. 

The `resize` method discards elements if smaller than current size, or adds uninitialized data if larger (line 11) (why still need for reserve, difference, no reallocation ??). 

The `clear` method deallocates all items in the vector (line 12, doesn't seem to work). The size is set to 0.

## 10.8.2 InlinedFixedVector
This type is a dynamically-allocated vector with small-vector optimization.
It does not resize or implement bounds checks, it is initialized with both a small-vector size (statically known) and a dynamic (not known at compile time) number of slots, and when it is deallocated, it frees its memory.
This data structure is useful for applications where the number of required elements is not known at compile time, but once known at runtime, is guaranteed to be equal to or less than a certain capacity.

See `InlinedFixedvector.mojo`:
```mojo
from utils.vector import InlinedFixedVector

fn main():
    var vec = InlinedFixedVector[4, Int](8)  # 1

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
    print(len(vec))     # => 2
```

In line 1, we statically allocate 4 elements, and reserve a capacity of 8 elements. To add elements to the vector, use the append method (line 2).
Access and assign elements using indexes. 

>Notes: 
> when setting new elements with vec[i]= , len doesn't change. If you need len, only use append
> ?? until now (2023 Sep 19) there is no bounds checking

To make a shallow or deep copy, or clear all elements, tee § 10.8.1

## 10.8.3 UnsafeFixedVector
This type is a dynamically-allocated vector that does not resize or implement bounds checks (see line 3).
It is initialized with a dynamic (not known at compile time) number of slots.

This data structure is useful for applications where the number of required elements is not known at compile time, but once known at runtime, is guaranteed to be equal to or less than a certain capacity.

You index them as InlineFixedVector (with the same note). Only a shallow copy is possible.

```mojo
    var vec2 = UnsafeFixedVector[Int](8) # 3
    vec2.append(10)
    vec2.append(20)
    print(len(vec))   # => 2

    print(vec2.capacity)    # => 8
    print(vec2.data[0])     # => 10
    print(vec2.size)        # => 2

    vec2.clear()
    print(vec2[1])          # => 20 
```


