from benchmark import Benchmark
from sys.intrinsics import strided_load
from utils.list import VariadicList
from math import div_ceil, min
from memory import memset_zero
from memory.unsafe import DTypePointer
from random import rand, random_float64
from sys.info import simdwidthof
from runtime.llcl import Runtime

let python_gflops = 0.005430089939864052
alias nelts = simdwidthof[DType.float32]()  # The SIMD vector width.


fn matmul_vectorized_0(C: Matrix, A: Matrix, B: Matrix):
    for m in range(C.rows):
        for k in range(A.cols):
            for nv in range(0, C.cols, nelts):
                C.store[nelts](
                    m, nv, C.load[nelts](m, nv) + A[m, k] * B.load[nelts](k, nv)
                )

            # Handle remaining elements with scalars.
            for n in range(nelts * (C.cols // nelts), C.cols):
                C[m, n] += A[m, k] * B[k, n]


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

    let secs = Float64(Benchmark().run[test_fn]()) / 1e9
    print("Mojo seconds: ", secs)
    # Prevent the matrices from being freed before the benchmark run
    _ = (A, B, C)
    let gflops = ((2 * M * N * K) / secs) / 1e9
    let speedup: Float64 = gflops / python_gflops
    print(gflops, "GFLOP/s, a", speedup.value, "x speedup over Python")


fn main() raises:
    benchmark[matmul_vectorized_0](512, 512, 512, python_gflops)


# =>
# $ mojo matmul3.mojo
# 512 x 512:
# 7.2225232674307751 GFLOP/s, a 1330.0927512098629 x speedup over Python
