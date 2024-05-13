from utils import Variant

alias IntOrString = Variant[Int, String]   # 1

fn to_string(inout x: IntOrString) -> String:
    if x.isa[String]():                    # 2
        return x.get[String]()[]
    # x.isa[Int]()
    return x.get[Int]()[]

fn print_value(value: Variant[Int, Float64], end: StringLiteral) -> None:
    if value.isa[Int]():
        print(value.get[Int]()[], end=end)
    else:
        print(value.get[Float64]()[], end=end)

fn main():
    # They have to be mutable for now, and implement CollectionElement
    var an_int = IntOrString(4)
    var a_string = IntOrString(String("I'm a string!"))
    var who_knows = IntOrString(0)
    import random
    if random.random_ui64(0, 1):
        who_knows.set[String]("I'm actually a string too!")

    print(to_string(an_int))    # =>  4
    print(to_string(a_string))  # =>I'm a string!
    print(to_string(who_knows)) # =>0

    var a = List[Variant[Int, Float64]](1, 2.5, 3, 4.5, 5)  # 2A
    var b = List[Variant[Int, StringLiteral]](1, "Hi", 3, "Hello", 5)   # 2B
    print("List(", end="")
    for i in range(len(a) - 1):
        print_value(a[i], ", ")
    print_value(a[-1], "")
    print(")") # => List(1, 2.5, 3, 4.5, 5)