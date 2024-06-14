from python import Python


fn main() raises:
    # Create a mixed-type Python list
    var py_list = Python.evaluate("[42, 'cat', 3.14159]")
    for py_obj in py_list:  # Each element is of type "PythonObject"
        print(py_obj)
    # =>
    # 42
    # cat
    # 3.14159

    # Iterating over a Python dict:
    # Create a mixed-type Python dictionary
    var py_dict = Python.evaluate("{'a': 1, 'b': 2.71828, 'c': 'sushi'}")
    for py_key in py_dict:  # Each element is of type "PythonObject"   # 1
        print(py_key, py_dict[py_key])
    # =>
    # a 1
    # b 2.71828
    # c sushi
    for py_tuple in py_dict.items():  # Each element is of type "PythonObject"
        print(py_tuple[0], py_tuple[1])
    # =>
    # a 1
    # b 2.71828
    # c sushi
