from benchmark import Benchmark
from complex import ComplexSIMD, ComplexFloat64
from math import iota
from python import Python
from runtime.llcl import num_cores, Runtime
from algorithm import parallelize, vectorize
from tensor import Tensor
from utils.index import Index

alias float_type = DType.float64
alias simd_width = 2 * simdwidthof[float_type]()

alias width = 960
alias height = 960
alias MAX_ITERS = 200

alias min_x = -2.0
alias max_x = 0.6
alias min_y = -1.5
alias max_y = 1.5


fn mandelbrot_kernel_SIMD[
    simd_width: Int
](c: ComplexSIMD[float_type, simd_width]) -> SIMD[float_type, simd_width]:
    """A vectorized implementation of the inner mandelbrot computation."""
    var cx = c.re
    var cy = c.im
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


fn main():
    var t = Tensor[float_type](height, width)

    @parameter
    fn compute_row(row: Int):
        var scale_x = (max_x - min_x) / width
        var scale_y = (max_y - min_y) / height

        @parameter
        fn compute_vector[simd_width: Int](col: Int):
            """Each time we operate on a `simd_width` vector of pixels."""
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
            compute_row(row)

    var vectorized_ms = Benchmark().run[bench[simd_width]]() / 1e6
    print("Number of threads:", num_cores())
    print("Vectorized:", vectorized_ms, "ms")

    # Parallelized
    var partition_factor = 16 # Is autotuned.
    
    @parameter
    fn bench_parallel[simd_width: Int]():
        parallelize[compute_row](height, partition_factor * num_cores())


    var parallelized_ms = Benchmark().run[bench_parallel[simd_width]]() / 1e6
    print("Parallelized:", parallelized_ms, "ms")
    print("Parallel speedup:", vectorized_ms / parallelized_ms)

    _ = t  # Make sure tensor isn't destroyed before benchmark is finished


# Number of threads: 12
# Vectorized: 13.329577 ms
# Parallelized: 1.530562 ms
# Parallel speedup: 8.708942858897581