@value
@register_passable
struct Coord:
    var x: Int
    var y: Int

fn main():
    var x = (Coord(5, 10), 5.5)
    print(x.get[0, Coord]().x) # => 5