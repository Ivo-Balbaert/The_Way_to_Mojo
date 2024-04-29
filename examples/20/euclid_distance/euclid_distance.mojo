# Create numpy arrays anp and bnp:
from python import Python      
from tensor import Tensor
from math import sqrt
from time import now

alias dtype = DType.float64

def mojo_naive_dist(a: Tensor[dtype], b: Tensor[dtype]) -> Float64:
    var s: Float64 = 0.0
    n = a.num_elements()
    for i in range(n):
        dist = a[i] - b[i]
        s += dist*dist
    return sqrt(s)

fn print_formatter(string: String, value: Float64):
    print(string, end="")
    print(value)

fn main() raises:
    var np = Python.import_module("numpy")
    var n = 10_000_000
    var anp = np.random.rand(n)
    var bnp = np.random.rand(n)

    var a = Tensor[dtype](n)
    var b = Tensor[dtype](n)

    for i in range(n):
        a[i] = anp[i].to_float64()
        b[i] = bnp[i].to_float64()

    var eval_begin = now()
    var naive_dist = mojo_naive_dist(a, b)
    var eval_end = now()

    print_formatter("mojo_naive_dist value: ", naive_dist)
    print_formatter("mojo_naive_dist time (ms): ",Float64((eval_end - eval_begin)) / 1e6)

# mojo_naive_dist value: 1291.3664121235004
# mojo_naive_dist time (ms): 10.690652