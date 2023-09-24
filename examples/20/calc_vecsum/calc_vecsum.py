import numpy as np
import timeit

def benchmark_add(dim):
    arr1 = np.random.random(dim).astype(np.float32).tolist()
    arr2 = np.random.random(dim).astype(np.float32).tolist()
    result = np.zeros(dim).tolist()
    secs = timeit.timeit(lambda: naive_add(arr1, arr2, result, dim), number = 100_000)/100_000
    print(secs, " seconds")
    gflops = (dim/secs) / 1e9
    print(gflops, " Gflops/s")
    return gflops

def naive_add(arr1, arr2, result, dim):
    for i in range(dim):
        result[i] = arr1[i] + arr2[i]

benchmark_add(1000)

# 0.03696093458223865  Gflops/s  

# 2.6901926069986075e-05  seconds
# 0.03717205962868508  Gflops/s