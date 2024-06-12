# 23 - Vectorization
Applying SIMD on calculations in a loop is called *vectorization*. Vectorizating a program means rewriting a loop, so that instead of processing a single element of an array N times, it processes (say) 4 elements of the array simultaneously N/4 times.
For example, when calculating an image: by vectorizing the loop, we can compute multiple pixels simultaneously. 
`vectorize` is a higher order generator.
Use this algorithm by importing: `from algorithm import vectorize`

(See also § 30.2.3 Euclid distance, Mandelbrot, ...)

The following examples demonstrate the use of vectorization.

## 23.1 Vectorize SIMD cosine

See `vectorize1.mojo`:
```py
import math
from sys.info import simdwidthof
from algorithm import vectorize
from python import Python

alias size = 256
alias value_type = DType.float64
# how many values at a time
alias group_size = simdwidthof[value_type]() # how many float64 values fit into the SIMD register


fn main():
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
# =>
# [0.0, 1.0, 2.0, 3.0]
# [1.0, 0.99969912397565974, 0.99879667695540308, 0.99729320198857307]- 
# [4.0, 5.0, 6.0, 7.0]
# [0.99518960379431143, 0.99248714821714101, 0.98918746146524184, 0.98529252913187693]- 
# [8.0, 9.0, 10.0, 11.0]
# [0.98080469500055723, 0.97572665963466554, 0.97006147875238646, 0.96381256138792215]- 
# [12.0, 13.0, 14.0, 15.0]
# [0.95698366784009858, 0.94957890740959849, 0.94160273592618093, 0.93305995306737655]- 
# [16.0, 17.0, 18.0, 19.0]
# [0.92395569947027212, 0.91429545363812148, 0.90408502864364482, 0.89333056863100047]- 
# [20.0, 21.0, 22.0, 23.0]
# [0.88203854511853352, 0.87021575310452626, 0.85786930697829433, 0.84500663623908812]- 
# [24.0, 25.0, 26.0, 27.0]
# ...
```

@parameter in line 1 allows the closure `cosine` to capture the `array` pointer.
vectorize is called in line 2: on a machine with a SIMD register size of 256, this will set 4x Float64 values on each iteration, as we can see in the display of tmp.

## 23.2 Using vectorization with a Tensor
See `tensor2.mojo`:
```py
from tensor import Tensor, TensorShape
from math import sqrt
from algorithm import vectorize
from sys.info import simdwidthof

alias type = DType.float32
# how many float32 values fit into the SIMD register
alias simd_width: Int = simdwidthof[type]()


fn tensor_math(t: Tensor[type]) -> Tensor[type]:
    var t_new = Tensor[type](t.shape())
    for i in range(t.num_elements()):
        t_new[i] = sqrt(t[i])
    return t_new


fn tensor_math_vectorized(t: Tensor[type]) -> Tensor[type]:
    var t_new = Tensor[type](t.shape())

    @parameter
    fn vecmath[simd_width: Int](idx: Int) -> None:
        t_new.store[simd_width](idx, sqrt(t.load[simd_width](idx)))

    vectorize[
        vecmath,
        simd_width,
    ](t.num_elements())
    return t_new


fn main():
    print(simd_width)  # => 8
    var tshape = TensorShape(3, 3)
    var t = Tensor[type].rand(tshape)
    print(t.shape())  # 3x3
    print(t.spec())  # 3x3xfloat32
    print(t[0])  # => 0.1315377950668335
    print(t[1])  # => 0.458650141954422
    print(t[2])  # => 0.21895918250083923
    print(t.num_elements())  # => 9

    for i in range(t.num_elements()):
        print(t[i])

    print("\n - tensor_math")
    var t1 = tensor_math(t)
    for i in range(t1.num_elements()):
        print(t1[i])

    print("\n - tensor_math_vectorized")
    var t2 = tensor_math_vectorized(t)
    for i in range(t2.num_elements()):
        print(t2[i])


# =>
# 8
# 3x3
# 3x3xfloat32
# 0.1315377950668335
# 0.458650141954422
# 0.21895918250083923
# 9
# 0.1315377950668335
# 0.458650141954422
# 0.21895918250083923
# 0.67886471748352051
# 0.93469291925430298
# 0.51941639184951782
# 0.034572109580039978
# 0.52970021963119507
# 0.007698186207562685

#  - tensor_math
# 0.36268138885498047
# 0.67723715305328369
# 0.46793073415756226
# 0.8239324688911438
# 0.96679520606994629
# 0.72070550918579102
# 0.18593576550483704
# 0.72780507802963257
# 0.087739311158657074

#  - tensor_math_vectorized, why intermediate 0.0 ?
# 0.36268138885498047
# 0.0
# 0.0
# 0.0
# 0.0
# 0.0
# 0.0
# 0.0
# 0.087739311158657074
```

Why intermediate 0's in tensor_math_vectorized !!

Other examples:
* keyword_params.mojo 

