from tensor import Tensor
from random import rand
import benchmark
from time import sleep
from algorithm import vectorize, parallelize

alias dtype = DType.float32
alias simd_width = simdwidthof[DType.float32]()


fn row_mean_naive[dtype: DType](t: Tensor[dtype]) -> Tensor[dtype]:
    var res = Tensor[dtype](t.dim(0), 1)
    for i in range(t.dim(0)):
        for j in range(t.dim(1)):
            res[i] += t[i, j]
        res[i] /= t.dim(1)
    return res


fn row_mean_fast[dtype: DType](t: Tensor[dtype]) -> Tensor[dtype]:
    var res = Tensor[dtype](t.dim(0), 1)

    @parameter
    fn parallel_reduce_rows(idx1: Int) -> None:
        @parameter
        fn vectorize_reduce_row[simd_width: Int](idx2: Int) -> None:
            res[idx1] += t.simd_load[simd_width](idx1 * t.dim(1) + idx2).reduce_add()

        vectorize[2 * simd_width, vectorize_reduce_row](t.dim(1))
        res[idx1] /= t.dim(1)

    parallelize[parallel_reduce_rows](t.dim(0), t.dim(0))
    return res


fn main():
    let t = rand[dtype](1000, 1000)
    var result = Tensor[dtype](t.dim(0), 1)

    @parameter
    fn bench_mean():
        _ = row_mean_naive(t)

    @parameter
    fn bench_mean_fast():
        _ = row_mean_fast(t)

    let report = benchmark.run[bench_mean]()
  #  let report = benchmark.run[row_mean_naive(t)]()
    let report_fast = benchmark.run[bench_mean_fast]()
    report.print()
    report_fast.print()
    print("Speed up:", report.mean() / report_fast.mean())


# => 202.3 Nov 11: for  main():
#    let t = rand[dtype](1000,100000)
# [29195:29195:20231111,103553.196898:ERROR file_io_posix.cc:144] open /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq: No such file or directory (2)
# [29195:29195:20231111,103553.196940:ERROR file_io_posix.cc:144] open /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq: No such file or directory (2)
# Please submit a bug report to https://github.com/modularml/mojo/issues and include the crash backtrace along with all the relevant source codes.
# Stack dump:
# 0.      Program arguments: mojo calc_mean_matrix.mojo
# Stack dump without symbol names (ensure you have llvm-symbolizer in your PATH or set the environment var `LLVM_SYMBOLIZER_PATH` to point to it):
# 0  mojo      0x0000558fd8c39b97
# 1  mojo      0x0000558fd8c3776e
# 2  mojo      0x0000558fd8c3a26f
# 3  libc.so.6 0x00007f42366c9520
# 4  libc.so.6 0x00007f41740017b3
# Segmentation fault

# =>
# ---------------------
# Benchmark Report (s)
# ---------------------
# Mean: 0.0020958697733598408
# Total: 1.054222496
# Iters: 503
# Warmup Mean: 0.0019287810000000001
# Warmup Total: 0.0038575620000000001
# Warmup Iters: 2
# Fastest Mean: 0.0020823652932862192
# Slowest Mean: 0.0021170246499999999

# for (1000, 1000)
# ---------------------
# Benchmark Report (s)
# ---------------------
# Mean: 0.00068503110180224058
# Total: 1.4063688519999999
# Iters: 2053
# Warmup Mean: 0.00091436450000000004
# Warmup Total: 0.0018287290000000001
# Warmup Iters: 2
# Fastest Mean: 0.00020097415
# Slowest Mean: 0.00074287821512247071

# Speed up: 3.0595249877645565
