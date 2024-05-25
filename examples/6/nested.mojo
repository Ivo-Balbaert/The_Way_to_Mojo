fn outer():
    fn nested():
        print("I am nested")

    nested()


fn main():
    outer()  # => I am nested