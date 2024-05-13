fn main() raises:
    var f = open("my_file.txt", "r")
    print(f.read())     # => I like Mojo!
    f.close()   

    # creating a context:
    with open("my_file.txt", "r") as f:
        print(f.read()) # => I like Mojo!