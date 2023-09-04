struct Point:
    var x: Float64
    var y: Float64
    var z: Float64
    
    fn __init__(inout self, x: Float64, y: Float64, z: Float64):   
        self.x = x
        self.y = y
        self.z = z

fn main():
    var origin = Point(0, 0, 0)
    print(origin.y)  # => 0.0
    origin.x = 3.14
    print(origin.x)  # => 3.1400000000000001
    


