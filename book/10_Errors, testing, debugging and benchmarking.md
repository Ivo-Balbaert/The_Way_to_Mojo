# 10 Errors - Testing - Debugging - Benchmarking
In this section we discuss a variety of subjects, first how to work with errors in Mojo.

## 10.1 Raising and handling errors
### 10.1.1 The Error type
!! § 5.4 and 6.2 should be integrated here

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

### 10.1.2 Raising and handling an error - Error propagation
See `raising_an_error.mojo`:
```py
fn raise_error(cond: Bool) raises:
    if cond:
        print("No error, everything ok")
    else:
        raise Error("Provided condition is False")


fn call_possible_error():
    try:
        raise_error(False)
    except e:
        print("Error raised:", e)  # => Error raised: Provided condition is False
    else:
        print("No exception raised.")
    finally:
        print("Always executed")   # => Always executed


fn main():
    call_possible_error()
```

" In the example, an error is raised inside the function raise_error based on a given condition. Since an error is raised, the function must declare that in its signature with `raises`. This means that any one calling the function must either handle the error raised by the function, or must re-raise it further down. In the usage example, we see that the error raised by the function is handled in call_possible_error().

Let's now assume that call_possible_error() doesn't handle the errors, but wants to raise the error further down the chain. Then it must take the keyword `raises` in its signature, and in our example, the last function in the chain is main(), so this has to handle the error:

See `raising_an_error2.mojo`:
```py
fn raise_error(cond: Bool) raises:
    if cond:
        print("No error, everything ok")
    else:
        raise Error("Provided condition is False")


fn call_possible_error() raises:
    raise_error(False)


fn main():
    try:
        call_possible_error()
    except e:
        print("Error raised:", e)  # => Error raised: Provided condition is False
    else:
        print("No exception raised.")   
    finally:
        print("Always executed")   # => Always executed
```

The finally  branch is always executed. It is typically used for clean-up activities, for example, if a file is opened within a try block, then we must close the file within a finally block to ensure that even if an error is raised within the try block the file is always closed before the function returns.



## 10.2 Querying the host target
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
    print(bitwidthof[UInt64]())  # 2 => 64
    print(sizeof[UInt8]())    # 6 => 1
    print(sizeof[AnyType]())  # => 16

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
bitwidthof in line 2 uses bits instead of bytes to show the width of the type in bits. Type Foo will take 24 bits of padding (!!), as each object can only be placed at multiples of 64 in memory.
The total size in bytes of an AnyType is given by the `sizeof` function. (line 6).

The same module also contains the values os_is_linux, os_is_macos, os_is_windows, which can be used to conditionally compile code based on the operating system (see line 7).

A number of other functions starting with has_ or is_ give info about the processor type and capabilities of the host system. (see line 8 and following).
* has_sse4(): SSE4 is the older SIMD instruction extension for x86 processors (introduced in 2006).
* has_avx(): AVX (Advanced Vector Extensions) are instructions for x86 SIMD support. They are commonly used in Intel and AMD chips (from 2011 onwards).
* has_avx2(): AVX2 (Advanced Vector Extensions 2) are instructions for x86 SIMD support, expanding integer commands to 256 bits (from 2013 onwards).
* has_avx512f(): AVX512 (Advanced Vector Extensions 512) added 512 bit support for x86 SIMD instructions (from 2016 onwards).
* has_intel_amx(): AMX is an extension to x86 with instructions for special units designed for ML workloads such as TMUL which is a matrix multiply on BF16 (from 2023 onwards).
* has_neon(): Neon also known as Advanced SIMD is an ARM extension for specialized instructions.
* is_apple_m1(): The Apple M1 chip contains an ARM CPU that supports Neon 128 bit instructions and is GPU accessible through Metal API.

The following example (taken from the standard Mojo distribution) prints the current host system information using APIs from the sys module.

