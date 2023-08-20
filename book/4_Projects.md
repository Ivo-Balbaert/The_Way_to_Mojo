# 4 – Projects

## 4.1 - Calculating the Euclidean distance between two vectors - Parameters and arguments to a generic type
(See [ref](https://www.modular.com/blog/an-easy-introduction-to-mojo-for-python-programmers))

For the algorithm: see the article.
We first write a pure Python implementation, a naive one, and then one using Numpy.  

See `euclid_distance_python.mojo`:
```py
# %%python in .Mojo file ??

%%python
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

%%python
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

// === Pure Python Performance ===
// python_naive_dist value:: 1290.97584
// python_naive_dist time (ms):: 754.38446

%%python
# Numpy's vectorized linalg.norm implementation 
def python_numpy_dist(a,b):
    return np.linalg.norm(a-b)

secs = timeit(lambda: python_numpy_dist(anp,bnp), number=5)/5
print("=== Python+NumPy Performance ===")
print_formatter("python_numpy_dist value:", python_numpy_dist(anp,bnp))
print_formatter("python_numpy_dist time (ms):", 1000*secs)

// === Python+NumPy Performance ===
// python_numpy_dist value:: 1290.97584
// python_numpy_dist time (ms):: 23.18503 
        <--- 32.5 x faster than pure Python
```


See `euclid_distance_mojo.mojo`:
```py
# Create numpy arrays anp and bnp:
from PythonInterface import Python      # import numpy as np
let np = Python.import_module("numpy")
n = 10000000
anp = np.random.rand(n)
bnp = np.random.rand(n)

from Tensor import Tensor
from DType import DType
from Range import range
from SIMD import SIMD
from Math import sqrt
from Time import now

let n: Int = 10_000_000
var a = Tensor[DType.float64](n)
var b = Tensor[DType.float64](n)

for i in range(n):  # assign numpy array values to Mojo Tensor
    a[i] = anp[i].to_float64()
    b[i] = bnp[i].to_float64()
```

The Tensor type declaration has this format:  
`Tensor[DType.float64](n)` 
or in general:            
`Function[parameters](arguments)`

In Mojo *parameters* represent a compile-time value. In this example we’re telling the compiler, Tensor is a container for 64-bit floating point values. And *arguments* in Mojo represent runtime values, in this case we’re passing n=10000000 to Tensor’s constructor to instantiate a 1-dimensional array of 1 million values.

Calculation of Euclid distance:
```py
def mojo_naive_dist(a: Tensor[DType.float64], b: Tensor[DType.float64]) -> Float64:
    var s: Float64 = 0.0
    n = a.num_elements()
    for i in range(n):
        dist = a[i] - b[i]
        s += dist*dist
    return sqrt(s)

let eval_begin = now()
let naive_dist = mojo_naive_dist(a, b)
let eval_end = now()

print_formatter("mojo_naive_dist value", naive_dist)
print_formatter("mojo_naive_dist time (ms)",Float64((eval_end - eval_begin)) / 1e6)
```

Changes to Mojo implementations:
A) def mojo_naive_dist:
- function arguments are typed
- function return value is typed
- local variables declared with either var or let
- local variables typed

Here DType.float64 parameter of our Tensor specifies that it contains 64-bit floating point values. Float64 return type represents a Mojo SIMD type, which is a low-level scalar value on the machine register. We also declare the variable s with the var keyword which tells the Mojo compiler that s is a mutable variable of type Float64.

Results:
    mojo_naive_dist value: 1290.97584
    mojo_naive_dist time (ms): 78.06855
                    <-- 9.7 x faster than naive Python implementation

Speeding up our Mojo code model:
Improvements:
1- def --> fn
As a consequence: - Tensor values are passed by reference so no copies are made
This is now enforced: - Introduce strict typing and declare all variables 

```py
fn mojo_fn_dist(a: Tensor[DType.float64], b: Tensor[DType.float64]) -> Float64:
    var s: Float64 = 0.0
    let n = a.num_elements()
    for i in range(n):
        let dist = a[i] - b[i]
        s += dist*dist
    return sqrt(s)

let eval_begin = now()
let naive_dist = mojo_fn_dist(a, b)
let eval_end = now()

print("=== Mojo Performance with fn, declarations and typing and ===")
print_formatter("mojo_fn_dist value", naive_dist)
print_formatter("mojo_fn_dist time (ms)",Float64((eval_end - eval_begin)) / 1e6)
```
In Mojo, fn functions enforce strict type checking and variable declarations. The default behavior of fn is that arguments and return values must contain types and fn arguments are immutable variables. While def allows you to write more dynamic code, fn functions can improve performance by lowering overhead of figuring out data types at runtime and helps you avoid a variety of potential runtime errors.

Results:
=== Mojo Performance with fn, declarations and typing and ===
mojo_fn_dist value: 1290.97584
mojo_fn_dist time (ms): 13.91595
        <-- 54.2 x faster than naive Python implementation, 1.7 x faster than Numpy implementation