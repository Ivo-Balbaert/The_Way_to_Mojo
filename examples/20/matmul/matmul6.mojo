from benchmark import Benchmark
from sys.intrinsics import strided_load
from utils.list import VariadicList
from math import div_ceil, min
from memory import memset_zero
from memory.unsafe import DTypePointer
from random import rand, random_float64
from sys.info import simdwidthof
from runtime.llcl import Runtime
from algorithm import vectorize, parallelize
from algorithm import Static2DTileUnitFunc as Tile2DFunc

let python_gflops = 0.005430089939864052
alias nelts = simdwidthof[DType.float32]()  # The SIMD vector width.

# Perform 2D tiling on the iteration space defined by end_x and end_y.
fn tile[tiled_fn: Tile2DFunc, tile_x: Int, tile_y: Int](end_x: Int, end_y: Int):
    # Note: this assumes that ends are multiples of the tiles.
    for y in range(0, end_y, tile_y):
        for x in range(0, end_x, tile_x):
            tiled_fn[tile_x, tile_y](x, y)

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
    func: fn (Matrix, Matrix, Matrix, Runtime) -> None
](M: Int, N: Int, K: Int, python_gflops: Float64):
    var C = Matrix(M, N)
    C.zero()
    var A = Matrix(M, K)
    var B = Matrix(K, N)

    with Runtime() as rt:

        @always_inline
        @parameter
        fn test_fn():
            _ = func(C, A, B, rt)

        let secs = Float64(Benchmark().run[test_fn]()) / 1_000_000_000
        # Prevent the matrices from being freed before the benchmark run
        _ = (A, B, C)
        let gflops = ((2 * M * N * K) / secs) / 1e9
        let speedup: Float64 = gflops / python_gflops
        # print(gflops, "GFLOP/s", speedup, " speedup")
        print(gflops, "GFLOP/s, a", speedup.value, "x speedup over Python")


fn main() raises:
    benchmark_parallel[matmul_tiled_parallelized](512, 512, 512, python_gflops)

# =>
# $ mojo matmul6.mojo
# 512 x 512:
# 99.61793034345834 GFLOP/s, a 18345.539658953123 x speedup over Python
