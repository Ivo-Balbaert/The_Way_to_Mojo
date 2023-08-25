@value
struct Coord:
    var x: Int
    var y: Int

fn main():
    let p = Coord(0, 0)
    print(p.y) # => 0