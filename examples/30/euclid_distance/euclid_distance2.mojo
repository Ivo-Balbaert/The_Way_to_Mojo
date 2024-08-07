# Create numpy arrays anp and bnp:
from python import Python
from tensor import Tensor
from math import sqrt
from time import now
from sys.info import simdwidthof
from algorithm import vectorize

alias dtype = DType.float64
alias simd_width = simdwidthof[dtype]()

fn print_formatter(string: String, value: Float64):
    print(string, end="")
    print(value)

fn mojo_dist_vectorized(a: Tensor[dtype], b: Tensor[dtype]) -> Float64:
    var sq_dist: Float64 = 0.0

    @parameter
    fn simd_norm[simd_width: Int](idx: Int):
        var diff = a.load[width=simd_width](idx) - b.load[width=simd_width](idx)
        sq_dist += (diff * diff).reduce_add()

    vectorize[simd_norm, simd_width](a.num_elements())
    return sqrt(sq_dist)


fn main() raises:
    print("simdwidth:", simd_width)
    var np = Python.import_module("numpy")
    var n = 10_000_000
    var anp = np.random.rand(n)
    var bnp = np.random.rand(n)

    var arr1_tensor = Tensor[dtype](n)
    var arr2_tensor = Tensor[dtype](n)

    for i in range(n):
        arr1_tensor[i] = anp[i].to_float64()
        arr2_tensor[i] = bnp[i].to_float64()

    var eval_begin = now()
    var mojo_dist_vec = mojo_dist_vectorized(arr1_tensor, arr2_tensor)
    var eval_end = now()

    print_formatter("mojo_vectorized_dist value: ", mojo_dist_vec)
    print_formatter("mojo_fn_vectorized time (ms): ",Float64((eval_end - eval_begin)) / 1e6)

# simdwidth: 4
# mojo_vectorized_dist value: 1291.0948987587576
# mojo_fn_vectorized time (ms): 6.7728580000000003