import benchmark
from sys.intrinsics import strided_load
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
    var value = object([])
    return object(
        Attr("value", value),
        Attr("__getitem__", matrix_getitem),
        Attr("__setitem__", matrix_setitem),
        Attr("rows", rows),
        Attr("cols", cols),
        Attr("append", matrix_append),
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

    var secs = Float64(benchmark.run[test_fn]()) / 1e9
    print("Mojo seconds: ", secs)
    _ = (A, B, C)
    var gflops = ((2 * M * N * K) / secs) / 1e9
    var speedup: Float64 = gflops / python_gflops
    print(gflops, "GFLOP/s, a", speedup.value, "x speedup over Python")


fn main() raises:
    var python_gflops = 0.005356575518265889
    _ = benchmark_matmul_untyped(512, 512, 512, python_gflops)


# => for 128:
# $ mojo matmul1.mojo
# 0.016238353827774884 GFLOP/s, a 3.0314804248352698 x speedup over Python
# => for 512:

