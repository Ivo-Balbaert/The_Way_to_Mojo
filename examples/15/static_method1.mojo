struct Helpers:
    @staticmethod
    fn is_even(value: Int) -> Bool:
        return (value & 1) == 0

fn main():
    var x = 2
    print(Helpers.is_even(x))   # => True
