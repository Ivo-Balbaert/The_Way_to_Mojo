fn exec_rt_closure(x: Int, bin_op_cl: fn(Int) escaping -> Int) -> Int:
    var result: Int = 0
    for i in range(10):
        result += bin_op_cl(x)
    return result

fn main():
    var rt_y: Int = 5
    fn ander(x: Int) -> Int: 
        return x & rt_y
    print(exec_rt_closure(12, ander)) # => 40
