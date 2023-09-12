# 10 Standard library examples

## 10.1 Assert statements
Both constrained and debug_assert are built-in.

### 10.1.1 constrained
`constrained[cond, error_msg]` asserts that the condition cond is true at compile-time. It is used to place constraints on functions.

In the following example we ensure that the two parameters to `assert_positives` are both > 0:

See `constrained.mojo`:
```py
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
```py
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

```py
from benchmark import Benchmark

fn fib(n: Int) -> Int:
    if n <= 1:
       return n 
    else:
       return fib(n-1) + fib(n-2)
```

To benchmark it, create a nested fn (here called `closure`) that takes no arguments and doesn't return anything, then pass it in as a parameter:  `Benchmark().run[closure]()`.
This returns the execution time in nanoseconds.

```py
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

```py
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

## 10.4 Module buffer
A buffer (defined in module memory.buffer) doesn't own the underlying memory, it's a view over data that is owned by another object.

See `buffer1.mojo`:
```py
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
