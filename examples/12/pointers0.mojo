fn main() raises:
    # Create a Pointer to an existing variable:
    var x: Int = 42  # x must be mutable to pass as a reference
    let xPtr = Pointer[Int].address_of(x)
    # print the address:
    print(xPtr.__as_index()) # => 140722471124352
    # print the value:
    print(xPtr.load())  # => 42  # dereference a pointer
    
    # Casting type of Pointer with bitcast:
    let yPtr: Pointer[UInt8] = xPtr.bitcast[UInt8]()

    let array = Pointer[Int].alloc(3)
    array.store(0, 1)
    array.store(1, 2)
    print(array.load(0))  # => 1
    # how to print out?
    for i in range(3):
        print_no_newline(array.load(i), " - ")
    # => 1  - 2  - 114845100566118  -

    # Create Null pointerq
    let ptr01 = Pointer[Int]()
    let ptr02 = Pointer[Int].get_null()
    print(ptr02.load(0))  # prints blancs
