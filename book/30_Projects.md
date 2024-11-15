# 30 – Projects
## 30.1 - Calculating PI
Let's compare Python vs Mojo calculating PI 100 million iterations each.
First we time a Python version:

See `pi.py`:
```py
import timeit

def calculate_pi(terms):
    pi = 0
    for i in range(terms):
        term = ((-1) ** i) / (2 * i + 1)
        pi += term
    pi *= 4
    return pi

def main():
    secs = timeit.timeit(lambda: calculate_pi(100000000), number = 1)
    print("Python seconds: ", secs)

if __name__ == "__main__":
    main()

# => Python seconds:  21.432497895002598
```

The Mojo version:

See pi.mojo
```py
from time import now

fn calculate_pi(terms: Int) -> Float64:
    var pi: Float64 = 0
    var temp: Float64 = 0
    for i in range(terms):
        temp = ((-1) ** i) / (2 * i + 1)
        pi += temp
    pi *= 4
    return pi

fn main():
    var start = now()     # 2
    print(calculate_pi(100000000))
    var calc_time = now() - start
    print("Mojo pi2 Calculates PI in ", calc_time/1e9, " seconds")

# => 3.141592643589326
# => Mojo pi2 Calculates PI in  1.1377551939999999  seconds
```
The only difference is that we used fn functions in the Mojo version, so all variables have to be declared with var, and given a type. Mojo runs 19.5 x faster than Python.

## 30.3 - Implementing the prefix-sum algorithm   <--
See https://mzaks.medium.com/faster-prefix-sum-computation-with-simd-and-mojo-39bdc25e49b3
https://github.com/mzaks/mojo-prefix-sum

This algoritm is also known as `cumulative sum over a list` (cumsum in numpy): 
iterate over a list, and for each element:
    add the previous element to the current element, changing the list in place.

In Python code, this would be:
```py
for i in range(1, len(lst)):
    lst[i] += lst[i-1]
``` 

### 30.3.1 - Python version
See `prefix_sum.py`:
```py
from time import time_ns

list = [1] * 10_000   # a Python list
# print(list) # for 10 elements: [1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
tik = time_ns()
for i in range(1, len(list)):
    list[i] += list[i - 1]
tok = time_ns()
# print(list) # for 10 elements: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
print(f"Time spent per element: {(tok - tik) / len(list)} ns")
# => Time spent per element: 67.5547 ns
```

In pure Python, averaged over 100 rounds (see prefix_sum_avg.py), the time spent per element is: *67.59 ns*

### 30.3.2 - Using numpy cumsum over a Python list
See `prefix_sum2.py`:
```py
from time import time_ns
import numpy as np

list = np.full(10_000, 1)
tik = time_ns()
list = np.cumsum(list)
tok = time_ns()
print(f"Time spent per element: {(tok - tik) / len(list)} ns")
# Time spent per element: 1.640012000000001 ns
```

In numpy and averaged over 100 rounds (see prefix_sum2_avg.py), the time spent per element is:  *1.68 ns*, which is 40.2 times faster than pure Python.

### 30.3.3 - Mojo version
Here is the code in Mojo, see `prefix_sum.mojo`:
```py
from time import now

fn main():
    var list = List[Int](capacity = 10_000)
    for _ in range(10_000):
        list.append(1)
    var tik = now()
    for i in range(1, len(list)):
        list[i] += list[i - 1]
    var tok = now()
    print("Time spent per element:", (tok - tik) / len(list), "ns")
    # => Time spent per element: 0.22500000000000001 ns
```

The time spent per element (averaged over 100 rounds) is : 
*0.21 ns*, which is **322x** faster than pure Python, and **8x** faster than numpy!

> Note: A simple comparison with Rust (prefix_sum.rs) suggests Mojo is about **12x** faster than Rust, when running: rustc -O prefix_sum.rs


