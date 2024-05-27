alias FType = Float32              # 1
alias MyInt = Int

fn add(a: MyInt, b: MyInt) -> MyInt:
    return a + b

fn main():
    alias MojoArr = DTypePointer[DType.float32] 
    var f1: FType = 3.1415
    var f2: MojoArr

    print(add(1, 2)) # => 3