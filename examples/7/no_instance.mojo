struct NoInstances:
    var state: Int
    alias my_int = Int

    @staticmethod
    fn print_hello():
        print("hello world")

fn main():
    NoInstances.print_hello() # => hello world