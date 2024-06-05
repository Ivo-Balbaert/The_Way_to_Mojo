fn raise_error(cond: Bool) raises:
    if cond:
        print("No error, everything ok")
    else:
        raise Error("Provided condition is False")


fn call_possible_error() raises:
    raise_error(False)


fn main():
    try:
        call_possible_error()
    except e:
        print("Error raised:", e)  # => Error raised: Provided condition is False
    else:
        print("No exception raised.")   
    finally:
        print("Always executed")   # => Always executed
