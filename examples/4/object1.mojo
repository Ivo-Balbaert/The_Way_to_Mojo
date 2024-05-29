fn print_object(o: object):
    print(o)


fn add(a: object, b: object) raises -> object:  # 1
    return a + b


fn main() raises:
    var obj = object("hello world")  # a string
    obj = object([])  # change to a list
    obj.append(object(123))  # a list of objects
    obj.append(object("hello world"))
    print_object(obj)  # => [123, 'hello world']
    print(obj)  # => [123, 'hello world']

    print(add(1, 2.5))  # 2 => 3.5
