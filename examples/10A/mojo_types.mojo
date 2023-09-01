# works only in a cell in Jupyter notebook
%%python
def type_printer(my_list, my_tuple, my_int, my_string, my_float):
    print(type(my_list))
    print(type(my_tuple))
    print(type(my_int))
    print(type(my_string))
    print(type(my_float))

type_printer([0, 3], (False, True), 4, "orange", 3.4)

# =>
# <class 'list'>
# <class 'tuple'>
# <class 'int'>
# <class 'str'>
# <class 'float'>