import benchmark
from time import sleep


fn fib(n: Int) -> Int:
    if n <= 1:
        return n
    else:
        return fib(n - 1) + fib(n - 2)

fn fib_iterative(n: Int) -> Int:
    var count = 0
    var n1 = 0
    var n2 = 1

    while count < n:
        var nth = n1 + n2
        n1 = n2
        n2 = nth
        count += 1
    
    return n1

fn sleeper():
    print("sleeping 300,000ns")
    sleep(3e-4)

fn test_fib():
    var n = 35
    for i in range(n):
        _ = fib(i)

fn test_fib_iterative():
    var n = 35
    for i in range(n):
        _ = fib_iterative(i)


fn main():
    var report = benchmark.run[test_fib]()
    print(report.mean(), "seconds")
    # => 0.033257654583333331 seconds

    report = benchmark.run[test_fib_iterative]()
    print(report.mean(), "seconds")
    # => 1.6000000000000001e-17 seconds

    print("0 warmup iters, 5 max iters, 0ns min time, 1_000_000_000ns max time")
    report = benchmark.run[sleeper](0, 5, 0, 1_000_000_000)
    print(report.mean(), "seconds")
    # 0 warmup iters, 5 max iters, 0ns min time, 1_000_000_000ns max time
    # -nan seconds (??)
    