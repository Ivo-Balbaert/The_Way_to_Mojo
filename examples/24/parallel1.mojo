from algorithm import parallelize


fn main():
    @parameter
    fn compute_number(x: Int):
        print(x * x, " - ", end="")

    var stop_at = 16
    var cores = 4

    # start at 0, end at stop_at (non inclusive)
    parallelize[compute_number](stop_at, cores)

# => 0  - 1  - 4  - 9  - 6416  -  81 -   - 25100   -  - 36121   - 144 - 49  -   
# - 169  - 196  - 225  - 

# => another run:
# 0  - 16164   -   -  - 42581    -  - 144 - 910036    - 121 -   -  - 169   -  - 19649   -
#  - 225  - 

