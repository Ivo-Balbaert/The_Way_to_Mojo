from autotune import autotune, search
import benchmark
from memory.unsafe import DTypePointer
from algorithm import vectorize

fn buffer_elementwise_add_impl[
    dt: DType
](lhs: DTypePointer[dt], rhs: DTypePointer[dt], result: DTypePointer[dt], N: Int):
    """Perform elementwise addition of N elements in RHS and LHS and store
    the result in RESULT.
    """
    @parameter
    fn add_simd[size: Int](idx: Int):
        let lhs_simd = lhs.simd_load[size](idx)
        let rhs_simd = rhs.simd_load[size](idx)
        result.simd_store[size](idx, lhs_simd + rhs_simd)
    
    # Pick vector length for this dtype and hardware
    alias vector_len = autotune(1, 4, 8, 16, 32)

    # Use it as the vectorization length
    vectorize[vector_len, add_simd](N)

fn elementwise_evaluator[dt: DType](
    fns: Pointer[fn (DTypePointer[dt], DTypePointer[dt], DTypePointer[dt], Int) -> None],
    num: Int,
) -> Int:
    # Benchmark the implementations on N = 64.
    alias N = 64
    let lhs = DTypePointer[dt].alloc(N)
    let rhs = DTypePointer[dt].alloc(N)
    let result = DTypePointer[dt].alloc(N)

    # Fill with ones.
    for i in range(N):
        lhs.store(i, 1)
        rhs.store(i, 1)

    # Find the fastest implementation.
    var best_idx: Int = -1
    var best_time: Float64 = -1
    for i in range(num):
        @parameter
        fn wrapper():
            fns.load(i)(lhs, rhs, result, N)
        let report = benchmark.run[wrapper](1)
        if best_idx < 0 or best_time > report.mean():
            best_idx = i
            best_time = report.mean()
        print("time[", i, "] =", best_time)
    print("selected:", best_idx)
    return best_idx

fn buffer_elementwise_add[
    dt: DType
](lhs: DTypePointer[dt], rhs: DTypePointer[dt], result: DTypePointer[dt], N: Int):
    # Forward declare the result parameter.
    alias best_impl: fn(DTypePointer[dt], DTypePointer[dt], DTypePointer[dt], Int) -> None

    # Perform search!
    search[
      fn(DTypePointer[dt], DTypePointer[dt], DTypePointer[dt], Int) -> None,
      buffer_elementwise_add_impl[dt],
      elementwise_evaluator[dt] -> best_impl
    ]()

    # Call the select implementation
    best_impl(lhs, rhs, result, N)

fn main():
    let N = 32
    let a = DTypePointer[DType.float32].alloc(N)
    let b = DTypePointer[DType.float32].alloc(N)
    let res = DTypePointer[DType.float32].alloc(N)
    # Initialize arrays with some values
    for i in range(N):
        a.store(i, 2.0)
        b.store(i, 40.0)
        res.store(i, -1)
        
    buffer_elementwise_add[DType.float32](a, b, res, N)
    print(a.load(10), b.load(10), res.load(10))

# time[ 0 ] = 2.0313989683017e-08
# time[ 1 ] = 6.2288460308697059e-09
# time[ 2 ] = 3.2163497386882918e-09
# time[ 3 ] = 2.6486077962600622e-09
# time[ 4 ] = 2.6486077962600622e-09
# selected: 3
# 2.0 40.0 42.0