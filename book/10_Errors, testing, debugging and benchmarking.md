# 10 Errors - Testing - Debugging - Benchmarking
In this section we discuss a variety of subjects, first how to work with errors in Mojo.

## 10.1 The Error type
At a certain moment, your program can come in an abnormal state that you must signal to the outside world. You do this by "raising an error".  
The Error type (defined in built-in module `error`) is used to handle errors in Mojo.
Code can raise an error with the `Error` type, which accepts a String message. When `raise` is executed, "Error: error_message" is displayed:

See `error.mojo`:
```py
fn main() raises:
    print(return_error())     # => Error: This signals an important error!

def return_error():
    raise Error("This signals an important error!")   # 1
```

After executing line 1, the execution stops (the program crashes!) because we didn't handle the exception with try-except. It gives the following output:
```
Unhandled exception caught during execution: This signals an important error!
mojo: error: execution exited with a non-zero result: 1
```

If you want your program to handle the error gracefully, the calling function has to envelop the call to the function which raises inside a try-except block, see § 5.4 and 6.2.
This is shown in `error_handled.mojo`:
```py
fn main() raises:
    try:
        print(return_error())
    except exc:
        print("The important error is handled")
    
    print("The program continues!")

def return_error():
    raise Error("This signals an important error!")  # 1

# =>
# The important error is handled
# The program continues!
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


XYZ


## 10.6 Querying the host target info with module sys.info
Info on your host machine can be very useful to finetune Mojo's behavior if need be.  
Methods for querying the host target for that info are implemented in module `sys.info`.

See `target_info.mojo`:
```py
from sys.info import (
    alignof,
    bitwidthof,
    simdwidthof,
    simdbitwidth,
    simdbytewidth,
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


The total size in bytes of an AnyType is given by the `sizeof` function. (line 6).

The same module also contains the values os_is_linux, os_is_macos, os_is_windows, which can be used to conditionally compile code based on the operating system (see line 7).

A number of other functions starting with has_ or is_ give info about the processor type/capabilities of the host system. (see line 8 and following).
* has_sse4(): SSE4 is the older SIMD instruction extension for x86 processors (introduced in 2006).
* has_avx(): AVX (Advanced Vector Extensions) are instructions for x86 SIMD support. They are commonly used in Intel and AMD chips (from 2011 onwards).
* has_avx2(): AVX2 (Advanced Vector Extensions 2) are instructions for x86 SIMD support, expanding integer commands to 256 bits (from 2013 onwards).
* has_avx512f(): AVX512 (Advanced Vector Extensions 512) added 512 bit support for x86 SIMD instructions (from 2016 onwards).
* has_intel_amx(): AMX is an extension to x86 with instructions for special units designed for ML workloads such as TMUL which is a matrix multiply on BF16 (from 2023 onwards).
* has_neon(): Neon also known as Advanced SIMD is an ARM extension for specialized instructions.
* is_apple_m1(): The Apple M1 chip contains an ARM CPU that supports Neon 128 bit instructions and GPU accessible through Metal API.

The following example (taken from the standard Mojo distribution) prints the current host system information using APIs from the sys module.

See `deviceinfo.mojo`:
```py
ffrom sys.info import (
    os_is_linux,
    os_is_windows,
    os_is_macos,
    has_sse4,
    has_avx,
    has_avx2,
    has_avx512f,
    has_vnni,
    has_neon,
    is_apple_m1,
    has_intel_amx,
    _current_target,
    _current_cpu,
    _triple_attr,
     num_physical_cores,
)


def main():
    var os = ""
    if os_is_linux():
        os = "linux"
    elif os_is_macos():
        os = "macOS"
    else:
        os = "windows"
   varcpu = String(_current_cpu())
   vararch = String(_triple_attr())
    var cpu_features = String(" ")
    if has_sse4():
        cpu_features = cpu_features.join(" sse4")
    if has_avx():
        cpu_features = cpu_features.join(" avx")
    if has_avx2():
        cpu_features = cpu_features.join(" avx2")
    if has_avx512f():
        cpu_features = cpu_features.join(" avx512f")
    if has_vnni():
        cpu_features = cpu_features.join(" avx512_vnni")
    if has_intel_amx():
        cpu_features = cpu_features.join(" intel_amx")
    if has_neon():
        cpu_features = cpu_features.join(" neon")
    if is_apple_m1():
        cpu_features = cpu_features.join(" Apple M1")
    print("System information: ")
    print("    OS          : ", os)
    print("    CPU         : ", cpu)
    print("    Arch        : ", arch)
    print("    Num Cores   : ", num_physical_cores())
    print("    CPU Features:", cpu_features)
```

Output on my current machine (WSL2 in Windows 11 on Intel i9 - 24 cores - 64G):
```
System information: 
    OS          :  linux
    CPU         :  alderlake
    Arch        :  x86_64-unknown-linux-gnu
    Num Cores   :  12
    CPU Features:  avx2
```

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
   varres = add_positives[2, 4]()
    print(res)  # => 6
    # _ = add_positives[-2, 4]()  # 2
```

If the condition fails, you get a **compile-time error**, and optionally the error message is displayed.
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
(See also changelog/blog v 0.7)
`debug_assert[cond, err_msg]` checks that the condition is true, but only in debug builds. It is removed from the compilation process in release builds. It works like assert in C++.

See `debug_assert1.mojo`:
```py
fn test_debug_assert[x: Int](y: Int):
    debug_assert(x == 42, "x is not equal to 42")
    debug_assert(y == 42, "y is not equal to 42")

fn main():
    test_debug_assert[1](2)
```

When you run this as `mojo -D ASSERT_WARNING debug_assert1.mojo`, you get the following output:
```
Assert Warning: x is not equal to 42
Assert Warning: y is not equal to 42
```
>Note:  Users cannot use debug_assert with just specifying -debug-level full. 
-debug-level full and "debug" build are different things; `mojo --debug-level full debug_assert1.mojo` doesn't give any output.

 The shipped mojo-sdk is always a "release" build in that sense with regard to debug_assert. An explicit option for users to specify -D MOJO_ENABLE_ASSERTIONS was added:
```
mojo -D MOJO_ENABLE_ASSERTIONS debug_assert1.mojo
Assert Error: x is not equal to 42
...
```

## 10.2 Module testing 
This module implements various testing utilities.  

(code changed, because from v 0.6, assert_ return Error when the assertion fails)
See `testing1.mojo`:
```py
from testing import *


fn main():
   varb1 = 3 < 5
    print(assert_true(b1, "This is false!"))  # => None
    print(assert_false(b1, "This is false!"))
    # => ASSERT ERROR: This is false!
    # => False
   varb2 = 3 > 5
    print(assert_true(b2, "This is false!"))
    # => ASSERT ERROR: This is false!
    # => False
    print(assert_false(b2, "This is false!"))
    # => True

   varn = 41
   varm = 42
    print(assert_equal(n, m))  # => False
    print(assert_not_equal(n, m))  # => True

   varp = SIMD[DType.float16, 4](1.0, 2.1, 3.2, 4.3)
   varq = SIMD[DType.float16, 4](1.0, 2.1, 3.2, 4.3)
    print(assert_equal(p, q))  # => True

   varp2 = SIMD[DType.float16, 4](1.0, 2.1, 3.2, 4.3)
   varq2 = SIMD[DType.float16, 4](1.1, 2.2, 3.3, 4.4)
    print(assert_almost_equal(p2, q2))
    # => ASSERT ERROR: The input value [1.0, 2.099609375, 3.19921875, 4.30078125] is not close to
    # [1.099609375, 2.19921875, 3.30078125, 4.3984375] with a diff of
    # [0.099609375, 0.099609375, 0.1015625, 0.09765625]
    # False
```

`assert_true(Boolean, message)` tests the Boolean expression which is its first argument. If True, nothing happens. If False, ASSERT ERROR: is printed, followed by message.
`assert_false(Boolean, message)` works the other way around.
Both raise an Error when the assertion fails.

Likewise, there are `assert_equal(val1, val2)` and `assert_not_equal(val1, val2)`, where val1 and val2 must be both of type Int, String or SIMD[type, size].
`assert_almost_equal(val1, val2)` checks whether both values are approximately equal (tolerance ??)


## 10.3 Module benchmark

From v5, benchmark no longer requires a capturing fn so you can benchmark functions outside the same scope. You can also print a report with: `report.print()`

See `benchmark_newv5`:
```py
from benchmark import Unit, benchmark
from time import sleep

fn sleeper():
    sleep(.01)

fn main():
   varreport = benchmark.run[sleeper]()
    print(report.mean())   # => 0.010147911948148149
    report.print()
    print("")
    report.print(Unit.ms)

# ---------------------
# Benchmark Report (s)
# ---------------------
# Mean: 0.010147911948148149
# Total: 1.3699681130000001
# Iters: 135
# Warmup Mean: 0.0100463785
# Warmup Total: 0.020092756999999999
# Warmup Iters: 2
# Fastest Mean: 0.010111081172413793
# Slowest Mean: 0.010297477449999998


# ---------------------
# Benchmark Report (ms)
# ---------------------
# Mean: 10.147911948148147
# Total: 1369.9681129999999
# Iters: 135
# Warmup Mean: 10.046378499999999
# Warmup Total: 20.092756999999999
# Warmup Iters: 2
# Fastest Mean: 10.111081172413792
# Slowest Mean: 10.297477449999999
```


See first § 10.7

The class allows to benchmark a given function (passed as a parameter) and configure various benchmarking parameters, such as number of warmup iterations, maximum number of iterations, minimum and maximum elapsed time.
Import it in your code through: `import benchmark`
We'll benchmark the execution of the Fibonacci function, defined as follows:
(code: see `running_benchmark.mojo`)`

```py
import benchmark
from time import sleep


fn fib(n: Int) -> Int:
    if n <= 1:
        return n
    else:
        return fib(n - 1) + fib(n - 2)


fn fib_iterative(n: Int) -> Int:
    var count = 0
    var n1 = 0
    var n2 = 1

    while count < n:
       varnth = n1 + n2
        n1 = n2
        n2 = nth
        count += 1
    return n1


fn sleeper():
    print("sleeping 300,000ns")
    sleep(3e-4)


fn test_fib():
   varn = 35
    for i in range(n):
        _ = fib(i)

fn test_fib_iterative():
   varn = 35
    for i in range(n):
        _ = fib_iterative(i)


fn main():
    var report = benchmark.run[test_fib]()
    print(report.mean(), "seconds")
    # => 0.028419847121951218 seconds

    report = benchmark.run[test_fib_iterative]()
    print(report.mean(), "seconds")
    # => 1.3176532113682314e-17 seconds

    print("0 warmup iters, 5 max iters, 0ns min time, 1_000_000_000ns max time")
    report = benchmark.run[sleeper](0, 5, 0, 1_000_000_000)
    print(report.mean(), "seconds")
    # 1.3327284737390688e-17 seconds
    # 0 warmup iters, 5 max iters, 0ns min time, 1_000_000_000ns max time
    # sleeping 300,000ns
    # sleeping 300,000ns
    # sleeping 300,000ns
    # sleeping 300,000ns
    # sleeping 300,000ns
    # sleeping 300,000ns
    # 0.00040065083333333334 seconds```

Pass the test function in as a parameter:  `benchmark().run[test_fib]()`.
This returns the execution time in seconds.

Let us now compare this to the iterative version (fib_iterative):
# =>  1.3176532113682314e-17 seconds

The compiler has nearly optimized away everything that took time in the previous version.

The 3rd example demonstrates the maximum number of iterations (max_iters) here 5

As the 1st parameter, you can also set up the number of warmup iterations (num_warmup).  
As the 3rd parameter, you can also set up the minimum running time (min_time_ns).

Here is another example: stack dump!
See `calc_mean_matrix.mojo`:
```py
from tensor import Tensor
from random import rand
import benchmark
from time import sleep
from algorithm import vectorize, parallelize

alias dtype = DType.float32
alias simd_width = simdwidthof[DType.float32]()


fn row_mean_naive[dtype: DType](t: Tensor[dtype]) -> Tensor[dtype]:
    var res = Tensor[dtype](t.dim(0), 1)
    for i in range(t.dim(0)):
        for j in range(t.dim(1)):
            res[i] += t[i, j]
        res[i] /= t.dim(1)
    return res


fn row_mean_fast[dtype: DType](t: Tensor[dtype]) -> Tensor[dtype]:
    var res = Tensor[dtype](t.dim(0), 1)

    @parameter
    fn parallel_reduce_rows(idx1: Int) -> None:
        @parameter
        fn vectorize_reduce_row[simd_width: Int](idx2: Int) -> None:
            res[idx1] += t.simd_load[simd_width](idx1 * t.dim(1) + idx2).reduce_add()

        vectorize[2 * simd_width, vectorize_reduce_row](t.dim(1))
        res[idx1] /= t.dim(1)

    parallelize[parallel_reduce_rows](t.dim(0), t.dim(0))
    return res


fn main():
   vart = rand[dtype](1000, 1000)
    var result = Tensor[dtype](t.dim(0), 1)

    @parameter
    fn bench_mean():
        _ = row_mean_naive(t)

    @parameter
    fn bench_mean_fast():
        _ = row_mean_fast(t)

   varreport = benchmark.run[bench_mean]()
  # varreport = benchmark.run[row_mean_naive(t)]()
   varreport_fast = benchmark.run[bench_mean_fast]()
    report.print()
    report_fast.print()
    print("Speed up:", report.mean() / report_fast.mean())


# => 202.3 Nov 11: for  main():
#   vart = rand[dtype](1000,100000)
# [29195:29195:20231111,103553.196898:ERROR file_io_posix.cc:144] open /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq: No such file or directory (2)
# [29195:29195:20231111,103553.196940:ERROR file_io_posix.cc:144] open /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq: No such file or directory (2)
# Please submit a bug report to https://github.com/modularml/mojo/issues and include the crash backtrace along with all the relevant source codes.
# Stack dump:
# 0.      Program arguments: mojo calc_mean_matrix.mojo
# Stack dump without symbol names (ensure you have llvm-symbolizer in your PATH or set the environment var `LLVM_SYMBOLIZER_PATH` to point to it):
# 0  mojo      0x0000558fd8c39b97
# 1  mojo      0x0000558fd8c3776e
# 2  mojo      0x0000558fd8c3a26f
# 3  libc.so.6 0x00007f42366c9520
# 4  libc.so.6 0x00007f41740017b3
# Segmentation fault

# =>
# ---------------------
# Benchmark Report (s)
# ---------------------
# Mean: 0.0020958697733598408
# Total: 1.054222496
# Iters: 503
# Warmup Mean: 0.0019287810000000001
# Warmup Total: 0.0038575620000000001
# Warmup Iters: 2
# Fastest Mean: 0.0020823652932862192
# Slowest Mean: 0.0021170246499999999

# for (1000, 1000)
# ---------------------
# Benchmark Report (s)
# ---------------------
# Mean: 0.00068503110180224058
# Total: 1.4063688519999999
# Iters: 2053
# Warmup Mean: 0.00091436450000000004
# Warmup Total: 0.0018287290000000001
# Warmup Iters: 2
# Fastest Mean: 0.00020097415
# Slowest Mean: 0.00074287821512247071

# Speed up: 3.0595249877645565
```

## 10.7 The time module

See `timing.mojo`:
```py
from time import now, sleep, time_function

fn sleep1ms():
    sleep(0.001)

fn measure():
    fn closure():
        sleep1ms()

   varnanos = time_function[closure]()   # 3
    print("sleeper took", nanos, "nanoseconds to run")
    # => sleeper took 1066729 nanoseconds to run

fn main():
    print(now())    # 1 => 227897314188

    # sleep()
   vartic = now()     # 2
    sleep(0.001)
   vartoc = now() - tic
    print("slept for", toc, "nanoseconds")
    # => slept for 1160397 nanoseconds

    measure()   
```

Here is example code where we time the execution of the Fibonacci function (see § 19.3):
```py
from time import now

var eval_begin = now()
var res = fib(50)
var eval_end = now()
let execution_time_sequential = Float64((eval_end - eval_begin))
print("execution_time sequential in ms:")
print(execution_time_sequential / 1000000)
# =>
# execution_time sequential in ms:
# 14253.018341999999
```
(A comparison showed: Julia 21s, Rust 16s, Mojo 14s)

The now() function (line 1) gets the current number of nanoseconds using the systems monotonic clock, which is generally the time elapsed since the machine was booted. Behavior will vary by platform for states like sleep etc.  
The sleep() function can be used to make a thread sleep for the duration in seconds, here 1 ms (see lines 2 and following).  

time_function() (used in line 3) tells you how long it takes (in nanoseconds) for a function closure to execute: pass in a nested function (also known as a closure that takes no arguments and returns None as a parameter), to time a function for example sleep1ms.

## 10.10 Working with command-line arguments
This is done with module arg from the sys package.

See `cmdline_args.mojo`:
```py
from sys import argv

fn main():
    print("There are ")
    print(len(argv()))  # => 3
    print("command-line arguments, namely:")
    print(argv()[0])    # => cmdline_args.mojo
    print(argv()[1])    # => 42
    print(argv()[2])    # => abc
```

If this program is executed with the command: `$ mojo cmdline_args.mojo 42 "abc"`;
the output is:
```
There are
3
command-line arguments, namely:
cmdline_args.mojo
42
abc
```

## 10.11 Working with memory

See also:  Buffer § 10.4, 10.5
           Pointer § 12
See examples memset, memcpy, memset_zero

The `stack_allocation` function lets you allocate data buffer space on the stack, given a data type and number of elements, for example:  
`varrest_p: DTypePointer[DType.uint8] = stack_allocation[simd_width, UInt8, 1]()`


## 10.12 Working with files
This is done through the file module (v 0.4.0).

Suppose we have a my_file.txt with contents: "I like Mojo!"

See `read_file.mojo`
```py
fn main() raises:
    var f = open("my_file.txt", "r")
    print(f.read())     # => I like Mojo!
    f.close()   

    with open("my_file.txt", "r") as f:      # 1
        print(f.read()) # => I like Mojo!
```

The with in line 1 closes the file automatically.

## 10.13 The module sys.param_env
Suppose we want to define a Tensor with an element type that we provide at the command-line, like this:  mojo -D FLOAT_32 param_env1.mojo
The module sys.param_env provides a function is_defined, which returns true when the same string was passed at the command-line.

See `param_env1.mojo`:
```py
from sys.param_env import is_defined
from tensor import Tensor, TensorSpec

alias float_type: DType = DType.float32 if is_defined["FLOAT32"]() else DType.float64

fn main():
    print("float_type is: ", float_type)  # => float_type is:  float32
   varspec = TensorSpec(float_type, 256, 256)
   varimage = Tensor[float_type](spec)
```

In the same way, you can also use name-value pairs, like -D customised=1234. In that case use the functions env_get_int or env_get_string.

Another example simulating a testing environment with mojo -D testing comes https://github.com/rd4com/mojo-learning, see `param_env2.mojo`. It also shows how to print in color on the command-line.