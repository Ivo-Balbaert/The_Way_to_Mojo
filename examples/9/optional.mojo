from collections import Optional


fn main():
    # Two ways to initialize an Optional with a value
    var opt1 = Optional(5)  # 1
    var opt2: Optional[Int] = 5
    # Two ways to initalize an Optional with no value
    var opt3 = Optional[Int]()
    var opt4: Optional[Int] = None

    var opt: Optional[String] = str("Testing")
    if opt:  # 2
        var value_ref = opt.value()
        print(value_ref[])  # => Testing

    var custom_greeting: Optional[String] = None
    print(custom_greeting.or_else("Hello"))  # => Hello

    custom_greeting = str("Hi")
    print(custom_greeting.or_else("Hello"))  # => Hi
