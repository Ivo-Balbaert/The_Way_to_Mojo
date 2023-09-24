import numpy as np
import timeit

def benchmark_add(dim):
    arr1 = np.array(np.random.random(dim), dtype = np.float32)
    arr2 = np.array(np.random.random(dim), dtype = np.float32)
    secs = timeit.timeit(lambda: add(arr1, arr2), number = 100_000)/100_000
    print(secs, " seconds")
    gflops = (dim/secs) / 1e9
    print(gflops, " Gflops/s")
    return gflops

def add(arr1, arr2):
    result = arr1 + arr2
    
benchmark_add(1000)

# 5.636712099658326e-07  seconds
# 1.774083867190265  Gflops/s