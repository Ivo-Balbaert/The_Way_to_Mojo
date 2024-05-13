from time import now

fn fib(n: Int) -> Int:
    if n <= 1:
        return n
    else:
        return fib(n - 1) + fib(n - 2)

fn main():
    var eval_begin = now()
    var res = fib(50)
    var eval_end = now()
    var execution_time_sequential = Float64((eval_end - eval_begin))
    print("execution_time sequential in ms:")
    print(execution_time_sequential / 1000000)
# =>
# execution_time sequential in ms:
# 24544.309911
