fn main() raises:
    var x = PythonObject([])
    x.append("hello")
    x.append(1.1)
    var s = x[0]          # same as x[0].__str__()
    var f = x[1].to_float64()  # var f: Float64 = ...
    print(x)  # => ['hello', 1.1]
