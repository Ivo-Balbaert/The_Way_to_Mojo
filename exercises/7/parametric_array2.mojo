from memory import memset_zero


struct Array[T: AnyRegType]:
    var data: Pointer[T]
    var size: Int
    var cap: Int

    fn __init__(inout self):
        self.cap = 16
        self.size = 0
        self.data = Pointer[T].alloc(self.cap)
        # initialize to zeros
        memset_zero(self.data, self.cap)
        # alternative: fill with random elements
        # rand(self.data, self.cap)

    fn __init__(inout self, size: Int, value: T):
        self.cap = size * 2
        self.size = size
        self.data = Pointer[T].alloc(self.cap)
        for i in range(self.size):
            self.data.store(i, value)
        #   self[i] = value

    @always_inline
    fn zero(inout self):
        memset_zero(self.data, self.cap)

    @always_inline
    fn __getitem__(self, i: Int) -> T:
        # bounds check:
        if i >= self.size:
            print(
                "Warning: you're trying to get an index out of bounds, memory violation"
            )
            print("This is the first element: ")
            return self.data.load(0)
        return self.data.load(i)

    @always_inline
    fn __setitem__(inout self, i: Int, value: T):
        if i >= self.size:
            print("Warning: you're trying to set an index out of bounds, doing nothing")
            return
        self.data.store(i, value)

    # fn __copyinit__(inout self, rhs: Self):    # shallow copy , #error: redefinition
    #     self.size = rhs.size
    #     self.cap = rhs.cap
    #     self.data = rhs.data

    @always_inline
    fn __copyinit__(inout self, rhs: Self):  # deep copy
        self.size = rhs.size
        self.cap = rhs.cap
        self.data = Pointer[T].alloc(self.cap)  # new memory is allocated
        # for i in range(rhs.size):
        #     self.data.store(i, rhs.data.load(i))
        # faster:
        memcpy[T](self.data, rhs.data, self.size)

    @always_inline
    fn __moveinit__(inout self, owned rhs: Self):  # move - same body code as copyinit
        self.__copyinit__(rhs)
        # self.size = rhs.size
        # self.cap = rhs.cap
        # self.data = Pointer[T].alloc(self.cap)
        # # for i in range(rhs.size):
        # #     self.data.store(i, rhs.data.load(i))
        # # faster:
        # memcpy[T](self.data, rhs.data, self.size)

    fn dump(self):  # does not work! print doesn't work for AnyType
        for i in range(self.size):
            # print(self.data.load(i))  # error: print doesn't know how to print a T
            pass  # error: no matching function in call to 'print':

    fn __del__(owned self):
        self.data.free()


fn main():
    var v = Array[Float32](4, 3.14)  # 3
    print(v[0], v[1], v[2], v[3])
    # => 3.1400001049041748 3.1400001049041748 3.1400001049041748 3.1400001049041748

    v[0] = 42
    print(v[0])  # => 42.0
    print(v[0], v[1], v[2], v[3])
    # => 42.0 3.1400001049041748 3.1400001049041748 3.1400001049041748

    for i in range(v.size):
        print_no_newline("i:", i, " ", v[i], "- ")
    print()
    # => i: 0   42.0 - i: 1   3.1400001049041748 - i: 2   3.1400001049041748 - i: 3   3.1400001049041748 - 

    let w = v  # deep copy
    print(w[0])  # => 42.0
    v[0] = 108
    print(v[0])  # => 108.0
    print(w[0])  # => 42.0

    let x = v ^  # move
    print(x[0])  # => 108.0
    # v[0] = 111  # error: use of uninitialized value 'v'