See `deviceinfo.mojo`:
```py
from sys.info import (
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
    var cpu = String(_current_cpu())
    var arch = String(_triple_attr())
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

## 10.3 Testing 
### 10.3.1 Module testing 
We already discussed assert_equal in § 3.5. But this module implements various a whole set of testing utilities.

See `testing1.mojo`:
```py
# All assertion errors are commented out!
from testing import *


fn main() raises:
    var b1 = 3 < 5
    assert_true(b1, "This is false!")  # this is True, no output
    # assert_false(b1, "This is false!")
    # => AssertionError: This is false!
    var b2 = 3 > 5
    # assert_true(b2, "This is false!")
    # => AssertionError: This is false!
    assert_false(b2, "This is false!") # this is True, no output

    var n = 41
    var m = 42
    assert_not_equal(n, m)  # this is True, no output

    var p = SIMD[DType.float16, 4](1.0, 2.1, 3.2, 4.3)
    var q = SIMD[DType.float16, 4](1.0, 2.1, 3.2, 4.3)
    assert_equal(p, q)   # this is True, no output

    var q2 = SIMD[DType.float16, 4](1.1, 2.2, 3.3, 4.4)
    # assert_almost_equal(p, q2, atol = 0.1)
    # Unhandled exception caught during execution: 
    # At /home/ivo/mojo/test/testing1.mojo:24:24: 
    # AssertionError: [1.0, 2.099609375, 3.19921875, 4.30078125] is not close to 
    # [1.099609375, 2.19921875, 3.30078125, 4.3984375] with a diff of 
    # [0.099609375, 0.099609375, 0.1015625, 0.09765625]
    assert_almost_equal(p, q2, atol = 0.2)  # this is True, no output

# Good! Caught the raised error, test passes
    with assert_raises():
        raise "SomeError"

# Also good!
    with assert_raises(contains="Some"):
        raise "SomeError"

# This will assert, we didn't raise
    # with assert_raises():  # => AssertionError: Didn't raise
    #     pass

# This will let the underlying error propagate, failing the test
    # with assert_raises(contains="Some"):
    #     raise "OtherError"  # =>  OtherError
```

`assert_true(Boolean, message)` tests the Boolean expression which is its first argument. If True, nothing happens. If False, AssertionError: is printed, followed by message.
`assert_false(Boolean, message)` works the other way around.
Both raise an Error when the assertion fails.

Likewise, there are `assert_equal(val1, val2)` and `assert_not_equal(val1, val2)`, where val1 and val2 must be both of type Int, String or SIMD[type, size].
`assert_almost_equal(val1, val2)` checks whether both values are approximately equal, within an absolute tolerance of atol.

### 10.3.2 Test functions
The test-utilities defined in the previous section are meant to be used in *test functions*. 
* These must be of the def type, because they can raise an error. 
* They take no arguments
* Their name must be like `test_*`, where * is a description of the purpose of the test.

Here is an example test function:  
```py
from testing import assert_equal


def test_equality():
    assert_equal(42, 42)
```

### 10.3.3 Test runner
The Mojo CLI has a built-in *test runner* `mojo test` that can be used to test Mojo programs.
*Test files* are any mojo files with `test` in the filename, such as test_users_controller.mojo or user_model_tests.mojo.
The test runner recursively searches the `test` directory for any files . For example, given the following directory structure:
```
test/
  test_users_controller.mojo
  factories.mojo
  models/
    user_model_tests.mojo
```

Mojo will search for test_users_controller.mojo and user_model_tests.mojo for tests, but not factories.mojo. It then executes the test functions in these test files.

!! Test out, concrete example

## 10.4 Other assert statements
Both constrained and debug_assert are built-in.

### 10.4.1 constrained
`constrained[cond, error_msg]` asserts that the condition cond is true at *compile-time*. It is used to place constraints on functions.

In the following example we ensure that the two parameters to `add_positives` are both > 0:

See `constrained.mojo`:
```py
fn add_positives[x: Int, y: Int]() -> UInt8:
    constrained[x > 0, "use a positive number"]()  # 1A
    constrained[y > 0]()  # 1B
    return x + y


