from memory.unsafe import DTypePointer
from random import rand
from benchmark import Benchmark

alias MojoArr = DTypePointer[DType.float32]

fn add_naive(arr1: MojoArr, arr2: MojoArr, result: MojoArr, dim: Int):
    for i in range(dim):
        result.store(i, arr1.load(i) + arr2.load(i))

fn create_mojo_arr(dim: Int) -> MojoArr:
    let arr: MojoArr = MojoArr.alloc(dim)
    rand[DType.float32](arr, dim)
    return arr

@always_inline
fn benchmark[func: fn(MojoArr, MojoArr, MojoArr, Int) -> None]
            (dim: Int) -> Float64:

    let arr1: MojoArr = create_mojo_arr(dim)
    let arr2: MojoArr = create_mojo_arr(dim)
    let result: MojoArr = MojoArr.alloc(dim)

    @always_inline
    @parameter
    fn call_add_fn():
        _ = func(arr1, arr2, result, dim)

    let nanosecs = Float64(Benchmark().run[call_add_fn]())
    print(nanosecs, " nanoseconds")
    let secs = nanosecs / 1e9
    print(secs, " seconds")
    let gflops = dim/secs
    arr1.free()
    arr2.free()
    result.free()
    print(gflops, " Gflops/s")
    return gflops

fn main():
    _ = benchmark[add_naive](1000)

# 0.0  seconds
# inf  Gflops/s