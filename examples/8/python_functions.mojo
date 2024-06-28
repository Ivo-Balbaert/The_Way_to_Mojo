from python import Python

fn main() raises:
    var a_list = Python.list()
    a_list.append("First element")
    a_list.append("Second element")
    print(a_list)  # => ['First element', 'Second element']
    print(Python.type(a_list))  # => <class 'list'>
