fn main() raises:
    let x = PythonObject([])
    _ = x.append("hello")
    _ = x.append(1.1)
    let s: String = x[0].to_string()
    let f: Float64 = x[1].to_float64()
    print(x)  # => ['hello', 1.1]
