def foo():
    pass


def bar():
    pass


fn main() raises:
    with open("my_file.txt", "r") as file:
        print(file.read())  # => This is the contents of my_file.

        # Other stuff happens here (whether using `file` or not)...
        foo()
    # `file` is alive up to the end of the `with` statement.

    # `file` is destroyed when the statement ends.
    bar()
