fn main():
    var `var` : Int = 1
    var `with space`: Int = 2

    fn `with#symbol`() -> Int:
        return 3

    print(`var`)            # => 1
    print(`with space`)     # => 2
    print(`with#symbol`())  # => 3  