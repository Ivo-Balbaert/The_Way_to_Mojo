struct Target:
    fn __init__(inout self, s: Source):
        ...


@value
struct Source:
    pass


fn main():
    var a = Source()
    var b: Target = a  # 1
    var c = Target(a)  # 2
