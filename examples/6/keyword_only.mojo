fn kw_only_args(a1: Int, a2: Int, *, double: Bool = True) -> Int:
    var product = a1 * a2
    if double:
        return product * 2
    else:
        return product

fn main():
    print(kw_only_args(a1=2, a2=3))
    print(kw_only_args(a1=2, a2=3, double = True)) # => 12

    # if double doesn't have a default value: error: positional argument follows keyword argumentmojo
    