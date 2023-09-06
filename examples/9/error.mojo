fn main() raises:
    print(return_error())

def return_error():
    raise Error("This signals an important error!")   # 1
    # => Error: This signals an important error!
    # Program exits

    # Following code commented out because it will not execute
    # var err : Error = Error()
    # raise err

    # var custom_err : Error = Error("my custom error")
    # raise custom_err

    # var `ref` : StringRef = StringRef("hello")
    # var errref : Error = Error(`ref`)
    # raise errref

    # var err2 : Error = Error("something is wrong")
    # print(err2.value) # => something is wrong

    # var err3 : Error = Error("hey")
    # var other : Error = err3
    # raise other  # => Error: hey





    