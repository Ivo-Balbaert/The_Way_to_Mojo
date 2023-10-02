from testing import assert_true


fn example[T: AnyType](arg: T):
    @parameter
    if T == Float64:
        print("Float64")
        print(rebind[Float64](arg))

    @parameter
    if T == Int:
        print("Integer")
        print(rebind[Int](arg))  # 1


fn main():
    _ = example[Int]
    _ = example[AnyType]
