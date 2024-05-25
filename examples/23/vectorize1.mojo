import math
from sys.info import simdwidthof
from algorithm import vectorize
from python import Python

alias size = 256
alias value_type = DType.float64
# how many values at a time
alias group_size = simdwidthof[value_type]() # how many float64 values fit into the SIMD register


fn main():
    print(group_size) # => 4
    # allocate array of size elements of type value_type
    var array = DTypePointer[value_type].alloc(size)
    
    @parameter                          # 1
    fn cosine[group_size: Int](n: Int):
        # create a simd array of size group_size. values: n -> (n + group_size-1)
        var tmp = math.iota[value_type, group_size](n)
        print(tmp)
        tmp = tmp * 3.14 * 2 / 256.0
        tmp = math.cos[value_type, group_size](tmp)
        print(tmp, end="- \n")
        array.store(n, tmp)
    
    vectorize[cosine, group_size](size)  # 2
    
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
        print("error in plotting")