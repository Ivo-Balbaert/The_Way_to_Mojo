fn main() raises:
    var x = PythonObject([])
    _ = x.append("hello")
    _ = x.append(1.1)
    var s: String = x[0]          # x[0].__str__()
    var f: Float64 = x[1].to_float64()
    print(x)  # => ['hello', 1.1]
