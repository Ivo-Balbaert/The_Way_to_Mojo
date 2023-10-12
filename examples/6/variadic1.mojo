fn my_func(*args_w: String):  # 1
    let args = VariadicList(args_w)
    for i in range(len(args)):
        # print(args[i])   # error: no matching value in call to print
        print(__get_address_as_lvalue(args[i]))


fn main():
    my_func("hello", "world", "from", "Mojo!")

# =>
# hello
# world
# from
# Mojo!