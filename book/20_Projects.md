# 20 – Projects

## 20.1 - Calculating the sum of two vectors
See https://codeconfessions.substack.com/p/mojo-the-future-of-ai-programming
(code is image!)
TODO!

## 20.2 - Calculating the Euclidean distance between two vectors
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


## 20.3 - Matrix multiplication (matmul)
See:
* https://docs.modular.com/mojo/notebooks/Matmul.html
* https://www.modular.com/blog/ais-compute-fragmentation-what-matrix-multiplication-teaches-us

### 20.3.1 - Naive Python implementation

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

### 20.3.2 - Importing the Python implementation to Mojo
(3 x speedup)

STEPS:  
1- Define the equivalent imports from the Mojo standard library
2- Define the Matrix type: here defined in terms of object
3- The algorithm code (`def matmul_untyped`) is exactly the same as in the Python implementation from § 20.3.1

See `matmul1.mojo`:
```mojo
from benchmark import Benchmark
from sys.intrinsics import strided_load
from utils.list import VariadicList
from math import div_ceil, min
from memory import memset_zero
from memory.unsafe import DTypePointer
from random import rand, random_float64
from sys.info import simdwidthof
from runtime.llcl import Runtime

# This exactly the same Python implementation, but is in fact Mojo code!
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
    let value = object([])
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

    let secs = Float64(Benchmark().run[test_fn]()) / 1_000_000_000
    _ = (A, B, C)
    let gflops = ((2*M*N*K)/secs) / 1e9
    let speedup : Float64 = gflops / python_gflops
    print(gflops, "GFLOP/s, a", speedup.value, "x speedup over Python")

fn main() raises:
    let python_gflops = 0.005356575518265889
    _ = benchmark_matmul_untyped(128, 128, 128, python_gflops)
```

Running the program with `mojo matmul1.mojo` gives the output:  
```
0.016238353827774884 GFLOP/s, a 3.0314804248352698 x speedup over Python
```

### 20.3.3 - Adding types to the implementation
( 1330 x speedup)

The Matrix typing in our previous version was very 'untyped', using the very general 'object' (see §§) type to define it. By adding more precise type definitions and info, Mojo let's you gain a lot of performance. 

STEPS: 
1- Define a Matrix struct.
2- Define a `fn matmul_naive`, which has the same body code as the Python implementation, but it is a fn, so the arguments and return value are typed. 
3- Define a helper function benchmark.

See `matmul2.mojo`:
```mojo
from benchmark import Benchmark
from sys.intrinsics import strided_load
from utils.list import VariadicList
from math import div_ceil, min
from memory import memset_zero
from memory.unsafe import DTypePointer
from random import rand, random_float64
from sys.info import simdwidthof
from runtime.llcl import Runtime

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

    let secs = Float64(Benchmark().run[test_fn]()) / 1_000_000_000
    # Prevent the matrices from being freed before the benchmark run
    _ = (A, B, C)
    let gflops = ((2 * M * N * K) / secs) / 1e9
    let speedup: Float64 = gflops / python_gflops
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

### 20.3.4 - Vectorizing the inner most loop
Mojo has SIMD vector types to vectorize the `Matmul` code. In `fn matmul_vectorized` we use the SIMD store and load instructions.

#### 20.3.4.1 - Vectorizing the inner most loop
( 8894 x speedup)

STEPS:  
1- Replace fn matmul_naive by fn matmul_vectorized_0

See `matmul3.mojo`:
```mojo
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

#### 20.3.4.2 - Using the Mojo vectorize function
Vectorization is a common optimization, and Mojo provides a higher-order function `vectorize` that performs vectorization for you. The vectorize function takes a vector width and a function which is parametric on the vector width and is going to be evaluated in a vectorized manner.
( 6409 x speedup)

STEPS:  
1- Import the vectorize function
2- Replace fn matmul_naive by fn matmul_vectorized_1

See `matmul4.mojo`:
```mojo
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

### 20.3.5 - Parallelizing Matmul
( 20206 x speedup)

To get the best performance from modern processors, one has to utilize the multiple cores they have.

STEPS:  
1- Replace the benchmark function by benchmark_parallel:  
For parallel code, we need to introduce a benchmark function that shares the threadpool, otherwise it introduces latency creating a new runtime on every iteration of the benchmark. You can see this bellow in `with Runtime() as rt`.
2- Replace fn matmul_vectorized_1 by matmul_parallelized: modify the matmul implementation and make it multi-threaded by using the builtin parallelize function(for simplicity, we only parallelize on the M dimension):

See `matmul5.mojo`:
```mojo
fn matmul_parallelized(C: Matrix, A: Matrix, B: Matrix, rt: Runtime):
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

### 20.3.6 - Tiling Matmul
Tiling is an optimization performed for matmul to increase cache locality. The idea is to keep sub-matrices resident in the cache and increase the reuse
( 18346 x speedup)

STEPS:  
1- Import the tiling function from Mojo stdlib
2- Define a `tile` function
3- Replace the matmul function by `fn matmul_tiled_parallelized`

```mojo
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
```mojo
# Use the above tile function to perform tiled matmul.
fn matmul_tiled_parallelized(C: Matrix, A: Matrix, B: Matrix, rt: Runtime):
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

    parallelize[calc_row](rt, C.rows)
```

Running this version gives:
`99.61793034345834 GFLOP/s, a 18345.539658953123 x speedup over Python`

### 20.3.7 - Unrolling the loops introduced by vectorize of the dot function
( 20364 x speedup)
We can do this via the vectorize_unroll higher-order function.

STEPS:  
1- Import the vectorize_unrol function from Mojo stdlib
2- Replace the matmul_tiled_parallelized function by `matmul_tiled_unrolled_parallelized`
See `matmul7.mojo`.

Running this version gives:
`110.57583948683771 GFLOP/s, a 20363.537383619485 x speedup over Python`

### 20.3.8 - Searching for the tile_factor
( 21755 x speedup)
The choice of the tile factor can greatly impact the performace of the full matmul, but the optimal tile factor is highly hardware-dependent, and is influenced by the cache configuration and other hard-to-model effects. We want to write portable code without having to know everything about the hardware, so we can ask Mojo to automatically select the best tile factor using autotuning.
This will generate multiple candidates for the matmul function. To teach Mojo how to find the best tile factor, we provide an evaluator function Mojo can use to assess each candidate.

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

All optimization methods (except autotune) are combined in matmul.mojo


## 20.4 - Computing the Mandelbrot set
See Mojo blog:
* https://www.modular.com/blog/how-mojo-gets-a-35-000x-speedup-over-python-part-1



