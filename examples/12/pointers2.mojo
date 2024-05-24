from memory import memset_zero



@value
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
        if index >= self.length:
            raise Error("Trying to access index out of bounds")
        return self.data.load(index)

    fn __setitem__(inout self, index: Int, value: Coord) raises:
        if index >= self.length:
            raise Error("Trying to access index out of bounds")
        self.data.store(index, value)
       
    fn __del__(owned self):
        return self.data.free()

fn main() raises:
    var coords = Coords(5)

    var coord1 = Coord(1, 2)
    var coord2 = Coord(3, 4)
    var coord3 = Coord(5, 6)
    coords[0] = coord1
    coords[1] = coord2
    print(coords[0].x, coords[0].y, coords[1].x, coords[1].y,) # => 1 2 3 4

    coords[1] = coord3
    print(coords[0].x, coords[0].y, coords[1].x, coords[1].y,) # => 1 2 5 6


# when uncommented => error
    # var coords = Coords(5)
    # print(coords[5].x)

# =>
# Unhandled exception caught during execution: Trying to access index out of bounds
# mojo: error: execution exited with a non-zero result: 1
