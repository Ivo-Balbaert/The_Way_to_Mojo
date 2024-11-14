# parametrized function:
fn repeat[count: Int](msg: String):
    @parameter
    for i in range(count):
        print(msg, end=" - ")

# a generic parametrized function:
fn repeat[MsgType: Stringable, count: Int](msg: MsgType):
    @parameter
    for i in range(count):
        print(msg, end=" - ")

fn main():
    repeat[3]("Hello") # => Hello - Hello - Hello - 

    print()
    # Must use keyword parameter for `count`
    repeat[count=2](42) # => 42 - 42 - 
