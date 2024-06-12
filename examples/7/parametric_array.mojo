from memory.unsafe_pointer import UnsafePointer, initialize_pointee_copy, destroy_pointee

struct GenericArray[ElementType: CollectionElement]:
    var data: UnsafePointer[ElementType]
    var size: Int

    fn __init__(inout self, *elements: ElementType):
        self.size = len(elements)
        self.data = UnsafePointer[ElementType].alloc(self.size)
        for i in range(self.size):
            initialize_pointee_move(self.data.offset(i), elements[i])

    fn __del__(owned self):
        for i in range(self.size):
            destroy_pointee(self.data.offset(i))
        self.data.free()

    fn __getitem__(self, i: Int) raises -> ref [__lifetime_of(self)] ElementType:
        if (i < self.size):
            return self.data[i]
        else:
            raise Error("Out of bounds")

fn main() raises:
    var array = GenericArray[Int](1, 2, 3, 4)
    for i in range(array.size):
        print(array[i], end=" ")  # => 1 2 3 4
    
