from python import python

alias str = PythonObject
alias float = PythonObject

fn main() raises:
    var f: float = 0.6
    print(f.hex())  # => 0x1.3333333333333p-1
    # f is a Python `float` object

    var s1: str = "xxbaaa"
    print(s1.upper())  # => XXBAAA
    # s1 is a Python `str` object

    # Translate Python str to Mojo String
    var s2 : String = s1.__str__()
    print(s2) # => xxbaaa
    # does NOT work for int with to_int(), float with to_float()