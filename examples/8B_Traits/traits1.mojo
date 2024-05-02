trait SomeTrait:
    fn required_method(self, n: Int): ...

@value
struct SomeStruct(SomeTrait):
    fn required_method(self, n: Int):
        print("hello traits", n)   # => hello traits 42

fn fun_with_traits[T: SomeTrait](x: T):  # 2
    x.required_method(42)

fn main():
    var thing = SomeStruct()
    fun_with_traits(thing)  # 1