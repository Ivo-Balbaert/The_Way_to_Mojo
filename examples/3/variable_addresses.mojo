from memory.unsafe import Pointer

def print_pointer(ptr: Pointer):
    print(ptr.__as_index())

def main():
    a = 1
    p1 = Pointer.address_of(a)  # => 140726871503576
    print_pointer(p1)

    a = 2
    p2 = Pointer.address_of(a)
    print_pointer(p2)           # => 140726871503576

    b = "mojo"
    p = Pointer.address_of(b) # => 140722059283008
    print_pointer(p)

    c = b  # <- this copies the String object "mojo"
    p = Pointer.address_of(c) # => 140722059283024
    print_pointer(p)