from memory.unsafe import Pointer

struct HeapArray:                   # 1
    var data: Pointer[Int]
    var size: Int
    var cap: Int

    fn __init__(inout self):
        self.cap = 16
        self.size = 0
        self.data = Pointer[Int].alloc(self.cap)

    fn __init__(inout self, size: Int, val: Int):
        self.cap = size * 2
        self.size = size
        self.data = Pointer[Int].alloc(self.cap)
        for i in range(self.size):
            self.data.store(i, val)

    fn __copyinit__(inout self, rhs: Self):         # 1
        self.cap = rhs.cap
        self.size = rhs.size
        self.data = Pointer[Int].alloc(self.cap)
        for i in range(self.size):
            self.data.store(i, rhs.data.load(i))

    fn __moveinit__(inout self, owned existing: Self):
        print("move")
        # Shallow copy the existing value
        self.cap = existing.cap
        self.size = existing.size
        self.data = existing.data
        # Then the lifetime of `existing` ends here, but
        # Mojo does NOT call its destructor
            
    fn __del__(owned self):
        self.data.free()

    fn append(inout self, val: Int):
        # Update the array for demo purposes
        if self.size < self.cap:
            self.data.store(self.size, val)
            self.size += 1
        else:
            print("Out of bounds")

    fn dump(self):
        print("[", end="")
        for i in range(self.size):
            if i > 0:
                print(", ", end="")
            print(self.data.load(i), end="")
        print("]")

fn main():
    var a = HeapArray(3, 1)
    a.dump()   # => [1, 1, 1]

    # Copy:
    var b = a
    b.dump()   # => [1, 1, 1]
    a.dump()   # => [1, 1, 1]

    b.append(2)  # Changes the copied data
    b.dump()     # => [1, 1, 1, 2]
    a.dump()     # => [1, 1, 1] (the original did not change)

    # Move:
    var c = a^  # => "move"; the lifetime of `a` ends here
    c.dump()    # => [1, 1, 1]
    # a.dump()  # error: use of uninitialized value 'a'

