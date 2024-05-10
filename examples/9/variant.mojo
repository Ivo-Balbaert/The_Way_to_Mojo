from utils import Variant

alias IntOrString = Variant[Int, String]   # 1

fn to_string(inout x: IntOrString) -> String:
    if x.isa[String]():                    # 2
        return x.get[String]()[]
    # x.isa[Int]()
    return x.get[Int]()[]

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