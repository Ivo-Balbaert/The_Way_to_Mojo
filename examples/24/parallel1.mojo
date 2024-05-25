from algorithm import parallelize


fn main():
    @parameter
    fn compute_number(x: Int):
        print(x * x, " - ", end="")

    var num_work_items = 16
    var num_workers = 4

    parallelize[compute_number](num_work_items, num_workers)

# => # => 0  - 1  - 4  - 9  - 64  - 81  - 100  - 121  - 144  - 169  - 196  - 22516  -   - 25  - 36  - 49  - 

# => another run:
# 016  -  25 -  1 -  36 -  4 -  64 - 49  9 -  -  81 -   - 100  - 121  - 144  - 169  - 196  - 225  - 

