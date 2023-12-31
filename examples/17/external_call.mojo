fn main() raises:
    let eightball = external_call[
        "rand", Int32
    ]()  # => 475566294 # random 4-byte integer
    print(eightball)

    var ts : Int
    ts = external_call["time", Int, Pointer[Int]](Pointer[Int]())
    print(ts)  # => 1698747912

    # time(&ts);
    let tsPtr = Pointer[Int].address_of(ts)
    let ts2 = external_call["time", Int, Pointer[Int]](tsPtr)
    print(ts2)  # => 1698747912
