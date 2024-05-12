from random import seed, rand, randint, random_float64, random_si64, random_ui64
from memory import memset_zero

fn main():
    var p1 = DTypePointer[DType.uint8].alloc(8)    # 1
    var p2 = DTypePointer[DType.float32].alloc(8)  # 
    memset_zero(p1, 8)
    memset_zero(p2, 8)
    print('values at p1:', p1.load[width=8](0))
    # => values at p1: [0, 0, 0, 0, 0, 0, 0, 0]
    print('values at p2:', p2.load[width=8](0))
    # => values at p2: [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]

    rand[DType.uint8](p1, 8)        # 2A
    rand[DType.float32](p2, 8)      # 2B
    print('values at p1:', p1.load[width=8](0))
    # => values at p1: [0, 33, 193, 117, 136, 56, 12, 173]
    print('values at p2:', p2.load[width=8](0))
    # => values at p2: [0.93469291925430298, 0.51941639184951782, 0.034572109580039978, 0.52970021963119507, 0.007698186207562685, 0.066842235624790192, 0.68677270412445068, 0.93043649196624756]

    randint[DType.uint8](p1, 8, 0, 10)  # 3
    print(p1.load[width=8](0))
    # => [9, 5, 1, 7, 4, 7, 10, 8]

    print(random_float64(0.0, 1.0)) # 4 => 0.047464513386311948
    print(random_si64(-10, 10)) # 5 => 5
    print(random_ui64(0, 10)) # 6 => 3
