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