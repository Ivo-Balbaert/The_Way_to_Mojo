from memory import memset_zero

@register_passable
struct Coord:
    var x: UInt8 
    var y: UInt8

    fn __copyinit__(inout self, rhs: Self):         
        self.x = rhs.x
        self.y = rhs.y
    
fn main():
    var p1 = Pointer[Coord].alloc(2)   # 1
    var p2 = Pointer[Coord].alloc(2)

    memset_zero(p1, 2)                 # 2 
    memset_zero(p2, 2)

    # Operations with pointers:
    if p1:                             # 3
        print("p1 is not null") # => p1 is not null

    print("p1 and p2 are equal:", p1 == p2) 
    # 4 => p1 and p2 are equal: False
    print("p1 and p2 are not equal:", p1 != p2) 
    # => p1 and p2 are not equal: True

# error: 'Coord' is not copyable because it has no '__copyinit__'  
    var coord = p1[0]
    print(coord.x) # => 0

    coord.x = 5
    coord.y = 5
    print(coord.x) # => 5
    print(p1[0].x) # => 0

    p1.store(0, coord)
    print(p1[0].x) # => 5

    coord.x += 5
    coord.y += 5
    p1.store(1, coord)
    for i in range(2):
        print(p1[i].x)
        print(p1[i].y)
    # =>
    # 5
    # 5
    # 10
    # 10
    
    # undefined behavior:
    var third_coord = p1.load(2)
    print(third_coord.x)  # => 7
    print(third_coord.y)  # => 7

    p1 += 2
    for i in range(2):
        print(p1[i].x)
        print(p1[i].y)
# =>
# 0
# 0
# 0
# 0
    p1 -= 2
    p1.free()

