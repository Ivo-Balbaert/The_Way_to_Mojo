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

