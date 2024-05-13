from benchmark import Unit, benchmark
from time import sleep


fn sleeper():
    sleep(0.010)


fn main():
    var report = benchmark.run[sleeper]()
    print(report.mean())  # => 0.01026473564
    report.print()
    print("")
    report.print(Unit.ms)


# ---------------------
# Benchmark Report (s)
# ---------------------
# Mean: 0.01026473564
# Total: 2.052947128
# Iters: 200
# Warmup Mean: 0.010189841999999999
# Warmup Total: 0.020379683999999999
# Warmup Iters: 2
# Fastest Mean: 0.010264735640000001
# Slowest Mean: 0.010264735640000001


# Benchmark Report (ms)
# ---------------------
# Mean: 10.26473564
# Total: 2052.9471279999998
# Iters: 200
# Warmup Mean: 10.189842000000001
# Warmup Total: 20.379684000000001
# Warmup Iters: 2
# Fastest Mean: 10.264735640000001
# Slowest Mean: 10.264735640000001