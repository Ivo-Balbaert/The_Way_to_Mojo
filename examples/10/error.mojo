fn main() raises:
    print(return_error())

def return_error():
    raise Error("This signals an important error!")   # 1
    # => Error: This signals an important error!
    # Program exits



    