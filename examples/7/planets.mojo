@value
@register_passable
struct Planet:
    var mass: Int
    # fn __init__(inout self):
    #     self.mass = 200

    # fn __init__(inout self, mass: Int):
    #     self.mass = mass

    # fn __copyinit__(inout self, existing: Self):
    #     self.mass = existing.mass

    # fn __moveinit__(inout self, owned existing: Self):
    #     self.mass = existing.mass

fn is_gas_giant(p: Planet) -> Bool:
    return p.mass > 400

fn make_larger(owned p: Planet):
    p.mass *= 2

fn main():
    var rocky = Planet(300)
    print(rocky.mass)
# => 300
    print(is_gas_giant(rocky)) # => False
    make_larger(rocky^)
    # print(rocky.mass) # => 600

    var planets = List[Planet]()
    planets.append(Planet(200))
    planets.append(Planet(500))
    # print(planets2) # => [200, 500]
    # for planet in planets:   # error: 
    #     print(planet)
    for i in range(len(planets)):
        print(planets[i].mass)
    # => 100