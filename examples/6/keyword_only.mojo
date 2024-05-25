fn kw_only_args(a1: Int, a2: Int, *, double: Bool = True) -> Int:
    var product = a1 * a2
    if double:
        return product * 2
    else:
        return product

fn main():
    print(kw_only_args(2, 3))                       # => 12
    # print(kw_only_args(2, 3, False))                # error: invalid call to 'kw_only_args': expected at most 2 positional arguments, got 3
    print(kw_only_args(a1=2, a2=3))                 # => 12
    print(kw_only_args(a1=2, a2=3, double = False)) # => 6

    # if double doesn't have a default value: error: positional argument follows keyword argumentmojo
    