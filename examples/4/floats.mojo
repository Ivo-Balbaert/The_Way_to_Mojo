fn main():
    var i: IntLiteral = 2
    var x = 10.0
    print(x)  # => 10.0
    var float: FloatLiteral = 3.3
    print(float)  # => 3.2999999999999998
    var f32 = Float32(float)  # 1
    print(f32)  # => 3.2999999523162842
    var f2 = FloatLiteral(i)  # 2
    print(f2)  # => 2.0
    var f3 = Float32(i) # 3
    print(f3)  # => 2.0

    var a = 40.0
    a += 2.0
    print(a)  # => 42.0

    # Conversions:
    # var j: Int = 3.14  # error: cannot implicitly convert 'FloatLiteral' value to 'Int'
    # var j = Int(3.14)  # error: cannot construct 'Int' from 'FloatLiteral' value in 'var'
    # var i2 = Int(float) # convert error
    # var i2 = Int(f32) # convert error

    var j = (3.14).__int__()
    print(j)  # => 3 