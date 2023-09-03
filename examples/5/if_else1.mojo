fn func1():
    let x: Int = 42
    let y: Float64 = 17.0
    let z: Float32   

    if x != 0:       # 1
        z = 1.0      
    else:            # 2
        z = func2()    
    print(z)      # => 1.0

fn func2() -> Float32:     # 3
    return 3.14

fn main():
    func1()
