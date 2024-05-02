fn repeat[count: Int](msg: String):
    for i in range(count):
        print(msg)

fn main():
     repeat[3]("Hello")
    # => Hello
    # Hello
    # Hello
