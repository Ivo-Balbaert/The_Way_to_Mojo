fn greet(times: Int = 1, message: String = "!!!"):  # 1
    for i in range(times):
        print("Hello " + message)


fn main():
    greet()                    # => Hello !!!
    greet(message = "Mojo")    # 2 => Hello Mojo
    greet(times = 2)           # 3 => Hello !!!
                               # => Hello !!!
