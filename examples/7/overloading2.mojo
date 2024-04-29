struct Rectangle:
    var width: Float32
    var height: Float32

    fn __init__(inout self, w: Float32, h: Float32):
        """Construct a rectangle given its width and height."""
        self.width = w
        self.height = h

    fn __init__(inout self, other: Rectangle):
        """Construct a rectangle by copying another one."""
        self.width = other.width
        self.height = other.height

    fn display(self: Self):
        print("width: ", self.width, "height: ", self.height)

fn main():
    # Constructing a rectangle with width 10.0 and height 20.0
    var rectangle1 = Rectangle(10.0, 20.0)  
    rectangle1.display()
    # => width:  10.0 height:  20.0
    # Constructing a rectangle by copying rectangle1
    var rectangle2 = Rectangle(rectangle1)  
    rectangle2.display()
    # => width:  10.0 height:  20.0
