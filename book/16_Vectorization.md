# 16 - Vectorization

See § 20.3.4.2

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