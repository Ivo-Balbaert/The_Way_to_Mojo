from benchmark import Unit, benchmark
from time import sleep

fn sleeper():
    sleep(.01)

fn main():
    var report = benchmark.run[sleeper]()
    print(report.mean())   # => 0.010147911948148149
    report.print()
    print("")
    report.print(Unit.ms)

# ---------------------
# Benchmark Report (s)
# ---------------------
# Mean: 0.010147911948148149
# Total: 1.3699681130000001
# Iters: 135
# Warmup Mean: 0.0100463785
# Warmup Total: 0.020092756999999999
# Warmup Iters: 2
# Fastest Mean: 0.010111081172413793
# Slowest Mean: 0.010297477449999998


# ---------------------
# Benchmark Report (ms)
# ---------------------
# Mean: 10.147911948148147
# Total: 1369.9681129999999
# Iters: 135
# Warmup Mean: 10.046378499999999
# Warmup Total: 20.092756999999999
# Warmup Iters: 2
# Fastest Mean: 10.111081172413792
# Slowest Mean: 10.297477449999999
