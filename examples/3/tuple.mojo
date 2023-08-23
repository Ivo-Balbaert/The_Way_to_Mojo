fn main():
    let tup = (42, "Mojo", 3)
    print(tup.get[0, Int]())    # => 42
    # ?? print(return_tuple())  # => 

fn return_tuple() -> (Int, Int):
    return (1, 2)


    