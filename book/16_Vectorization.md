# 16 - Vectorization

See § 20.3.4.2


See `calc_mean_matrix.mojo`:  error!

The following code is a nice example of demonstrating vectorizing:
See `tensor2.mojo`:
```py
from tensor import Tensor
from random import rand
from math import sqrt, round
from algorithm import vectorize
from sys.info import simdwidthof

alias type = DType.float32
alias simd_width: Int = simdwidthof[type]()

fn tensor_math(t: Tensor[type]) -> Tensor[type]:
    var t_new = Tensor[type](t.shape())
    for i in range(t.num_elements()):
        t_new[i] = sqrt(t[i])  # some for round isntead of sqrt
    return t_new

fn tensor_math_vectorized(t: Tensor[type]) -> Tensor[type]:
    var t_new = Tensor[type](t.shape())
    
    @parameter
    fn vecmath[simd_width: Int](idx: Int) -> None:
        t_new.simd_store[simd_width](idx, sqrt(t.simd_load[simd_width](idx)))
    vectorize[simd_width, vecmath](t.num_elements())
    return t_new


fn main():
   vart = rand[type](2,2)
    print(t.shape().__str__()) # 3x3
    print(t.spec().__str__())  # 3x3xfloat32
    # print(t[0]) # => 0.1315377950668335
    # print(t[1]) # => 0.458650141954422
    # print(t[2]) # => 0.21895918250083923
    # print(t.num_elements()) # => 9

    # tensorprint() utility ?
    for i in range(t.num_elements()):
       print(t[i]) 

    print()
   vart1 = tensor_math(t)
    for i in range(t1.num_elements()):
       print(t1[i]) 

    print()
   vart2 = tensor_math_vectorized(t)
    for i in range(t2.num_elements()):
       print(t2[i]) 

    print(simd_width) # => 8
```
# 16.1 - 

## 16.1.1 Vectorize SIMD cosine

See `vectorize1.mojo`:
```py
import math
from sys.info import simdwidthof
from algorithm import vectorize
from python import Python

alias size = 256
alias value_type = DType.float64
# how much values at a time
alias by_group_of = simdwidthof[value_type]() 


fn main():
    # allocate array of size elements of type value_type
    var array = DTypePointer[value_type]().alloc(size)
    
    @parameter
    fn cosine[group_size: Int](n: Int):
        # create a simd array of size group_size. values: n -> (n + group_size-1)
        var tmp = math.iota[value_type, group_size](n)
        tmp = tmp * 3.14 * 2 / 256.0
        tmp = math.cos[value_type, group_size](tmp)
        array.simd_store[group_size](n, tmp)
    
    vectorize[by_group_of, cosine](size)  # 1
    
    for i in range(size):
        print(array.load(i))
    
    try:
        var plt = Python.import_module("matplotlib.pyplot")
        var python_y_array = PythonObject([])
        for i in range(size):
            _ = python_y_array.append(array.load(i))
        var python_x_array = Python.evaluate("[x for x in range(256)]")
        _ = plt.plot(python_x_array, python_y_array)
        _ = plt.show()
    except:
        print("no plot")
```
?? not clear where group_size is defined, size in line (1)