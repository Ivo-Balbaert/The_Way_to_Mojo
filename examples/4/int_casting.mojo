fn main():
    var n = UInt8(42)  # 1
    print(n)  # => 42
    var x: UInt8 = 42  # 2
    print(x)  # => 42
    var y: Int8 = x.cast[DType.int8]()  # 3
    print(y)  # => 42

    var w: Int = int(x)  # 4: `SIMD` to `Int`
    print(x)  # => 42
    var z: UInt8 = w  # 5: `Int` to `SIMD`
