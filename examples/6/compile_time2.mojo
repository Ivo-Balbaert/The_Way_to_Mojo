fn squared(n: Int) -> Pointer[Int]:
    var tmp = Pointer[Int].alloc(n)
    for i in range(n):
        tmp.store(i, i * i)
    return tmp

alias n_numbers = 5
alias precalculated = squared(n_numbers)     # 1

fn main():
    # var precalculated = squared(n_numbers) # 2

    for i in range(n_numbers):
        print(precalculated.load(i))

# =>
# 0
# 1
# 4
# 9
# 16
