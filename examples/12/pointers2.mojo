from memory.unsafe import Pointer
from memory import memset_zero

@register_passable
struct Coord:
    var x: UInt8 
    var y: UInt8

struct Coords:
    var data: Pointer[Coord]
    var length: Int

    fn __init__(inout self, length: Int) raises:
        self.data = Pointer[Coord].alloc(length)
        memset_zero(self.data, length)
        self.length = length

    fn __getitem__(self, index: Int) raises -> Coord:
        if index > self.length - 1:
            raise Error("Trying to access index out of bounds")
        return self.data.load(index)

    fn __del__(owned self):
        return self.data.free()

fn main() raises:
# when uncommented => error
    # let coords = Coords(5)
    # print(coords[5].x)

# =>
# Unhandled exception caught during execution: Trying to access index out of bounds
# mojo: error: execution exited with a non-zero result: 1
