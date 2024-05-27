alias n_numbers = 5
alias precalculated = squared(n_numbers)     # 1
alias MY_VALUE = add(2, 3)                   # 1B
alias QUOTE = ord('"')                       # 1C

fn squared(n: Int) -> Pointer[Int]:
    var tmp = Pointer[Int].alloc(n)
    for i in range(n):
        tmp.store(i, i * i)
    return tmp

fn add(a: Int, b: Int) -> Int:
    return a + b

fn main():
    # var precalculated = squared(n_numbers) # 2
    for i in range(n_numbers):
        print(precalculated.load(i))

    print(MY_VALUE) # => 5
    print(QUOTE) # => 34
 

# =>
# 0
# 1
# 4
# 9
# 16
# 5
