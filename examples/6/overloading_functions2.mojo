@value
struct MyString:
    fn __init__(inout self, string: StringLiteral):
        pass

fn foo(name: String):      # 1
    print("String")

fn foo(name: MyString):    # 2
    print("MyString")

fn main():
    var string = "Hello"
    # foo(string) # 3 
    # error: ambiguous call to 'foo', each candidate requires 1 implicit conversion, disambiguate with an explicit cast
    foo(String(string))     # 4 => String
    foo(MyString(string))   # 5 => MyString
