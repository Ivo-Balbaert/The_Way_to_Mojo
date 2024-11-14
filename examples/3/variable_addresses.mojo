from memory.unsafe_pointer import UnsafePointer


def print_pointer(ptr: UnsafePointer):
    print(ptr.__int__())


def main():
    a = 1
    p1 = UnsafePointer.address_of(a)  # => 140726871503576
    print_pointer(p1)

    a = 2
    p2 = UnsafePointer.address_of(a)
    print_pointer(p2)  # => 140726871503576

    b = "mojo"
    p = UnsafePointer.address_of(b)  # => 140722059283008
    print_pointer(p)

    c = b  # <- this copies the String object "mojo"
    p = UnsafePointer.address_of(c)  # => 140722059283024
    print_pointer(p)
