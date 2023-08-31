# doesn't work!
# ok in Jupyter notebook, not in file
# %%python  #  error: unexpected token in expression
import numpy as np
from timeit import timeit

def matmul_python(C, A, B):
    for m in range(C.rows):
        for k in range(A.cols):
            for n in range(C.cols):
                C[m, n] += A[m, k] * B[k, n]

class Matrix:
    def __init__(self, value, rows, cols):
        self.value = value
        self.rows = rows
        self.cols = cols
        
    def __getitem__(self, idxs):
        return self.value[idxs[0]][idxs[1]]
    
    def __setitem__(self, idxs, value):
        self.value[idxs[0]][idxs[1]] = value

def benchmark_matmul_python(M, N, K):
    A = Matrix(list(np.random.rand(M, K)), M, K)
    B = Matrix(list(np.random.rand(K, N)), K, N)
    C = Matrix(list(np.zeros((M, N))), M, N)
    secs = timeit(lambda: matmul_python(C, A, B), number=2)/2
    gflops = ((2*M*N*K)/secs) / 1e9
    print(gflops, "GFLOP/s")
    return gflops

python_gflops = benchmark_matmul_python(128, 128, 128).to_float64()
