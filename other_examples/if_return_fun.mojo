def func2():
    let x: Int = 42
    let y: Float64 = 17.0

    let z: Float32   # 1
    if x != 0:
        z = 1.0      # 2
    else:
        z = foo()    # 3
    print(z)         # => 1.0

def foo() -> Float32:
    return 3.14

def main():
    func2()