from python import Python, PythonObject
from math import math
from time import now

fn plot_from_mojo(values: PythonObject) raises:   # 9
    print(values.__class__.__name__)  # => ndarray
    var plt = Python.import_module("matplotlib.pyplot")   # 10  
    _ = plt.plot(values)                          # 11              
    _ = plt.show()                                # 12

struct np_loader:
    var lib: PythonObject
    var loaded: Bool

    fn __init__(inout self):
        try:
            self.lib = Python.import_module("numpy")
            self.loaded = True
        except e:
            self.lib = ""
            self.loaded = False

    fn __getitem__(inout self, key:StringLiteral) raises -> PythonObject:
        return self.lib.__getattr__(key)

fn main() raises:
    var np = np_loader()                                        # 1 
    if np.loaded:                                               # 2
        var python_result = np["linspace"](0, 255, 256)         # 3
        print(python_result) 
        # =>
        # [  0.   1.   2.   3.   4.   5.   6.   7.   8.   9.  10.  11.  12.  13.
        # 14.  15.  16.  17.  ...   253. 254. 255.]
        var simd_mojo_array = SIMD[DType.float64, 256]()        # 4
        var pi = np["pi"].to_float64()                          # 5
    
        var size: Int = int(python_result.size)    # 6 
        for i in range(size):                                   # 7
            simd_mojo_array[i] = python_result[i].to_float64()    

        simd_mojo_array = math.cos(simd_mojo_array*(pi*2.0/256.0))  # 8   
        print(simd_mojo_array)   

        var x = PythonObject([])                              # 9   
        var range_size: Int = 256                   
        for i in range(range_size):                
            _ = x.append(simd_mojo_array[i])    

        var plt = Python.import_module("matplotlib.pyplot")   # 10  
        _ = plt.plot(x)                                       # 11              
        _ = plt.show()                                        # 12  

                 

# =>
# [1.0, 0.99969881869620425, 0.99879545620517241, 0.99729045667869021, 
# 0.99518472667219693, 0.99247953459870997, 0.98917650996478101, 
# 0.98527764238894122, ...,  0.99879545620517241, 0.99969881869620425]