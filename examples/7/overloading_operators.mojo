struct Rectangle:
    var length: Float32
    var width: Float32

    fn __init__(inout self, length: Float32, width: Float32):
        self.length = length
        self.width = width
        print("Rectangle created with length:", self.length, "and width:", self.width)

    fn area(self) -> Float32:
        var area: Float32 = self.length * self.width
        print("The area of the rectangle is:", area)
        return area
    
    fn area(self, side: Float32) -> Float32:
        var area: Float32 = side * side
        print("The area of the square is:", area)
        return area

    fn perimeter(self) -> Float32:
        var perimeter: Float32 = 2 * (self.length + self.width)
        print("The perimeter of the rectangle is:", perimeter)
        return perimeter

    fn __add__(self, other: Rectangle) -> Rectangle:    # 1
        return Rectangle(self.length + other.length, 
                self.width + other.width)

fn main():
    var square = Rectangle(10.0, 10.0)
    # => Rectangle created with length: 10.0 and width: 10.0
    var rect = Rectangle(5.0, 7.0)
    # => Rectangle created with length: 5.0 and width: 7.0
    var squareArea = square.area()
    # => The area of the rectangle is: 100.0
    var squareArea2 = square.area(10.0)
    # => The area of the square is: 100.0
    var rect2 = square + rect                   # 2
    # => Rectangle created with length: 15.0 and width: 17.0
    # this is the same as calling:              
    var rect2b = square.__add__(rect)           # 3
    # => Rectangle created with length: 15.0 and width: 17.0
