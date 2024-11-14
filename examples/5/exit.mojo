from sys.ffi import external_call


fn main():
    print("before exit")  # => before exit
    _ = exit(-2)
    print("after exit")


fn exit(status: Int32) -> UInt8:
    return external_call["exit", UInt8, Int32](status)
