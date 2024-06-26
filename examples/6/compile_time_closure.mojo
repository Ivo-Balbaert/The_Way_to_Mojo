fn exec_ct_closure[bin_op_cl: fn (Int) capturing -> Int](x: Int) -> Int:
    var result: Int = 0
    for i in range(10):
        result += bin_op_cl(x)
    return result


fn main():
    var ct_y: Int = 10

    @parameter
    fn multer(x: Int) -> Int:
        return x * ct_y

    print(exec_ct_closure[multer](10))  # => 1000
