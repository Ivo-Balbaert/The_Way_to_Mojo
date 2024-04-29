struct Array[T: AnyRegType]:                           # 1
    var data: Pointer[T]
    var size: Int
    var cap: Int

    fn __init__(inout self, size: Int, value: T):   # 2
        self.cap = size * 2
        self.size = size
        self.data = Pointer[T].alloc(self.cap)      # 4
        for i in range(self.size):
            self.data.store(i, value)               # 5
              
    fn __getitem__(self, i: Int) -> T:
        return self.data.load(i)            # 7

    fn __del__(owned self):
        self.data.free()                    # 6

fn main():
    var v = Array[Float32](4, 3.14)         # 3
    print(v[0], v[1], v[2], v[3])
    # => 3.1400001049041748 3.1400001049041748 3.1400001049041748 3.1400001049041748