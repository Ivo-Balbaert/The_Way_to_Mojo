from memory.unsafe import DTypePointer
from random import rand
from benchmark import Benchmark
from algorithm import vectorize
from sys.info import simdwidthof

alias MojoArr = DTypePointer[DType.float32]
alias nelts = simdwidthof[DType.float32]()

fn add_simd(arr1: MojoArr, arr2: MojoArr, result: MojoArr, dim: Int):
    @parameter
    fn add_simd[nelts: Int](n: Int):
        result.simd_store[nelts](n, arr1.simd_load[nelts](n) + 
                                    arr2.simd_load[nelts](n))

    vectorize[nelts, add_simd](dim)

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

    let secs = Float64(Benchmark().run[call_add_fn]()) / 1_000_000_000
    print(secs, " seconds")
    let gflops = dim/secs
    arr1.free()
    arr2.free()
    result.free()
    print(gflops, " Gflops/s")
    return gflops

fn main():
    _ = benchmark[add_simd](1000)

# 0.0  seconds
# inf  Gflops/s