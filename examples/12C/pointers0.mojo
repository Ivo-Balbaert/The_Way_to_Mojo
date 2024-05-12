fn main() raises:
    # Create a Pointer to an existing variable:
    var x: Int = 42  # x must be mutable to pass as a reference
    var xPtr = Pointer[Int].address_of(x)
    # print the address:
    print(xPtr.__int__())  # => 140722471124352
    # print the value:
    print(xPtr.load())  # => 42  # dereference a pointer

    # Casting type of Pointer with bitcast:
    var yPtr: Pointer[UInt8] = xPtr.bitcast[UInt8]()

    var array = Pointer[Int].alloc(3)
    array.store(0, 1)
    array.store(1, 2)
    print(array.load(0))  # => 1
    # how to print out?
    for i in range(3):
        print(array.load(i), " - ", end="")
    # => 1  - 2  - 114845100566118  -


# 140727704550632
# 42
# 1
# 1  - 2  - 0


# CRASHES: 2024-04-25
# This code crashes:
# # Create Null pointerq
# var ptr01 = Pointer[Int]()
# var ptr02 = Pointer[Int].get_null()
# print(ptr02.load(0))  # prints blancs