## 30.4 - Calculating the Euclidean distance between two vectors
(See [ref](https://www.modular.com/blog/an-easy-introduction-to-mojo-for-python-programmers))

For the algorithm: see the article.
We first write a pure Python implementation, a naive one, and then one using numpy. :

### 30.3.1 - Python and Numpy version
See `euclid_distance.py`:
```py
import time
import numpy as np
from math import sqrt
from timeit import timeit

n = 10_000_000
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
#        <--- 30.0 x faster than pure Python
```

Run it as `python3 euclid_distance.py` to compare the performance between pure Python and numpy.

### 30.3.2 - Simple Mojo version
The Tensor parametric type declaration has this format:  `Tensor[DType.float64](n)` 
In Mojo *parameters* represent a compile-time value. In this example we're telling the compiler, Tensor is a container for 64-bit floating point values. And *arguments* in Mojo represent runtime values, in this case we're passing n=10_000_000 to Tensor's constructor to instantiate a 1-dimensional array of 10 million values.

Calculation of Euclid distance:
See `euclid_distance.mojo`:
```py
# Create numpy arrays anp and bnp:
from python import Python      
from tensor import Tensor
from math import sqrt
from time import now

alias dtype = DType.float64

fn mojo_fn_dist(a: Tensor[dtype], b: Tensor[dtype]) -> Float64:
    var s: Float64 = 0.0
    var n = a.num_elements()
    for i in range(n):
        var dist = a[i] - b[i]
        s += dist*dist
    return sqrt(s)

fn print_formatter(string: String, value: Float64):
    print(string, end="")
    print(value)

fn main() raises:
    var np = Python.import_module("numpy")
    var n = 10_000_000
    var anp = np.random.rand(n)
    var bnp = np.random.rand(n)

    var a = Tensor[dtype](n)
    var b = Tensor[dtype](n)

    for i in range(n):
        a[i] = anp[i].to_float64()
        b[i] = bnp[i].to_float64()

    var eval_begin = now()
    var fn_dist = mojo_fn_dist(a, b)
    var eval_end = now()

    print_formatter("mojo_fn_dist value: ", fn_dist)
    print_formatter("mojo_fn_dist time (ms): ",Float64((eval_end - eval_begin)) / 1e6)

# mojo_fn_dist value: 1290.742319614782
# mojo_fn_dist time (ms): 10.321598
```
Changes compared to Python version:
- mojo_fn_dist:  is a fn type of function
- function arguments are typed  
- function return value is typed
- local variables declared with var
- local variables typed  

Here the DType.float64 parameter of our Tensor specifies that it contains 64-bit floating point values. Float64 return type represents a Mojo SIMD type, which is a low-level scalar value on the machine register. We also declare the variable s with the var keyword which tells the Mojo compiler that s is a mutable variable of type Float64.

As a consequence: Tensor values are passed by reference so no copies are made.
Strict typing and declaring all variables is now enforced.

In Mojo, fn functions enforce strict type checking and variable declarations. The default behavior of fn is that arguments and return values must contain types and fn arguments are immutable variables. While def allows you to write more dynamic code, fn functions can improve performance by lowering overhead of figuring out data types at runtime and helps you avoid a variety of potential runtime errors.

Results:
=== Mojo Performance with fn, declarations and typing and ===
mojo_fn_dist value: 1290.8755321242613
mojo_fn_dist time (ms): 10.629162000000001
        <-- 33.3 x faster than naive Python implementation and 1.74 x faster than numpy

### 30.3.3 - Accelerating Mojo code with vectorization
Modern CPU cores have dedicated vector register that can perform calculations simultaneously on fixed length vector data. For example an Intel CPU with AVX 512 has 512-bit vector register, therefore we have `512/64=8` Float64 elements on which we can simultaneously perform calculations. This is referred to as `SIMD = Single Instruction Multiple Data`. The theoretical speed up is 8x but in practice it'll be lower due to memory reads/writes latency.

Note: SIMD should not be confused with parallel processing with multiple cores/threads. Each core has dedicated SIMD vector units and we can take advantage of both SIMD and parallel processing to see massive speedup as you'll see in the next §.

First, let's gather the `simd_width` for the specific `dtype` on the specific CPU you'll be running this on.  
To vectorize our naive `mojo_dist` function, we'll write a closure that is parameterized on `simd_width`. Rather than operate on individual elements, we'll work with `simd_width` number of elements, which gives us speed ups. You can access `simd_width` elements using `simd_load`.

See `euclid_distance2.mojo`
```py
# Create numpy arrays anp and bnp:
from python import Python
from tensor import Tensor
from math import sqrt
from time import now
from sys.info import simdwidthof
from algorithm import vectorize

alias dtype = DType.float64
alias simd_width = simdwidthof[dtype]()

fn print_formatter(string: String, value: Float64):
    print_no_newline(string)
    print(value)

fn mojo_dist_vectorized(a: Tensor[dtype], b: Tensor[dtype]) -> Float64:
    var sq_dist: Float64 = 0.0

    @parameter
    fn simd_norm[simd_width: Int](idx: Int):
        var diff = a.load[width=simd_width](idx) - b.load[width=simd_width](idx)
        sq_dist += (diff * diff).reduce_add()

    vectorize[simd_norm, simd_width](a.num_elements())
    return sqrt(sq_dist)


fn main() raises:
    print("simdwidth:", simd_width)
    var np = Python.import_module("numpy")
    var n = 10_000_000
    var anp = np.random.rand(n)
    var bnp = np.random.rand(n)

    var arr1_tensor = Tensor[dtype](n)
    var arr2_tensor = Tensor[dtype](n)

    for i in range(n):
        arr1_tensor[i] = anp[i].to_float64()
        arr2_tensor[i] = bnp[i].to_float64()

    var eval_begin = now()
    var mojo_arr_vec_sum = mojo_dist_vectorized(arr1_tensor, arr2_tensor)
    var eval_end = now()

    print_formatter("mojo_vectorized_dist value: ", mojo_arr_vec_sum)
    print_formatter("mojo_fn_vectorized time (ms): ",Float64((eval_end - eval_begin)) / 1e6)

# simdwidth: 4
# mojo_vectorized_dist value: 1291.0948987587576
# mojo_fn_vectorized time (ms): 6.7728580000000003
```

This is 55x faster than the Python version and 2.87 x faster than numpy


## 30.4 - Matrix multiplication (matmul)
See:
* https://docs.modular.com/mojo/notebooks/Matmul.html
* https://www.modular.com/blog/ais-compute-fragmentation-what-matrix-multiplication-teaches-us

See matmul.mojo (+ chec_mod.pi / pymatmul.py) for the most recent version!

!! matmul1-7.mojo were NOT adapted to >= v 0.5.0 

### 30.4.1 - Naive Python implementation

See `matmul.py`:
```py
# ===----------------------------------------------------------------------=== #
# Copyright (c) 2023, Modular Inc. All rights reserved.
#
# Licensed under the Apache License v2.0 with LLVM Exceptions:
# https://llvm.org/LICENSE.txt
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ===----------------------------------------------------------------------=== #

# Simple program demonstrating a naive matrix multiplication in Python

import importlib
import sys
import subprocess

if not importlib.find_loader("numpy"):
    print("Numpy not found, installing...")
    subprocess.check_call([sys.executable, "-m", "pip", "install", "numpy"])

import numpy as np
from timeit import timeit

class PyMatrix:
    def __init__(self, value, rows, cols):
        self.value = value
        self.rows = rows
        self.cols = cols

    def __getitem__(self, idxs):
        return self.value[idxs[0]][idxs[1]]

    def __setitem__(self, idxs, value):
        self.value[idxs[0]][idxs[1]] = value

def matmul_python(C, A, B):
    for m in range(C.rows):
        for k in range(A.cols):
            for n in range(C.cols):
                C[m, n] += A[m, k] * B[k, n]

def benchmark_matmul_python(M, N, K):
    A = PyMatrix(list(np.random.rand(M, K)), M, K)
    B = PyMatrix(list(np.random.rand(K, N)), K, N)
    C = PyMatrix(list(np.zeros((M, N))), M, N)
    secs = timeit(lambda: matmul_python(C, A, B), number=2) / 2
    print("Python seconds: ", secs)
    gflops = ((2 * M * N * K) / secs) / 1e9
    print(gflops, "GFLOP/s")
    return gflops

if __name__ == "__main__":
    print("Throughput of a 128x128 matrix multiplication in Python:")
    benchmark_matmul_python(128, 128, 128)
```

Execute this program with: `python3 matmul.py`.
The output is:
```
Throughput of a 128x128 matrix multiplication in Python:
0.005356575518265889 GFLOP/s
```

### 30.4.2 - Importing the Python implementation to Mojo
(3 x speedup)

STEPS:  
1- Define the equivalent imports from the Mojo standard library
2- Define the Matrix type: here defined in terms of object
3- The algorithm code (`def matmul_untyped`) is exactly the same as in the Python implementation from § 30.4.1

See `matmul1.mojo`:
```py
import benchmark
from sys.intrinsics import strided_load
from math import div_ceil, min
from memory import memset_zero
from memory.unsafe import DTypePointer
from random import rand, random_float64
from sys.info import simdwidthof

# This is exactly the same code as the Python implementation, but it is in fact Mojo code!
def matmul_untyped(C, A, B):
    for m in range(C.rows):
        for k in range(A.cols):
            for n in range(C.cols):
                C[m, n] += A[m, k] * B[k, n]

# Matrix functions and type:
fn matrix_getitem(self: object, i: object) raises -> object:
    return self.value[i]

fn matrix_setitem(self: object, i: object, value: object) raises -> object:
    self.value[i] = value
    return None

fn matrix_append(self: object, value: object) raises -> object:
    self.value.append(value)
    return None

fn matrix_init(rows: Int, cols: Int) raises -> object:
   varvalue = object([])
    return object(
        Attr("value", value), Attr("__getitem__", matrix_getitem), Attr("__setitem__", matrix_setitem), 
        Attr("rows", rows), Attr("cols", cols), Attr("append", matrix_append),
    )

def benchmark_matmul_untyped(M: Int, N: Int, K: Int, python_gflops: Float64):
    C = matrix_init(M, N)
    A = matrix_init(M, K)
    B = matrix_init(K, N)
    for i in range(M):
        c_row = object([])
        b_row = object([])
        a_row = object([])
        for j in range(N):
            c_row.append(0.0)
            b_row.append(random_float64(-5, 5))
            a_row.append(random_float64(-5, 5))
        C.append(c_row)
        B.append(b_row)
        A.append(a_row)

    @parameter  # this makes test_fn capture C, A and B
    fn test_fn():
        try:
            _ = matmul_untyped(C, A, B)
        except:
            pass

    var secs = Float64(Benchmark().run[test_fn]()) / 1e9
    print("Mojo seconds: ", secs)
    _ = (A, B, C)
   var gflops = ((2*M*N*K)/secs) / 1e9
   var speedup : Float64 = gflops / python_gflops
    print(gflops, "GFLOP/s, a", speedup.value, "x speedup over Python")

fn main() raises:
   var python_gflops = 0.005356575518265889
    _ = benchmark_matmul_untyped(128, 128, 128, python_gflops)
```

Running the program with `mojo matmul1.mojo` gives the output:  
```
0.016238353827774884 GFLOP/s, a 3.0314804248352698 x speedup over Python
```

### 30.4.3 - Adding types to the implementation
( 1330 x speedup)

The Matrix typing in our previous version was very 'untyped', using the very general 'object' (see §§) type to define it. By adding more precise type definitions and info, Mojo let's you gain a lot of performance. 

STEPS: 
1- Define a Matrix struct.
2- Define a `fn matmul_naive`, which has the same body code as the Python implementation, but it is a fn, so the arguments and return value are typed. 
3- Define a helper function benchmark.

See `matmul2.mojo`:
```py
import benchmark
from sys.intrinsics import strided_load
from utils.list import VariadicList
from math import div_ceil, min
from memory import memset_zero
from memory.unsafe import DTypePointer
from random import rand, random_float64
from sys.info import simdwidthof

let python_gflops = 0.005356575518265889

# Note that C, A, and B have types.
fn matmul_naive(C: Matrix, A: Matrix, B: Matrix):
    for m in range(C.rows):
        for k in range(A.cols):
            for n in range(C.cols):
                C[m, n] += A[m, k] * B[k, n]

# Matrix type and methods:
struct Matrix:
    var data: DTypePointer[DType.float32]
    var rows: Int
    var cols: Int

    fn __init__(inout self, rows: Int, cols: Int):
        self.data = DTypePointer[DType.float32].alloc(rows * cols)
        rand(self.data, rows*cols)  # 1
        self.rows = rows
        self.cols = cols

    fn __del__(owned self):
        self.data.free()

    fn zero(inout self):
        memset_zero(self.data, self.rows * self.cols)

    @always_inline
    fn __getitem__(self, y: Int, x: Int) -> Float32:
        return self.load[1](y, x)

    @always_inline
    fn load[nelts:Int](self, y: Int, x: Int) -> SIMD[DType.float32, nelts]:
        return self.data.simd_load[nelts](y * self.cols + x)

    @always_inline
    fn __setitem__(self, y: Int, x: Int, val: Float32):
        return self.store[1](y, x, val)

    @always_inline
    fn store[nelts:Int](self, y: Int, x: Int, val: SIMD[DType.float32, nelts]):
        self.data.simd_store[nelts](y * self.cols + x, val)

@always_inline
fn benchmark[
    func: fn (Matrix, Matrix, Matrix) -> None
](M: Int, N: Int, K: Int, base_gflops: Float64):
    var C = Matrix(M, N)
    C.zero()
    var A = Matrix(M, K)
    var B = Matrix(K, N)

    @always_inline
    @parameter
    fn test_fn():
        _ = func(C, A, B)

   var secs = Float64(Benchmark().run[test_fn]()) / 1_000_000_000
    # Prevent the matrices from being freed before the benchmark run
    _ = (A, B, C)
   var gflops = ((2 * M * N * K) / secs) / 1e9
   var speedup: Float64 = gflops / python_gflops
    print(gflops, "GFLOP/s, a", speedup.value, "x speedup over Python")

fn main() raises:
    # benchmark[matmul_naive](128, 128, 128, python_gflops)
    benchmark[matmul_naive](512, 512, 512, python_gflops)

# =>
# $ mojo matmul2.mojo
# 6.3538315644683863 GFLOP/s, a 1186.1741784096687 x speedup over Python
```

In line 1, the memory of the matrix (pointed to by self.data) is filled with random values from a uniform distribution.
Note that `@always_inline` is used for many functions.

Running the program with `mojo matmul2.mojo` gives the output:  
```
6.3538315644683863 GFLOP/s, a 1186.1741784096687 x speedup over Python
```

Let's test this with 512 x 512 matrices:  
```
Throughput of a 512x512 matrix multiplication in Python:
0.005430089939864052 GFLOP/s
Mojo version 2:
7.2225232674307751 GFLOP/s, a 1330.0927512098629 x speedup over Python
```

### 30.4.4 - Vectorizing the inner most loop
Mojo has SIMD vector types to vectorize the `Matmul` code. In `fn matmul_vectorized` we use the SIMD store and load instructions.

#### 30.4.4.1 - Vectorizing the inner most loop
( 8894 x speedup)

STEPS:  
1- Replace fn matmul_naive by fn matmul_vectorized_0

See `matmul3.mojo`:
```py
fn matmul_vectorized_0(C: Matrix, A: Matrix, B: Matrix):
    for m in range(C.rows):
        for k in range(A.cols):
            for nv in range(0, C.cols, nelts):
                C.store[nelts](m,nv, C.load[nelts](m,nv) + A[m,k] * B.load[nelts](k,nv))
        
            # Handle remaining elements with scalars.
            for n in range(nelts*(C.cols//nelts), C.cols):
                C[m,n] += A[m,k] * B[k,n]
```

Running the program with `mojo matmul3.mojo` gives the output:  
```
48.292430693593872 GFLOP/s, a 8893.4863378713981 x speedup over Python
```

#### 30.4.4.2 - Using the Mojo vectorize function
Vectorization is a common optimization, and Mojo provides a higher-order function `vectorize` that performs vectorization for you. The vectorize function takes a function and a vector width,  which is parametric on the vector width and is going to be evaluated in a vectorized manner.
( 6409 x speedup)

STEPS:  
1- Import the vectorize function
2- Replace fn matmul_naive by fn matmul_vectorized_1

See `matmul4.mojo`:
```py
# Simplify the code by using the builtin vectorize function
from algorithm import vectorize
fn matmul_vectorized_1(C: Matrix, A: Matrix, B: Matrix):
    for m in range(C.rows):
        for k in range(A.cols):
            @parameter
            fn dot[nelts : Int](n : Int):
                C.store[nelts](m,n, C.load[nelts](m,n) + A[m,k] * B.load[nelts](k,n))
            vectorize[nelts, dot](C.cols)
```

Running the program with `mojo matmul4.mojo` gives the output:  
```
34.802488386333351 GFLOP/s, a 6409.1918866457427 x speedup over Python
```

### 30.4.5 - Parallelizing Matmul
( 20206 x speedup)

To get the best performance from modern processors, one has to utilize the multiple cores they have.

STEPS:  
1- Replace the benchmark function by benchmark_parallel:  
For parallel code, we need to introduce a benchmark function that shares the threadpool. The parallelize function caches the Mojo parallel runtime.

2- Replace fn matmul_vectorized_1 by matmul_parallelized: modify the matmul implementation and make it multi-threaded by using the builtin parallelize function(for simplicity, we only parallelize on the M dimension):

See `matmul5.mojo`:
```py
fn matmul_parallelized(C: Matrix, A: Matrix, B: Matrix):
    @parameter
    fn calc_row(m: Int):
        for k in range(A.cols):
            @parameter
            fn dot[nelts : Int](n : Int):
                C.store[nelts](m,n, C.load[nelts](m,n) + A[m,k] * B.load[nelts](k,n))
            vectorize[nelts, dot](C.cols)
        
    parallelize[calc_row](rt, C.rows)
```

Running this version gives:
`109.72416682574026 GFLOP/s, a 20206.694187552872 x speedup over Python`

### 30.4.6 - Tiling Matmul
Tiling is an optimization performed for matmul to increase cache locality. The idea is to keep sub-matrices resident in the cache and increase the reuse
( 18346 x speedup)

STEPS:  
1- Import the tiling function from Mojo stdlib
2- Define a `tile` function
3- Replace the matmul function by `fn matmul_tiled_parallelized`

```py
# Perform 2D tiling on the iteration space defined by end_x and end_y.
fn tile[tiled_fn: Tile2DFunc, tile_x: Int, tile_y: Int](end_x: Int, end_y: Int):
    # Note: this assumes that ends are multiples of the tiles.
    for y in range(0, end_y, tile_y):
        for x in range(0, end_x, tile_x):
            tiled_fn[tile_x, tile_y](x, y)
```

The above will perform 2 dimensional tiling over a 2D iteration space defined to be between 
((0,endx), (0, endy)). Once we define it above, we can use it within our matmul kernel. For simplicity we choose 4 as the tile height and since we also want to vectorize we use 4 * nelts as the tile width (since we vectorize on the columns).  

See `matmul6.mojo`:
```py
# Use the above tile function to perform tiled matmul.
fn matmul_tiled_parallelized(C: Matrix, A: Matrix, B: Matrix):
    @parameter
    fn calc_row(m: Int):
        @parameter
        fn calc_tile[tile_x: Int, tile_y: Int](x: Int, y: Int):
            for k in range(y, y + tile_y):
                @parameter
                fn dot[nelts : Int,](n : Int):
                    C.store[nelts](m,n + x, C.load[nelts](m,n+x) + A[m,k] * B.load[nelts](k,n+x))
                vectorize[nelts, dot](tile_x)

        # We hardcode the tile factor to be 4.
        alias tile_size = 4
        tile[calc_tile, nelts * tile_size, tile_size](A.cols, C.cols)

    parallelize[calc_row](C.rows)
```

Running this version gives:
`99.61793034345834 GFLOP/s, a 18345.539658953123 x speedup over Python`

### 30.4.7 - Unrolling the loops introduced by vectorize of the dot function
( 20364 x speedup)
We can do this via the vectorize_unroll higher-order function.

STEPS:  
1- Import the vectorize_unrol function from Mojo stdlib
2- Replace the matmul_tiled_parallelized function by `matmul_tiled_unrolled_parallelized`
See `matmul7.mojo`.

Running this version gives:
`110.57583948683771 GFLOP/s, a 20363.537383619485 x speedup over Python`

### 30.4.8 - Searching for the tile_factor
( 21755 x speedup)
The choice of the tile factor can greatly impact the performace of the full matmul, but the optimal tile factor is highly hardware-dependent, and is influenced by the cache configuration and other hard-to-model effects. We want to write portable code without having to know everything about the hardware, so we can ask Mojo to automatically select the best tile factor using autotuning.
This will generate multiple candidates for the matmul function. To teach Mojo how to find the best tile factor, we provide an evaluator function Mojo can use to assess each candidate.


==> !! v 0.7: autotuning is being redesigned !!
STEPS:  
1- Import the autotune function from Mojo stdlib
2- Replace the matmul_tiled_unrolled_parallelized function by `matmul_autotune_impl`
3- Add the evaluator function `matmul_evaluator`.
4- Define an entry function `matmul_autotune` that would simply call the best candidate.

See `matmul8.mojo`.

Running this version gives:
```
matmul_evaluator, number of candidates:  6
Optimizing for size: 512 x 512 x 512
Time spent in matmul_evaluator, ms: 8898
Best candidate idx: 0
118.13100247584663 GFLOP/s, a 21754.888737405363 x speedup over Python
```

All optimization methods (except autotune) are combined in matmul.mojo, with results:
# => 2024 May 27
CPU Results

Python:         0.004 GFLOPS
Numpy:        303.271 GFLOPS
Naive:          6.957 GFLOPS   1766.74x Python  0.02x Numpy
Vectorized:    36.163 GFLOPS   9183.00x Python  0.12x Numpy
Parallelized: 131.059 GFLOPS  33280.52x Python  0.43x Numpy
Tiled:        115.317 GFLOPS  29283.09x Python  0.38x Numpy
Unrolled:     119.602 GFLOPS  30371.08x Python  0.39x Numpy
Accumulated:  258.524 GFLOPS  65648.32x Python  0.85x Numpy


## 30.5 - Computing the Mandelbrot set
Video:  https://www.youtube.com/watch?v=wFMB0VSH51M
        
https://docs.modular.com/mojo/notebooks/Mandelbrot.html

See Mojo blog:
* 2023 Aug 18 - https://www.modular.com/blog/how-mojo-gets-a-35-000x-speedup-over-python-part-1
* 2023 Aug 28 - https://www.modular.com/blog/how-mojo-gets-a-35-000x-speedup-over-python-part-2
* 2023 Sep 6 - https://www.modular.com/blog/mojo-a-journey-to-68-000x-speedup-over-python-part-3

See mandelbrot.mojo (v 0.5.0)

mandelbrot0-5.mojo were NOT adapted to >= v 0.5.0 


### 30.5.1 The pure Python algorithm
```py
MAX_ITERS = 1000
def mandelbrot_kernel(c): 
  z = c
  nv = 0
  for i in range(MAX_ITERS):
    if abs(z) > 2:
      break
    z = z*z + c
    nv += 1
  return nv
```
(for the complete program: see `mandelbrot.py`)

Although Python code, (!!) this works unaltered in Mojo! We will gradually port this code to Mojo.
A NumPy implementation is only 5x faster than Python.

### 30.5.2 Adding types in the funtion signature
The first thing we can do is to annotate the def mandelbrot_kernel with types:  
`def mandelbrot_0(c: ComplexFloat64) -> Int:`
The body of the def is unaltered.

See `mandelbrot_0.mojo`:
(23.9 x speedup)
```py
def mandelbrot_kernel_0(c: ComplexFloat64) -> Int:
    z = c
    nv = 0
    for i in range(1, MAX_ITERS):
      if abs(z) > 2:
        break
      z = z*z + c
      nv += 1
    return nv
```

The complete code to run it and display the resulting graph with matplotlib is stored in mojo `mandelbrot_0.mojo`. (in 0.191 seconds) Here is the graph image: !!

### 30.5.3 Changing to an fn function
We can opt into the Mojo "strict" mode, by using fn instead of def and declaring the local variables z and nv. This will enable Mojo to perform more aggressive optimizations since the compiler can discern certain properties about the program. 
(24.2 x speedup)

See `mandelbrot_1.mojo`:
```py
fn mandelbrot_kernel_1(c: ComplexFloat64) -> Int:
    var z = c
    var nv = 0
    for i in range(1, MAX_ITERS):
      if abs(z) > 2:
        break
      z = z*z + c
      nv += 1
    return nv
```

The complete code to run it and display the resulting graph with matplotlib is stored in mojo `mandelbrot_1.mojo`. (Executed in 0.193 seconds)
There is no difference in performance between mandelbrot_0 and  mandelbrot_1. The reason is that Mojo's type inference and optimizations remove the dynamism from the types – allowing one to work with concrete types rather than variants.


### 30.5.4 Simplifying the math to reduce computation
Removing redundant computations:
* avoid the square root in abs, by changing the check of abs(z) > 2 to be squared_norm(z) > 4
(saves 6 flops)
* simplifying the computation of z*z + c (saves 1 flop)

Squared addition is a common operation, and the Mojo standard library provides a special function for it called `squared_add`, which is implemented using FMA instructions for maximum performance.
(89 x speedup)

```py
struct Complex[type: DType]:
    ...
    fn squared_add(self, c: Self) -> Self:
        return Self(
            fma(self.re, self.re, fma(-self.im, self.im, c.re)),
            fma(self.re, 2*self.im, c.im)))
```

Rewriting the mandelbrot function now gives us:
See `mandelbrot2.mojo`:
```py
fn mandelbrot_2(c: ComplexFloat64) -> Int:
    var z = c
    var nv = 0
    for i in range(1, MAX_ITERS):
        if z.squared_norm() > 4:
            break
        z = z.squared_add(c)
        nv += 1
    return nv
```

The complete code to run it and display the resulting graph with matplotlib is stored in mojo `mandelbrot_2.mojo`. (43 x speedup comparing to Python)

### 30.5.5 Adding supporting code
We need some supporting declarations and code to iterate through the pixels in the image and compute the membership in the set:

```py
alias height = 4096
alias width = 4096
alias min_x = -2.0
alias max_x = 0.47
alias min_y = -1.12
alias max_y = 1.12
alias scalex = (max_x - min_x) / width
alias scaley = (max_y - min_y) / height

for h in range(height):
	let cy = min_y + h * scale_y
	for w in range(width):
		let cx = min_x + w * scale_x
		output[h,w] = mandelbrot_N(ComplexFloat64(cx,cy))
```
(in the above code, replace N resp. by 0, 1 and 2)

We also need:  
* def compute_mandelbrot() -> Tensor[float_type]:
* def show_plot(tensor: Tensor[float_type]):
and the starting point:
```py
fn main() raises:
    _ = show_plot(compute_mandelbrot())
```

### 30.5.6 - Vectorizing the code
See `mandelbrot_3.mojo`:
```py
from python import Python
from math import abs, iota
from complex import ComplexSIMD, ComplexFloat64
from tensor import Tensor
from utils.index import Index
import benchmark
from algorithm import vectorize

alias float_type = DType.float64
alias simd_width = 2 * simdwidthof[float_type]()

alias width = 960
alias height = 960
alias MAX_ITERS = 1000

alias min_x = -2.0
alias max_x = 0.6
alias min_y = -1.5
alias max_y = 1.5


# Compute the number of steps to escape.
fn mandelbrot_kernel_SIMD[
    simd_width: Int
](c: ComplexSIMD[float_type, simd_width]) -> SIMD[float_type, simd_width]:
    """A vectorized implementation of the inner mandelbrot computation."""
   varcx = c.re
   varcy = c.im
    var x = SIMD[float_type, simd_width](0)
    var y = SIMD[float_type, simd_width](0)
    var y2 = SIMD[float_type, simd_width](0)
    var iters = SIMD[float_type, simd_width](0)

    var t: SIMD[DType.bool, simd_width] = True
    for i in range(MAX_ITERS):
        if not t.reduce_or():
            break
        y2 = y * y
        y = x.fma(y + y, cy)
        t = x.fma(x, y2) <= 4
        x = x.fma(x, cx - y2)
        iters = t.select(iters + 1, iters)
    return iters


fn vectorized():
    var t = Tensor[float_type](height, width)

    @parameter
    fn worker(row: Int):
        var scale_x = (max_x - min_x) / width
        var scale_y = (max_y - min_y) / height

        @parameter
        fn compute_vector[simd_width: Int](col: Int):
            """Each time we oeprate on a `simd_width` vector of pixels."""
            var cx = min_x + (col + iota[float_type, simd_width]()) * scale_x
            var cy = min_y + row * scale_y
            var c = ComplexSIMD[float_type, simd_width](cx, cy)
            t.data().simd_store[simd_width](
                row * width + col, mandelbrot_kernel_SIMD[simd_width](c)
            )

        # Vectorize the call to compute_vector where call gets a chunk of pixels.
        vectorize[simd_width, compute_vector](width)

    @parameter
    fn bench[simd_width: Int]():
        for row in range(height):
            worker(row)

    var vectorized = Benchmark().run[bench[simd_width]]() / 1e6
    print("Vectorized", ":", vectorized, "ms")

    try:
        _ = show_plot(t)
    except e:
        print("failed to show plot:", e)

def show_plot(tensor: Tensor[float_type]):
    alias scale = 10
    alias dpi = 64

    np = Python.import_module("numpy")
    plt = Python.import_module("matplotlib.pyplot")
    colors = Python.import_module("matplotlib.colors")

    numpy_array = np.zeros((height, width), np.float64)

    for row in range(height):
        for col in range(width):
            numpy_array.itemset((col, row), tensor[col, row])

    fig = plt.figure(1, [scale, scale * height // width], dpi)
    ax = fig.add_axes([0.0, 0.0, 1.0, 1.0], False, 1)
    light = colors.LightSource(315, 10, 0, 1, 1, 0)

    image = light.shade(
        numpy_array, plt.cm.hot, colors.PowerNorm(0.3), "hsv", 0, 0, 1.5
    )
    plt.imshow(image)
    plt.axis("off")
    plt.show()


fn main() raises:
   varpython_secs = 11.530147033001413
    vectorized()
```

The output is: `Vectorized : 56.717956000000001 ms`
so a 4.7 x speedup regarding to mandelbrot2.

### 30.5.7 - Parallelizing the code
See `mandelbrot_4.mojo`.

The results are:  
```
 Number of threads: 12
 Vectorized: 12.647498000000001 ms
 Parallelized: 1.7074240000000001 ms
 Parallel speedup: 7.4073563449969075, 6743 x faster than Python version.
```

Blog article 3 introduces a *partition factor* to alleviate load imbalance among the cores:  
`parallelize[compute_row](rt, height, partition_factor * num_cores())`
which adds a 2.3x speedup (see `mandelbrot_5.mojo`).
On my system, this achieves a small speedup, to 1.5 ms.

# => 2024 May 29
ivo@megaverse:~/mojo/test$ python3 mandelbrot.py
Throughput of mandelbrot in Python:
11.483757219495601  secs
1.14837572194956e-08 GFLOP/s
1.14837572194956e-08
ivo@megaverse:~/mojo/test$ mojo mandelbrot.mojo
Number of threads: 12
Vectorized: 0.013087794315217392 s
Parallelized: 0.0027542937819025524 s
Parallel speedup: 4.7517786233307637