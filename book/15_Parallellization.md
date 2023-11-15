# 15 - Parallellization
Parallellization of code means: code executes in multiple threads inside one process (multithreading). This in contrast to how Python does parallelization, where multiple Python processes each execute one thread.

## 15.1 - The parallellize function
This function comes from the algorithm module, see [Docs](https://docs.modular.com/mojo/stdlib/algorithm/functional.html#parallelize)

### 15.1.1 No SIMD example
?? use num_tasks instead of num_workers

The autobus analogy:
With only one instruction, we can calculate the entire autobus in the same amount of time it would have taken to calculate a single number in a non-simd way.

See `parallel1.mojo`:
```mojo
from algorithm import parallelize


fn main():
    @parameter
    fn compute_number(x: Int):
        print_no_newline(x * x, " - ")

    var stop_at = 16
    var cores = 4

    # start at 0, end at stop_at (non inclusive)
    parallelize[compute_number](stop_at, cores)

# => 0  - 1  - 4  - 9  - 6416  -  81 -   - 25100   -  - 36121   - 144 - 49  -   
# - 169  - 196  - 225  - 

# => another run:
# 0  - 16164   -   -  - 42581    -  - 144 - 910036    - 121 -   -  - 169   -  - 19649   -
#  - 225  - 
```

?? Why such random results? (er zijn altijd 16 - , maar soms geen kwadraat, het zijn ook niet altijd kwadraten?)

This parallellize function implements:  
`parallelize[func: fn(Int) capturing -> None](num_work_items: Int, num_workers: Int)`
    * num_work_items: *number of tasks* to be executed in parallel as much as possible, goes from 0 to (stop_at - 1) included
    * num_workers: is the number of threads (cores) that execute the tasks, so   num_workers is the maximum number of tasks that can execute in parallel


### 15.1.2 With SIMD

The autobus analogy: see https://github.com/rd4com/mojo-learning/blob/main/tutorials/multi-core-parallelize-with-simd .md

See `parallel2.mojo`:
```mojo
from algorithm import parallelize
from memory.unsafe import DTypePointer
from sys.info import simdwidthof
import math

alias element_type = DType.int32
alias group_size = simdwidthof[element_type]()
alias groups = 16


fn main():
    var computer_cores = 4
    var array = DTypePointer[element_type]().alloc(groups * group_size)

    @parameter
    fn compute_number(x: Int):
        # the following array fits exactly in the SIMD width:
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
# ...
# Index: 124  =  15376
# Index: 125  =  15625
# Index: 126  =  15876
# Index: 127  =  16129
```

## 15.2 - async/await in Mojo
See module builtin.coroutine
This is very similar to async/await in other languages: coroutines execute sequentially within one thread with async/await coordination. When execution is fast enough, this gives the impression of parallellization.


## 15.3 - Parallelization applied to row-wise mean() of a vector
In the following example,  we calculate the row-wise `mean()` of a matrix, by vectorizing across colums and parallelizing across rows.

See `matrix_mean_row.mojo`:
```mojo

```

Create a small `Tensor` tx and visualize the shape of the inputs and outputs.
This small input matrix has shape `5x12` and the output matrix with `means()` should be `5x1`.

Then create a `1000x100000` matrix t to make it more computationally intensive.  

