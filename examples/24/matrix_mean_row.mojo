from tensor import Tensor, TensorShape, TensorSpec, rand
from math import trunc, mod
from memory import memset_zero
from sys.info import simdwidthof, simdbitwidth
from algorithm import vectorize, parallelize
from utils.index import Index
from random import seed
from python import Python
import time

# idiom:
alias dtype = DType.float32
alias simd_width: Int = simdwidthof[dtype]()


fn tensor_mean[dtype: DType](t: Tensor[dtype]) -> Tensor[dtype]:
    var new_tensor = Tensor[dtype](t.dim(0), 1)
    for i in range(t.dim(0)):
        for j in range(t.dim(1)):
            new_tensor[i] += t[i, j] # sum all items in a row
        new_tensor[i] /= t.dim(1) # div by number of columns 
    return new_tensor


fn tensor_mean_vectorize_parallelized[dtype: DType](t: Tensor[dtype]) -> Tensor[dtype]:
    var new_tensor = Tensor[dtype](t.dim(0), 1)

    @parameter
    fn parallel_reduce_rows(idx1: Int) -> None:
        @parameter
        fn vectorize_reduce_row[simd_width: Int](idx2: Int) -> None:
            new_tensor[idx1] += t.load[width=simd_width](
                idx1 * t.dim(1) + idx2
            ).reduce_add()

        vectorize[vectorize_reduce_row, 2 * simd_width](t.dim(1))
        new_tensor[idx1] /= t.dim(1)

    parallelize[parallel_reduce_rows](t.dim(0), 8)
    return new_tensor


fn main() raises:
    print("SIMD bit width:", simdbitwidth())  # => SIMD bit width: 256
    print("SIMD Width:", simd_width)  # => SIMD Width: 8

    var tx = rand[dtype](5, 12)
    print(tx)
    # =>
    # Tensor([[0.1315377950668335, 0.458650141954422, 0.21895918250083923, ..., 0.066842235624790192, 0.68677270412445068, 0.93043649196624756],
    # [0.52692878246307373, 0.65391898155212402, 0.70119059085845947, ..., 0.75335586071014404, 0.072685882449150085, 0.88470715284347534],
    # [0.43641141057014465, 0.47773176431655884, 0.27490684390068054, ..., 0.090732894837856293, 0.073749072849750519, 0.38414216041564941],
    # [0.91381746530532837, 0.46444582939147949, 0.050083983689546585, ..., 0.30632182955741882, 0.51327371597290039, 0.84598153829574585],
    # [0.84151065349578857, 0.41539460420608521, 0.46791738271713257, ..., 0.84203958511352539, 0.21275150775909424, 0.13042725622653961]], dtype=float32, shape=5x12)

    seed(42)
    var t = rand[dtype](1000, 100_000)
    var result = Tensor[dtype](t.dim(0), 1)  # reduces 2nd dimension to 1

    print("Input Matrix shape:", t.shape())  # => Input Matrix shape: 1000x100000
    print("Reduced Matrix shape:", result.shape())  # => Reduced Matrix shape: 1000x1
    # print(t)

    # Naive approach in Mojo
    alias reps = 10
    var tm1 = time.now()
    for i in range(reps):
        _ = tensor_mean[dtype](t)
    var dur1 = time.now() - tm1
    print("Mojo naive mean:", dur1 / reps / 1000000, "ms")

    # NumPy approach
    var np = Python.import_module("numpy")
    var dim0 = t.dim(0)
    var dim1 = t.dim(1)
    var t_np = np.random.rand(dim0, dim1).astype(np.float32)
    var tm2 = time.now()
    for i in range(reps):
        _ = np.mean(t_np, 1)
    var dur2 = time.now() - tm2
    print("Numpy mean:", dur2 / reps / 1000000, "ms")

    # Vectorized and parallelized approach in Mojo
    var tm3 = time.now()
    for i in range(reps):
        _ = tensor_mean_vectorize_parallelized[dtype](t)
    var dur3 = time.now() - tm3
    print("Mojo Vectorized and parallelized mean:", dur3 / reps / 1000000, "ms")


# =>
# Mojo naive mean: 171.706568 ms
# Numpy mean: 22.4442907 ms
# Mojo Vectorized and parallelized mean: 7.8798915000000003 ms
# Mojo VP is 2.8 x faster than Numpy