fn main():
    var res = add_positives[2, 4]()
    print(res)  # => 6
    # _ = add_positives[-2, 4]()  # 2
    # => error: function instantiation failed
    # => note:               constraint failed: use a positive number
```

If the condition fails, you get a **compile-time error**, and optionally the error message is displayed.
Line 2 gives a whole error output containing:  
```
error: function instantiation failed
...
note:  constraint failed: use a positive number
```

### 10.4.2 debug_assert
`debug_assert[cond, err_msg]` checks that the condition is true, but only in debug builds. It is removed from the compilation process in release builds. It works like assert in C++.

See `debug_assert1.mojo`:
```py
fn test_debug_assert[x: Int](y: Int):
    debug_assert(x == 42, "x is not equal to 42")
    debug_assert(y == 42, "y is not equal to 42")

fn main():
    test_debug_assert[1](2)
```

`mojo debug_assert1.mojo` doesn't produce any output.
But when you run this as `mojo -D ASSERT_WARNING debug_assert1.mojo`, you get the following output:
```
At /home/ivo/mojo/test/debug_assert1.mojo:2:17: Assert Warning: x is not equal to 42
At /home/ivo/mojo/test/debug_assert1.mojo:3:17: Assert Warning: y is not equal to 42
```

>Note:  Users cannot use debug_assert with just specifying -debug-level full. 
-debug-level full and "debug" build are different things; `mojo --debug-level full debug_assert1.mojo` doesn't give any output.

The shipped mojo-sdk is always a "release" build in that sense with regard to debug_assert. By default, assertions are *not enabled* in the standard library right now for performance reasons. An explicit option for users to specify -D MOJO_ENABLE_ASSERTIONS was added:
```
mojo -D MOJO_ENABLE_ASSERTIONS debug_assert1.mojo
Assert Error: x is not equal to 42
...
```
But this crashes on the second assertion.


## 10.5 The time module

See `timing.mojo`:
```py
from time import now, sleep, time_function

fn sleep1ms():
    sleep(0.001)

fn measure():
    fn closure() capturing:
        sleep1ms()

    var nanos = time_function[closure]()   # 3
    print("sleeper took", nanos, "nanoseconds to run")

fn main():
    print(now())        # 1 => 227897314188

    var tic = now()     # 2
    sleep(0.001)
    var toc = now() - tic
    print("slept for", toc, "nanoseconds")
    # => slept for 1160397 nanoseconds

    measure()  # => sleeper took 1066729 nanoseconds to run  
```
The now() function (line 1) gets the current number of nanoseconds using the systems monotonic clock, which is generally the time elapsed since the machine was booted. Behavior will vary by platform for states like sleep etc.  
The sleep() function can be used to make a thread sleep for the duration in seconds, here 1 ms (see lines 2 and following).  

time_function() (used in line 3) tells you how long it takes (in nanoseconds) for a function closure to execute: pass in a nested function as parameter (also known as a closure that takes no arguments and returns None as a parameter), to time a function for example sleep1ms.

Here is example code where we time the execution of the Fibonacci function:
See `time_fibonacci.mojo`:
```py
from time import now

fn fib(n: Int) -> Int:
    if n <= 1:
        return n
    else:
        return fib(n - 1) + fib(n - 2)

fn main():
    var eval_begin = now()
    var res = fib(50)
    var eval_end = now()
    var execution_time_sequential = Float64((eval_end - eval_begin))
    print("execution_time sequential in ms:")
    print(execution_time_sequential / 1000000)
