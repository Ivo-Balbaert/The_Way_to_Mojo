fn main() raises:
    var eightball = external_call[  # 1
        "rand", Int32
    ]()  
    print(eightball) # => 475566294 # random 4-byte integer

    var ts : Int
    ts = external_call["time", Int, Pointer[Int]](Pointer[Int]())
    print(ts)  # => 1698747912

    # time(&ts);
    var tsPtr = Pointer[Int].address_of(ts)
    var ts2 = external_call["time", Int, Pointer[Int]](tsPtr)
    print(ts2)  # => 1698747912
