@value
struct Coord:
    var x: Int
    var y: Int

fn main():
    var t1 = (1, 2, 3)          # type is inferred because of ()
    # var t1 = Tuple(1, 2, 3)  
    var tup = (42, "Mojo", 3.14)
    # var tup: Tuple[Int, StringLiteral, FloatLiteral] = (42, "Mojo", 3.14)
    print(tup.get[0, Int]())    # => 42
    print("Length of the tuple:", len(tup))   # => Length of the tuple: 3

    var x = (Coord(5, 10), 5.5)     # 4
    # Exercise:
    print(return_tuple().get[1, Int]())  # => 2
    
fn return_tuple() -> (Int, Int):    # 5
    return (1, 2)


    