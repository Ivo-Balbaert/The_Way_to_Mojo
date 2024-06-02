trait Polygon:
    fn area(self):
        ...


struct Rectangle(Polygon):
    var length: Int
    var width: Int

    fn __init__(inout self, length: Int, width: Int):
        self.length = length
        self.width = width

    fn area(self):
        print("The area of the rectangle is:", self.length * self.width)


struct Square(Polygon):
    var side: Int

    fn __init__(inout self, side: Int):
        self.side = side

    fn area(self):
        print("The area of the square is:", self.side**2)


# generic function:
fn calc_array[T: Polygon](x: T):
    x.area()


fn main():
    var r1 = Rectangle(4, 5)
    r1.area()  # => The area of the rectangle is: 20
    var s1 = Square(4)
    s1.area()  # => The area of the square is: 16

    calc_array(r1)  # => The area of the rectangle is: 20
    calc_array(s1)  # => The area of the square is: 16
