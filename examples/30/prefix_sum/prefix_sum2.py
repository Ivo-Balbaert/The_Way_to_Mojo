from time import time_ns
import numpy as np

list = np.full(10_000, 1)
tik = time_ns()
list = np.cumsum(list)
tok = time_ns()
print(f"Time spent per element: {(tok - tik) / len(list)} ns")
# Time spent per element: 4.3047 ns
