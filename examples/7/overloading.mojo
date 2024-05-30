"""
This module defines a complex number struct
"""
struct Complex:
    var re: Float32
    var im: Float32

    fn __init__(inout self, x: Float32):
        """Construct a complex number given a real number."""
        self.re = x
        self.im = 0.0

    fn __init__(inout self, r: Float32, i: Float32):
        """Construct a complex number given its real and imaginary components."""
        self.re = r
        self.im = i

fn main():
    var c1 = Complex(7)
    print (c1.re)  # => 7.0
    print (c1.im)  # => 0.0
    var c2 = Complex(42.0, 1.0)
    c2.im = 3.14
    print (c2.re)  # => 42.0
    print (c2.im)  # => 3.1400001049041748

    


