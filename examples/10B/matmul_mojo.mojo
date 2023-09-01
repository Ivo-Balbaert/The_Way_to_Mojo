# doesn't work!
# ok in Jupyter notebook, not in file
from benchmark import Benchmark
from sys.intrinsics import strided_load
from utils.list import VariadicList
from math import div_ceil, min
from memory import memset_zero
from memory.unsafe import DTypePointer
from random import rand, random_float64
from sys.info import simdwidthof

struct Matrix:
    var data: DTypePointer[DType.float32]
    var rows: Int
    var cols: Int

    fn __init__(inout self, rows: Int, cols: Int):
        self.data = DTypePointer[DType.float32].alloc(rows * cols)
        rand(self.data, rows*cols)
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


# This exactly the same Python implementation, 
# but is infact Mojo code!
# def matmul_untyped(C, A, B):
#     for m in range(C.rows):
#         for k in range(A.cols):
#             for n in range(C.cols):
#                 C[m, n] += A[m, k] * B[k, n]

# Note that C, A, and B have types.
fn matmul_naive(C: Matrix, A: Matrix, B: Matrix):
    for m in range(C.rows):
        for k in range(A.cols):
            for n in range(C.cols):
                C[m, n] += A[m, k] * B[k, n]

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

# def benchmark_matmul_untyped(M: Int, N: Int, K: Int, python_gflops: Float64):
#     C = matrix_init(M, N)
#     A = matrix_init(M, K)
#     B = matrix_init(K, N)
#     for i in range(M):
#         c_row = object([])
#         b_row = object([])
#         a_row = object([])
#         for j in range(N):
#             c_row.append(0.0)
#             b_row.append(random_float64(-5, 5))
#             a_row.append(random_float64(-5, 5))
#         C.append(c_row)
#         B.append(b_row)
#         A.append(a_row)

@parameter
fn test_fn():
        try:
            _ = matmul_untyped(C, A, B)
        except:
            pass

@always_inline
def benchmark[func : fn(Matrix, Matrix, Matrix) -> None]
    (M : Int, N : Int, K : Int, python_gflops: Float64):
    var C = Matrix(M, N)
    C.zero()
    var A = Matrix(M, K)
    var B = Matrix(K, N)

    @always_inline
    @parameter
    fn test_fn():
        _ = func(C, A, B)

fn main():
    let secs = Float64(Benchmark().run[test_fn]()) / 1_000_000_000
    # Prevent matrices from being destroyed before we finished benchmarking them.
    _ = A.data
    _ = B.data
    _ = C.data

    let gflops = ((2*M*N*K)/secs) / 1e9
    let speedup : Float64 = gflops / python_gflops
    print(gflops, "GFLOP/s, a", speedup.value, "x speedup over Python")





    # let secs = Float64(Benchmark().run[test_fn]()) / 1_000_000_000
    # _ = (A, B, C)
    # let gflops = ((2*M*N*K)/secs) / 1e9
    # let speedup : Float64 = gflops / python_gflops
    # print(gflops, "GFLOP/s, a", speedup.value, "x speedup over Python")