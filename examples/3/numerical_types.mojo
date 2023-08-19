fn main():
    ## integers:
    let i: Int = 2 
    print(i)
    # let j: Int = 3.14  # error: cannot implicitly convert 'FloatLiteral' value to 'Int'
    # let j = Int(3.14)  # error: cannot construct 'Int' from 'FloatLiteral' value in 'let' 

    # use as indexes:
    var vec_2 = DynamicVector[Int]()
    vec_2.push_back(2)
    vec_2.push_back(4)
    vec_2.push_back(6)

    print(vec_2[i])  # => 6

    ## floats:
    let float: FloatLiteral = 3.3
    print(float)  # => 3.2999999999999998
    let f32 = Float32(float)  # 1
    print(f32) # => 3.2999999523162842
    let f2 = FloatLiteral(i)
    print(f2) # => 2.0
    let f3 = Float32(i)
    print(f3) # => 2.0
    
    # let i2 = Int(float) # convert error
    # let i2 = Int(f32) # convert error


    