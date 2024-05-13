# broken after v 0.4.0
# /home/ivo/mojo/mojo_test_way_programs/examples/matmul8.mojo:30:21: error: cannot pass 'VariadicList[fn(C = Matrix, A = Matrix, B = Matrix) -> None]' value, parameter expected 'VariadicList[fn(Matrix, Matrix, Matrix) -> None]'
#         VariadicList(matmul_autotune_impl.__adaptive_set),
#         ~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
from benchmark import Benchmark
from sys.intrinsics import strided_load
from utils.list import VariadicList
from math import div_ceil, min
from memory import memset_zero
from memory.unsafe import DTypePointer, Pointer
from random import rand, random_float64
from sys.info import simdwidthof
# from runtime.llcl import Runtime
from algorithm import vectorize, parallelize, vectorize_unroll
from algorithm import Static2DTileUnitFunc as Tile2DFunc
from autotune import autotune, search
from time import now

var python_gflops = 0.005430089939864052
alias nelts = simdwidthof[DType.float32]()  # The SIMD vector width.
alias matmul_fn_sig_type = fn(Matrix, Matrix, Matrix) -> None

# Perform 2D tiling on the iteration space defined by end_x and end_y.
fn tile[tiled_fn: Tile2DFunc, tile_x: Int, tile_y: Int](end_x: Int, end_y: Int):
    # Note: this assumes that ends are multiples of the tiles.
    for y in range(0, end_y, tile_y):
        for x in range(0, end_x, tile_x):
            tiled_fn[tile_x, tile_y](x, y)

fn matmul_autotune(C: Matrix, A: Matrix, B: Matrix):
    alias best_impl: matmul_fn_sig_type
    search[
        matmul_fn_sig_type,
        VariadicList(matmul_autotune_impl.__adaptive_set),
        matmul_evaluator -> best_impl
    ]()
    # Run the best candidate
    return best_impl(C, A, B)

fn matmul_evaluator(funcs: Pointer[matmul_fn_sig_type], size: Int) -> Int:
    print("matmul_evaluator, number of candidates: ", size)

    var eval_begin: Int = now()

    # This size is picked at random, in real code we could use a real size
    # distribution here.
    var M = 512
    var N = 512
    var K = 512
    print("Optimizing for size:", M, "x", N, "x", K)

    var best_idx: Int = -1
    var best_time: Int = -1

    alias eval_iterations = 10
    alias eval_samples = 10

    var C = Matrix(M, N)
    var A = Matrix(M, K)
    var B = Matrix(K, N)
    var Cptr = Pointer[Matrix].address_of(C).address
    var Aptr = Pointer[Matrix].address_of(A).address
    var Bptr = Pointer[Matrix].address_of(B).address
        # Find the function that's the fastest on the size we're optimizing for
        for f_idx in range(size):
            var func = funcs.load(f_idx)

            @always_inline
            @parameter
            fn wrapper():
                func(C, A, B)
            var cur_time = Benchmark(1, 100_000, 500_000_000, 1000_000_000).run[wrapper]()

            if best_idx < 0:
                best_idx = f_idx
                best_time = cur_time
            if best_time > cur_time:
                best_idx = f_idx
                best_time = cur_time

        var eval_end: Int = now()
        # Prevent matrices from being destroyed before we finished benchmarking them.
        _ = A.data
        _ = B.data
        _ = C.data
        print("Time spent in matmul_evaluator, ms:", (eval_end - eval_begin) // 1000000)
        print("Best candidate idx:", best_idx)
        return best_idx

# Autotune the tile size used in the matmul.
@adaptive   # change to @parameter if
fn matmul_autotune_impl(C: Matrix, A: Matrix, B: Matrix):
    @parameter
    fn calc_row(m: Int):
        @parameter
        fn calc_tile[tile_x: Int, tile_y: Int](x: Int, y: Int):
            for k in range(y, y + tile_y):
                @parameter
                fn dot[nelts : Int,](n : Int):
                    C.store[nelts](m,n+x, C.load[nelts](m,n+x) + A[m,k] * B.load[nelts](k,n+x))
                vectorize_unroll[nelts, tile_x // nelts, dot](tile_x)

        # Instead of hardcoding to tile_size = 4, search for the fastest 
        # tile size by evaluting this function as tile size varies.
        alias tile_size = autotune(1, 2, 4, 8, 16, 32)
        tile[calc_tile, nelts * tile_size, tile_size](A.cols, C.cols)
      
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
    benchmark_parallel[matmul_autotune](512, 512, 512, python_gflops)

# =>
# $ mojo matmul8.mojo
# matmul_evaluator, number of candidates:  6
# Optimizing for size: 512 x 512 x 512
# Time spent in matmul_evaluator, ms: 8898
# Best candidate idx: 0
# 118.13100247584663 GFLOP/s, a 21754.888737405363 x speedup over Python