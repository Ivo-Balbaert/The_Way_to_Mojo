fn main():
    # Cast SIMD:
    let x : UInt8 = 42  # alias UInt8 = SIMD[DType.uint8, 1]
    print(x) # => 42
    let y : Int8 = x.cast[DType.int8]()
    print(y) # => 42
         
    # Cast SIMD to Int
    let w : Int = x.to_int() # `SIMD` to `Int`
    let z : UInt8 = w         # `Int` to `SIMD`
    