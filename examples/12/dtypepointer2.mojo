from memory.unsafe import DTypePointer
from random import rand
from memory import memset_zero

struct Matrix:
    var data: DTypePointer[DType.uint8]

    fn __init__(inout self):
        "Initialize the struct and set everything to zero."
        self.data = DTypePointer[DType.uint8].alloc(64)
        memset_zero(self.data, 64)

    fn __del__(owned self):
        return self.data.free()

    # This allows you to use let x = obj[1]
    fn __getitem__(self, row: Int) -> SIMD[DType.uint8, 8]:
        return self.data.simd_load[8](row * 8)

    # This allows you to use obj[1] = SIMD[DType.uint8]()
    fn __setitem__(self, row: Int, data: SIMD[DType.uint8, 8]):
        return self.data.simd_store[8](row * 8, data)

    fn print_all(self):
        print("--------matrix--------")
        for i in range(8):
            print(self[i])

fn main():
    let matrix = Matrix()       # 1
    matrix.print_all()
# =>
# --------matrix--------
# [0, 0, 0, 0, 0, 0, 0, 0]
# [0, 0, 0, 0, 0, 0, 0, 0]
# [0, 0, 0, 0, 0, 0, 0, 0]
# [0, 0, 0, 0, 0, 0, 0, 0]
# [0, 0, 0, 0, 0, 0, 0, 0]
# [0, 0, 0, 0, 0, 0, 0, 0]
# [0, 0, 0, 0, 0, 0, 0, 0]
# [0, 0, 0, 0, 0, 0, 0, 0]

    for i in range(8):      # 2
        matrix[i] = i

    matrix.print_all()
# =>
# --------matrix--------
# [0, 0, 0, 0, 0, 0, 0, 0]
# [1, 1, 1, 1, 1, 1, 1, 1]
# [2, 2, 2, 2, 2, 2, 2, 2]
# [3, 3, 3, 3, 3, 3, 3, 3]
# [4, 4, 4, 4, 4, 4, 4, 4]
# [5, 5, 5, 5, 5, 5, 5, 5]
# [6, 6, 6, 6, 6, 6, 6, 6]
# [7, 7, 7, 7, 7, 7, 7, 7]

    for i in range(8):
        matrix[i][0] = 9
        matrix[i][7] = 9

    matrix.print_all()
# =>
# --------matrix--------
# [9, 0, 0, 0, 0, 0, 0, 9]
# [9, 1, 1, 1, 1, 1, 1, 9]
# [9, 2, 2, 2, 2, 2, 2, 9]
# [9, 3, 3, 3, 3, 3, 3, 9]
# [9, 4, 4, 4, 4, 4, 4, 9]
# [9, 5, 5, 5, 5, 5, 5, 9]
# [9, 6, 6, 6, 6, 6, 6, 9]
# [9, 7, 7, 7, 7, 7, 7, 9]

    var fourth_row = matrix[3]
    print("\nfourth row:", fourth_row)
# => fourth row: [9, 3, 3, 3, 3, 3, 3, 9]
    fourth_row *= 2
    print("modified:", fourth_row, "\n")
# => modified: [18, 6, 6, 6, 6, 6, 6, 18] 
    matrix[0] = fourth_row
    matrix.print_all()
# =>
# --------matrix--------
# [18, 6, 6, 6, 6, 6, 6, 18]
# [9, 1, 1, 1, 1, 1, 1, 9]
# [9, 2, 2, 2, 2, 2, 2, 9]
# [9, 3, 3, 3, 3, 3, 3, 9]
# [9, 4, 4, 4, 4, 4, 4, 9]
# [9, 5, 5, 5, 5, 5, 5, 9]
# [9, 6, 6, 6, 6, 6, 6, 9]
# [9, 7, 7, 7, 7, 7, 7, 9]