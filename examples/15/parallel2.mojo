from algorithm import parallelize
from memory.unsafe import DTypePointer
from sys.info import simdwidthof
import math

alias element_type = DType.int32
alias group_size = simdwidthof[element_type]()
alias groups = 16


fn main():
    var computer_cores = 4

    # initialized array of numbers with random values
    var array = DTypePointer[element_type]().alloc(groups * group_size)

    @parameter
    fn compute_number(x: Int):
        var numbers: SIMD[element_type, group_size]

        # 3 simd instructions:
        numbers = math.iota[element_type, group_size](x * group_size)
        numbers *= numbers
        array.simd_store[group_size](x * group_size, numbers)

    parallelize[compute_number](groups, computer_cores)

    #   parallelize will call compute_number with argument
    #       x= 0,1,2...groups (non-inclusive)

    for i in range(groups * group_size):
        var result = array.load(i)
        print("Index:", i, " = ", result)


# =>
# Index: 0  =  0
# Index: 1  =  1
# Index: 2  =  4
# Index: 3  =  9
# Index: 4  =  16
# Index: 5  =  25
# Index: 6  =  36
# Index: 7  =  49
# Index: 8  =  64
# Index: 9  =  81
# Index: 10  =  100
# Index: 11  =  121
# Index: 12  =  144
# Index: 13  =  169
# Index: 14  =  196
# Index: 15  =  225
# Index: 16  =  256
# Index: 17  =  289
# Index: 18  =  324
# Index: 19  =  361
# Index: 20  =  400
# Index: 21  =  441
# Index: 22  =  484
# Index: 23  =  529
# Index: 24  =  576
# Index: 25  =  625
# Index: 26  =  676
# Index: 27  =  729
# Index: 28  =  784
# Index: 29  =  841
# Index: 30  =  900
# Index: 31  =  961
# Index: 32  =  1024
# Index: 33  =  1089
# Index: 34  =  1156
# Index: 35  =  1225
# Index: 36  =  1296
# Index: 37  =  1369
# Index: 38  =  1444
# Index: 39  =  1521
# Index: 40  =  1600
# Index: 41  =  1681
# Index: 42  =  1764
# Index: 43  =  1849
# Index: 44  =  1936
# Index: 45  =  2025
# Index: 46  =  2116
# Index: 47  =  2209
# Index: 48  =  2304
# Index: 49  =  2401
# Index: 50  =  2500
# Index: 51  =  2601
# Index: 52  =  2704
# Index: 53  =  2809
# Index: 54  =  2916
# Index: 55  =  3025
# Index: 56  =  3136
# Index: 57  =  3249
# Index: 58  =  3364
# Index: 59  =  3481
# Index: 60  =  3600
# Index: 61  =  3721
# Index: 62  =  3844
# Index: 63  =  3969
# Index: 64  =  4096
# Index: 65  =  4225
# Index: 66  =  4356
# Index: 67  =  4489
# Index: 68  =  4624
# Index: 69  =  4761
# Index: 70  =  4900
# Index: 71  =  5041
# Index: 72  =  5184
# Index: 73  =  5329
# Index: 74  =  5476
# Index: 75  =  5625
# Index: 76  =  5776
# Index: 77  =  5929
# Index: 78  =  6084
# Index: 79  =  6241
# Index: 80  =  6400
# Index: 81  =  6561
# Index: 82  =  6724
# Index: 83  =  6889
# Index: 84  =  7056
# Index: 85  =  7225
# Index: 86  =  7396
# Index: 87  =  7569
# Index: 88  =  7744
# Index: 89  =  7921
# Index: 90  =  8100
# Index: 91  =  8281
# Index: 92  =  8464
# Index: 93  =  8649
# Index: 94  =  8836
# Index: 95  =  9025
# Index: 96  =  9216
# Index: 97  =  9409
# Index: 98  =  9604
# Index: 99  =  9801
# Index: 100  =  10000
# Index: 101  =  10201
# Index: 102  =  10404
# Index: 103  =  10609
# Index: 104  =  10816
# Index: 105  =  11025
# Index: 106  =  11236
# Index: 107  =  11449
# Index: 108  =  11664
# Index: 109  =  11881
# Index: 110  =  12100
# Index: 111  =  12321
# Index: 112  =  12544
# Index: 113  =  12769
# Index: 114  =  12996
# Index: 115  =  13225
# Index: 116  =  13456
# Index: 117  =  13689
# Index: 118  =  13924
# Index: 119  =  14161
# Index: 120  =  14400
# Index: 121  =  14641
# Index: 122  =  14884
# Index: 123  =  15129
# Index: 124  =  15376
# Index: 125  =  15625
# Index: 126  =  15876
# Index: 127  =  16129
