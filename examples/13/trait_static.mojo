trait Message:
    @staticmethod
    fn default_message():
        ...


struct Hello(Message):
    fn __init__(inout self):
        ...

    @staticmethod
    fn default_message():
        print("Hello World")


struct Bye(Message):
    fn __init__(inout self):
        ...

    @staticmethod
    fn default_message():
        print("Goodbye")


fn main():
    Hello.default_message() # => Hello World
    Bye.default_message()   # => Goodbye
