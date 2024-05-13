from benchmark import Benchmark
from sys.intrinsics import strided_load
from utils.list import VariadicList
from math import div_ceil, min
from memory import memset_zero
from memory.unsafe import DTypePointer
from random import rand, random_float64
from sys.info import simdwidthof
from algorithm import vectorize, parallelize

var python_gflops = 0.005430089939864052
alias nelts = simdwidthof[DType.float32]()  # The SIMD vector width.

# Parallelize the code by using the builtin parallelize function
fn matmul_parallelized(C: Matrix, A: Matrix, B: Matrix):
    @parameter
    fn calc_row(m: Int):
        for k in range(A.cols):
            @parameter
            fn dot[nelts : Int](n : Int):
                C.store[nelts](m,n, C.load[nelts](m,n) + A[m,k] * B.load[nelts](k,n))
            vectorize[nelts, dot](C.cols)
        
    parallelize[calc_row](C.rows)

# Matrix type and methods:
struct Matrix:
    var data: DTypePointer[DType.float32]
    var rows: Int
    var cols: Int

    fn __init__(inout self, rows: Int, cols: Int):
        self.data = DTypePointer[DType.float32].alloc(rows * cols)
        rand(self.data, rows * cols)  # 1
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
    fn load[nelts: Int](self, y: Int, x: Int) -> SIMD[DType.float32, nelts]:
        return self.data.simd_load[nelts](y * self.cols + x)

    @always_inline
    fn __setitem__(self, y: Int, x: Int, val: Float32):
        return self.store[1](y, x, val)

    @always_inline
    fn store[nelts: Int](self, y: Int, x: Int, val: SIMD[DType.float32, nelts]):
        self.data.simd_store[nelts](y * self.cols + x, val)

@always_inline
fn benchmark_parallel[
    func: fn (Matrix, Matrix, Matrix) -> None
](M: Int, N: Int, K: Int, python_gflops: Float64):
    var C = Matrix(M, N)
    C.zero()
    var A = Matrix(M, K)
    var B = Matrix(K, N)

    @always_inline
    @parameter
    fn test_fn():
        _ = func(C, A, B)

    var secs = Float64(Benchmark().run[test_fn]()) / 1e9
    print("Mojo seconds: ", secs)
    # Prevent the matrices from being freed before the benchmark run
    _ = (A, B, C)
    var gflops = ((2 * M * N * K) / secs) / 1e9
    var speedup: Float64 = gflops / python_gflops
    # print(gflops, "GFLOP/s", speedup, " speedup")
    print(gflops, "GFLOP/s, a", speedup.value, "x speedup over Python")

fn main() raises:
    benchmark_parallel[matmul_parallelized](512, 512, 512, python_gflops)


# =>
# $ mojo matmul5.mojo
# 512 x 512:
# 109.72416682574026 GFLOP/s, a 20206.694187552872 x speedup over Python
