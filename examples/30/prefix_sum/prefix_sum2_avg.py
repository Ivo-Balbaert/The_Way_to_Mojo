from time import time_ns
import numpy as np

list = np.full(10_000, 1)
cum_time = 0
for i in range(1, 100):
    tik = time_ns()
    list = np.cumsum(list)
    tok = time_ns()
    # print(f"Time spent per element: {(tok - tik) / len(list)} ns")
    cum_time += (tok - tik) / len(list)

print(f"Time spent per element (averaged): { cum_time / 100 } ns")
# => Time spent per element (averaged): 1.6825439999999994 ns
