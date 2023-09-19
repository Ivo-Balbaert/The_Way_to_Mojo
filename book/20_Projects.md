# 12 – Projects

## 12.1 - Calculating the sum of two vectors
See https://codeconfessions.substack.com/p/mojo-the-future-of-ai-programming
(code is image!)
TODO!

## 12.2 - Calculating the Euclidean distance between two vectors
(See [ref](https://www.modular.com/blog/an-easy-introduction-to-mojo-for-python-programmers))

For the algorithm: see the article.
We first write a pure Python implementation, a naive one, and then one using numpy. :

See `euclid_distance.py`:
```mojo
import time
import numpy as np
from math import sqrt
from timeit import timeit

n = 10000000
anp = np.random.rand(n)
bnp = np.random.rand(n)

alist = anp.tolist()
blist = bnp.tolist()

def print_formatter(string, value):
    print(f"{string}: {value:5.5f}")

# Pure Python iterative implementation
def python_naive_dist(a,b):
    s = 0.0
    n = len(a)
    for i in range(n):
        dist = a[i] - b[i]
        s += dist*dist
    return sqrt(s)

secs = timeit(lambda: python_naive_dist(alist,blist), number=5)/5
print("=== Pure Python Performance ===")
print_formatter("python_naive_dist value:", python_naive_dist(alist,blist))
print_formatter("python_naive_dist time (ms):", 1000*secs)

# === Pure Python Performance ===
# python_naive_dist value:: 1290.35102
# python_naive_dist time (ms):: 370.72698

# Numpy's vectorized linalg.norm implementation 
def python_numpy_dist(a,b):
    return np.linalg.norm(a-b)

secs = timeit(lambda: python_numpy_dist(anp,bnp), number=5)/5
print("=== Python+NumPy Performance ===")
print_formatter("python_numpy_dist value:", python_numpy_dist(anp,bnp))
print_formatter("python_numpy_dist time (ms):", 1000*secs)

# === Python+NumPy Performance ===
# python_numpy_dist value:: 1290.35102
# python_numpy_dist time (ms):: 18.48048
#        <--- 20.0 x faster than pure Python
```

Run it as `python3 euclid_distance.py`.

**Simple Mojo implementation**

See `euclid_distance.mojo`:
```mojo
# Create numpy arrays anp and bnp:
from python import Python      
from tensor import Tensor
from math import sqrt
from time import now

fn main() raises:
    let np = Python.import_module("numpy")
    let n = 10_000_000
    let anp = np.random.rand(n)
    let bnp = np.random.rand(n)

    var a = Tensor[DType.float64](n)
    var b = Tensor[DType.float64](n)

    for i in range(n):
        a[i] = anp[i].to_float64()
        b[i] = bnp[i].to_float64()
```

The Tensor parametric type declaration has this format:  `Tensor[DType.float64](n)` 
In Mojo *parameters* represent a compile-time value. In this example we’re telling the compiler, Tensor is a container for 64-bit floating point values. And *arguments* in Mojo represent runtime values, in this case we’re passing n=10_000_000 to Tensor’s constructor to instantiate a 1-dimensional array of 10 million values.

Calculation of Euclid distance:
```mojo
def mojo_naive_dist(a: Tensor[DType.float64], b: Tensor[DType.float64]) -> Float64:
    s = 0.0
    n = a.num_elements()
    for i in range(n):
        dist = a[i] - b[i]
        s += dist*dist
    return sqrt(s)

fn print_formatter(string: String, value: Float64):
    print_no_newline(string)
    print(value)

fn main():
    # ...
    let eval_begin = now()
    let naive_dist = mojo_naive_dist(a, b)
    let eval_end = now()

    print_formatter("mojo_naive_dist value", naive_dist)
    print_formatter("mojo_naive_dist time (ms)",Float64((eval_end - eval_begin)) / 1e6)

# mojo_naive_dist value: 1291.3664121235004
# mojo_naive_dist time (ms): 10.690652
```

What did we change?
def mojo_naive_dist:  
- function arguments are typed  
- function return value is typed  
- local variables declared with either var or let  
- local variables typed  

Here the DType.float64 parameter of our Tensor specifies that it contains 64-bit floating point values. Float64 return type represents a Mojo SIMD type, which is a low-level scalar value on the machine register. We also declare the variable s with the var keyword which tells the Mojo compiler that s is a mutable variable of type Float64.

Results:
This naive Mojo implementation is 34.7 x faster than the Python version, and 1.7 x faster than numpy.

**Speeding up our Mojo code model**  (?? no speedup at the command-line!)
Improvements: def --> fn
As a consequence: Tensor values are passed by reference so no copies are made.
Strict typing and declaring all variables is now enforced.

See `euclid_distance2.mojo`
```mojo
fn mojo_fn_dist(a: Tensor[DType.float64], b: Tensor[DType.float64]) -> Float64:
    var s: Float64 = 0.0
    let n = a.num_elements()
    for i in range(n):
        let dist = a[i] - b[i]
        s += dist*dist
    return sqrt(s)

fn main():
    let eval_begin = now()
    let fn_dist = mojo_fn_dist(a, b)
    let eval_end = now()

    print("=== Mojo Performance with fn, declarations and typing and ===")
    print_formatter("mojo_fn_dist value", fn_dist)
    print_formatter("mojo_fn_dist time (ms)",Float64((eval_end - eval_begin)) / 1e6)
```
In Mojo, fn functions enforce strict type checking and variable declarations. The default behavior of fn is that arguments and return values must contain types and fn arguments are immutable variables. While def allows you to write more dynamic code, fn functions can improve performance by lowering overhead of figuring out data types at runtime and helps you avoid a variety of potential runtime errors.

Results:
=== Mojo Performance with fn, declarations and typing and ===
mojo_fn_dist value: 1291.0881564332019
mojo_fn_dist time (ms): 11.135488
        <-- 33.3 x faster than naive Python implementation

## 12.3 - Matrix multiplication (matmul)
