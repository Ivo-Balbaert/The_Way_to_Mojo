# Create numpy arrays anp and bnp:
from PythonInterface import Python      # import numpy as np
let np = Python.import_module("numpy")
n = 10000000
anp = np.random.rand(n)
bnp = np.random.rand(n)

from Tensor import Tensor
from DType import DType
from Range import range
from SIMD import SIMD
from Math import sqrt
from Time import now

let n: Int = 10_000_000
var a = Tensor[DType.float64](n)
var b = Tensor[DType.float64](n)

for i in range(n):
    a[i] = anp[i].to_float64()
    b[i] = bnp[i].to_float64()
‍
def mojo_naive_dist(a: Tensor[DType.float64], b: Tensor[DType.float64]) -> Float64:
    var s: Float64 = 0.0
    n = a.num_elements()
    for i in range(n):
        dist = a[i] - b[i]
        s += dist*dist
    return sqrt(s)






