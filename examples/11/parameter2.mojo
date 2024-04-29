fn add_print[a: Int, b: Int](): 
    @parameter
    fn add[a: Int, b: Int]() -> Int:
        return a + b

    var x = add[a, b]()
    print(x)

fn main():
    add_print[5, 10]()  # => 15
