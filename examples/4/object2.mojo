def modify(a):
    # argument given by copy in Mojo `def`, but one can modify the referenced list
    a[0] = 1


def main():
    a = object([0])
    b = a  # <- the reference is copied, but not the pointed list

    print(a)  # => [0]
    modify(a)
    print(a)  # => [1]
    print(b)  # => [1]
