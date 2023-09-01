fn main():
    return_error()

def return_error():
    raise Error("This returns an Error type") 
    # => Error: This returns an Error type

    var err : Error = Error()
    raise err

    var custom_err : Error = Error("my custom error")
    raise custom_err

    var `ref` : StringRef = StringRef("hello")
    var errref : Error = Error(`ref`)
    raise errref

    var err2 : Error = Error("something is wrong")
    print(err2.value) # 1 => something is wrong

    var err3 : Error = Error("hey")
    var other : Error = err3
    raise other  # => Error: hey





    