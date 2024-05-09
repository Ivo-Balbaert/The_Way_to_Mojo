fn my_func(*args_w: String):  # 1
    for i in args_w:
        print(i[]) 
    # var args = VariadicList(args_w)
    # for i in range(len(args)):
    #     pass
        # invalid call to '__getitem__': result cannot bind AnyRegType type to memory-only type 'VariadicListMem[String, 0, args_w]'
        # print(args.__getitem__(i))
        # print(args[i])   # error: no matching value in call to print

fn main():
    my_func("hello", "world", "from", "Mojo!")

# =>
# hello
# world
# from
# Mojo!