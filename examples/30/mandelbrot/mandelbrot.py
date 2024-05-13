import numpy as np
from timeit import timeit

import send2trash

MAX_ITERS = 1000
width = 960
height = 960

min_x = -2.0
max_x = 0.6
min_y = -1.5
max_y = 1.5

def mandelbrot_kernel(c): 
  z = c
  nv = 0
  for i in range(MAX_ITERS):
    if abs(z) > 2:
      break
    z = z*z + c
    nv += 1
  return nv

def compute_mandelbrot():
    # create a matrix. Each element of the matrix corresponds to a pixel
    t = np.zeros( (height, width) )
  
    dx = (max_x - min_x) / width
    dy = (max_y - min_y) / height

    y = min_y
    for row in range(height):
        x = min_x
        for col in range(width):
            t[row, col] = mandelbrot_kernel(complex(x, y))
            x += dx
        y += dy
    return t


def benchmark_mandelbrot_python():
    secs = timeit(lambda: compute_mandelbrot(), number=2) / 2
    print(secs, " secs")
    gflops =  secs / 1e9
    print(gflops, "GFLOP/s")
    return gflops

if __name__ == "__main__":
    print("Throughput of mandelbrot in Python:")
    print(benchmark_mandelbrot_python())

# Throughput of mandelbrot in Python:
# 11.530147033001413  secs
# 1.1530147033001413e-08 GFLOP/send2trash