# =>
# execution_time sequential in ms:
# 24500 ms average
```


## 10.6 Module benchmark
The class allows you to benchmark a given function (passed as a parameter) with:  
`benchmark.run[function]()`
and to print out a report with: `report.print()`.
Import it through `from benchmark import Unit, benchmark` or just `import benchmark`.

Here is a simple example to get started:

See `benchmark1.mojo`:
```py
from benchmark import Unit, benchmark
from time import sleep

fn sleeper():     # function to be benchmarked
    sleep(.01)

fn main():
    var report = benchmark.run[sleeper]()
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

You can also configure various benchmarking parameters, such as number of warmup iterations, maximum number of iterations, minimum and maximum elapsed time.
We'll benchmark the execution of the Fibonacci function, defined as follows:

See `running_benchmark.mojo`:
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
        var nth = n1 + n2
        n1 = n2
        n2 = nth
        count += 1
    
    return n1

fn sleeper():
    print("sleeping 300,000ns")
    sleep(3e-4)

fn test_fib():
    var n = 35
    for i in range(n):
        _ = fib(i)

fn test_fib_iterative():
    var n = 35
    for i in range(n):
        _ = fib_iterative(i)


fn main():
    var report = benchmark.run[test_fib]()
    print(report.mean(), "seconds")
    # => 0.03266296134722222 seconds

    report = benchmark.run[test_fib_iterative]()
    print(report.mean(), "seconds")
    # => 1.3176532113682314e-17 seconds

    print("0 warmup iters, 5 max iters, 0ns min time, 1_000_000_000ns max time")
    report = benchmark.run[sleeper](0, 5, 0, 1_000_000_000)
    print(report.mean(), "seconds")
    # 1.4999999999999997e-17 seconds
    # 0 warmup iters, 5 max iters, 0ns min time, 1_000_000_000ns max time
    # -nan seconds
```
!! -nan seconds

Pass the test function in as a parameter:  `benchmark().run[test_fib]()`.
This returns the execution time in seconds: 
# => 0.033257654583333331 seconds

Let us now compare this to the iterative version (fib_iterative):
# =>  1.6000000000000001e-17 seconds

The compiler has nearly optimized away everything that took time in the previous version.

The 3rd example demonstrates the maximum number of iterations (max_iters) here 5

As the 1st parameter, you can also set up the number of warmup iterations (num_warmup).  
As the 3rd parameter, you can also set up the minimum running time (min_time_ns).


## 10.7 Debugging in VSCode
For more info see [Debugger](https://docs.modular.com/mojo/tools/debugging).

A *fully featured LLDB debugger* and a *Mojo LLDB plugin* are included, which also supports debugging C, C++, and Objective-C. Press the down arrow next to the ▶️ button in the top right of a Mojo file, and select Debug Mojo File: !! Image with breakpoint. The default key is F5, and you can rebind the related hotkeys in Preferences: Open Keyboard Shortcuts > Debug: Start Debugging

Use `mojo debug` to start a debugging session on the command-line using LLDB:

```py
ivo@megaverse:~/mojo/test$ mojo debug test.mojo
Current executable set to '/home/ivo/.modular/pkg/packages.modular.com_mojo/bin/mojo' (x86_64).
(lldb)
```

The `h` command displays all options.

When debugging in VSCode itself, the *Debug Console* offers you an in-built LLDB command-line session. Anything prefixed with a colon (:) is treated as an LLDB command. Any other input is treated as an expression.

!! 2024-05-30: in WSL (Ubuntu 22) on Windows 11
Trying to get the value of a variable only gives:  
`expression failed to parse (no further compiler diagnostics)`
Reason: variables are optimized out.
See: [Feature Request] Debugging Support for Mojo in VS Code and PyCharm #1829

*Workaround:*  set a `breakpoint()` instruction in the code, variable values are displayed!

*Workaround 2:* start debugging on the command-line like this:
mojo build -O0 -debug-level=full test.mojo -o /tmp/bin
mojo debug --rpc /tmp/bin
Then a debugging session is started within VSCode.

