@register_passable("trivial")
struct MyInt:
    """A type that is implicitly convertible to `Int`."""

    var value: Int

    @always_inline("nodebug")
    fn __init__(inout self, _a: Int):
        self.value = _a


fn foo[x: MyInt, a: Int]():
    print("foo[x: MyInt, a: Int]()")


fn foo[x: MyInt, y: MyInt]():
    print("foo[x: MyInt, y: MyInt]()")


fn bar[a: Int](b: Int):
    print("bar[a: Int](b: Int)")


fn bar[a: Int](*b: Int):
    print("bar[a: Int](*b: Int)")


fn bar[*a: Int](b: Int):
    print("bar[*a: Int](b: Int)")


fn parameter_overloads[a: Int, b: Int, x: MyInt]():
    # `foo[x: MyInt, a: Int]()` is called because it requires no implicit
    # conversions, whereas `foo[x: MyInt, y: MyInt]()` requires one.
    foo[x, a]()

    # `bar[a: Int](b: Int)` is called because it does not have variadic
    # arguments or parameters.
    bar[a](b)

    # `bar[*a: Int](b: Int)` is called because it has variadic parameters.
    bar[a, a, a](b)


fn main():
    parameter_overloads[1, 2, MyInt(3)]()


# foo[x: MyInt, a: Int]()
# bar[a: Int](b: Int)
# bar[*a: Int](b: Int)
