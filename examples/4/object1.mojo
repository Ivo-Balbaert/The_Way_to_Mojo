fn print_object(o: object):
    print(o)

fn main() raises:
    var obj = object("hello world")     # a string
    obj = object([])                    # change to a list
    obj.append(object(123))             # a list of objects
    obj.append(object("hello world"))
    print_object(obj)   # => [123, 'hello world']
