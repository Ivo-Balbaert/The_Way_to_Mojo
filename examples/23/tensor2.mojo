from tensor import Tensor, rand
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
        t_new.store[simd_width](idx, sqrt(t.load[simd_width](idx)))

    vectorize[
        vecmath,
        simd_width,
    ](t.num_elements())
    return t_new


fn main():
    var t = rand[type](3, 3)
    print(t.shape().__str__())  # 3x3
    print(t.spec().__str__())  # 3x3xfloat32
    print(t[0])  # => 0.1315377950668335
    print(t[1])  # => 0.458650141954422
    print(t[2])  # => 0.21895918250083923
    print(t.num_elements())  # => 9

    # tensorprint() utility ?
    for i in range(t.num_elements()):
        print(t[i])

    print()
    var t1 = tensor_math(t)
    for i in range(t1.num_elements()):
        print(t1[i])

    print()
    var t2 = tensor_math_vectorized(t)
    for i in range(t2.num_elements()):
        print(t2[i])

    print(simd_width)  # => 8


# =>
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

# 0.36268138885498047
# 0.67723715305328369
# 0.46793073415756226
# 0.8239324688911438
# 0.96679520606994629
# 0.72070550918579102
# 0.18593576550483704
# 0.72780507802963257
# 0.087739311158657074

# 0.36268138885498047
# 0.0
# 0.0
# 0.0
# 0.0
# 0.0
# 0.0
# 0.0
# 0.087739311158657074
# 8
