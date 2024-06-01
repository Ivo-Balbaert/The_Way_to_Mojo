struct Person:
    var name: String

    fn __init__(inout self, name: StringLiteral):
        self.name = name

    fn get_name(self) -> String:
        return self.name


fn main():
    var v: Person = "Sue Jenkins"
    print(v.get_name())  # => Sue Jenkins
