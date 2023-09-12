from benchmark import Benchmark
from time import sleep

fn bench_args():
    fn sleeper():
        print("sleeping 300,000ns")
        sleep(3e-4)
    
    print("0 warmup iters, 5 max iters, 0ns min time, 1_000_000_000ns max time")
    let nanoseconds = Benchmark(0, 5, 0, 1_000_000_000).run[sleeper]()
    print("average time", nanoseconds)

fn bench_args_2():
    fn sleeper():
        print("sleeping 300,000ns")
        sleep(3e-4)
    
    print("\n0 warmup iters, 5 max iters, 0 min time, 1_000_000ns max time")
    let nanoseconds = Benchmark(0, 5, 0, 1_000_000).run[sleeper]()
    print("average time", nanoseconds)

fn fib(n: Int) -> Int:
    if n <= 1:
       return n 
    else:
       return fib(n-1) + fib(n-2)

fn fib_iterative(n: Int) -> Int:
    var count = 0
    var n1 = 0
    var n2 = 1

    while count < n:
       let nth = n1 + n2
       n1 = n2
       n2 = nth
       count += 1
    return n1

fn bench_iterative():
    fn iterative_closure():
        let n = 35
        for i in range(n):
            _ = fib_iterative(i)

    let iterative = Benchmark().run[iterative_closure]()
    print("Nanoseconds iterative:", iterative)

fn bench():
    fn closure():
        let n = 35
        for i in range(n):
            _ = fib(i)

    let nanoseconds = Benchmark().run[closure]()
    print("Nanoseconds:", nanoseconds)
    print("Seconds:", Float64(nanoseconds) / 1e9)

fn main():
    bench()
# =>
# Nanoseconds: 28052724
# Seconds: 0.028052724000000001
    bench_iterative()
# => Nanoseconds iterative: 0
    bench_args()
# 0 warmup iters, 5 max iters, 0ns min time, 1_000_000_000ns max time
# sleeping 300,000ns
# sleeping 300,000ns
# sleeping 300,000ns
# sleeping 300,000ns
# sleeping 300,000ns
# sleeping 300,000ns
# average time 379698
    bench_args_2()
# 0 warmup iters, 5 max iters, 0 min time, 1_000_000ns max time
# sleeping 300,000ns
# sleeping 300,000ns
# sleeping 300,000ns
# average time 400775