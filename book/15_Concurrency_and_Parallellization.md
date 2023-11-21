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

## 15.2 - Concurrency: async/await in Mojo
See module builtin.coroutine
This is very similar to async/await in other languages: coroutines execute sequentially within one thread with async/await coordination. When execution is fast enough, this gives the impression of parallellization.

?? good example

## 15.3 - Parallelization applied to row-wise mean() of a vector
### 15.3.1 Using a function
In the following example,  we calculate the row-wise `mean()` of a matrix, by vectorizing across colums and parallelizing across rows.

See `matrix_mean_row.mojo`:
```mojo
from tensor import Tensor, TensorShape, TensorSpec
from math import trunc, mod
from memory import memset_zero
from sys.info import simdwidthof, simdbitwidth
from algorithm import vectorize, parallelize, vectorize_unroll
from utils.index import Index
from random import rand, seed
from python import Python
import time

# idiom:
alias dtype = DType.float32
alias simd_width: Int = simdwidthof[dtype]()


fn tensor_mean[dtype: DType](t: Tensor[dtype]) -> Tensor[dtype]:
    var new_tensor = Tensor[dtype](t.dim(0), 1)
    for i in range(t.dim(0)):
        for j in range(t.dim(1)):
            new_tensor[i] += t[i, j]
        new_tensor[i] /= t.dim(1)
    return new_tensor


fn tensor_mean_vectorize_parallelized[dtype: DType](t: Tensor[dtype]) -> Tensor[dtype]:
    var new_tensor = Tensor[dtype](t.dim(0), 1)

    @parameter
    fn parallel_reduce_rows(idx1: Int) -> None:
        @parameter
        fn vectorize_reduce_row[simd_width: Int](idx2: Int) -> None:
            new_tensor[idx1] += t.simd_load[simd_width](
                idx1 * t.dim(1) + idx2
            ).reduce_add()

        vectorize[2 * simd_width, vectorize_reduce_row](t.dim(1))
        new_tensor[idx1] /= t.dim(1)

    parallelize[parallel_reduce_rows](t.dim(0), 8)
    return new_tensor


fn main() raises:
    print("SIMD bit width", simdbitwidth())  # => SIMD bit width 256
    print("SIMD Width", simd_width)  # => SIMD Width 8

    let tx = rand[dtype](5, 12)
    print(tx)
    # =>
    # Tensor([[0.1315377950668335, 0.458650141954422, 0.21895918250083923, ..., 0.066842235624790192, 0.68677270412445068, 0.93043649196624756],
    # [0.52692878246307373, 0.65391898155212402, 0.70119059085845947, ..., 0.75335586071014404, 0.072685882449150085, 0.88470715284347534],
    # [0.43641141057014465, 0.47773176431655884, 0.27490684390068054, ..., 0.090732894837856293, 0.073749072849750519, 0.38414216041564941],
    # [0.91381746530532837, 0.46444582939147949, 0.050083983689546585, ..., 0.30632182955741882, 0.51327371597290039, 0.84598153829574585],
    # [0.84151065349578857, 0.41539460420608521, 0.46791738271713257, ..., 0.84203958511352539, 0.21275150775909424, 0.13042725622653961]], dtype=float32, shape=5x12)

    seed(42)
    let t = rand[dtype](1000, 100_000)
    var result = Tensor[dtype](t.dim(0), 1)  # reduces 2nd dimension to 1

    print(
        "Input Matrix shape:", t.shape().__str__()
    )  # => Input Matrix shape: 1000x100000
    print(
        "Reduced Matrix shape", result.shape().__str__()
    )  # => Reduced Matrix shape 1000x1
    # print(t)

    # Naive approach in Mojo
    alias reps = 10
    var tm1 = time.now()
    for i in range(reps):
        _ = tensor_mean[dtype](t)
    let dur1 = time.now() - tm1
    print("Mojo naive mean:", dur1 / reps / 1000000, "ms")

    # NumPy approach
    let np = Python.import_module("numpy")
    let dim0 = t.dim(0)
    let dim1 = t.dim(1)
    let t_np = np.random.rand(dim0, dim1).astype(np.float32)
    var tm2 = time.now()
    for i in range(reps):
        _ = np.mean(t_np, 1)
    let dur2 = time.now() - tm2
    print("Numpy mean:", dur2 / reps / 1000000, "ms")

    # Vectorized and parallelized approach in Mojo
    var tm3 = time.now()
    for i in range(reps):
        _ = tensor_mean_vectorize_parallelized[dtype](t)
    let dur3 = time.now() - tm3
    print("Mojo Vectorized and parallelized mean:", dur3 / reps / 1000000, "ms")


# =>
# Mojo naive mean: 171.706568 ms
# Numpy mean: 22.4442907 ms
# Mojo Vectorized and parallelized mean: 7.8798915000000003 ms
# Mojo VP is 2.8 x faster than Numpy
```

Create a small `Tensor` tx and visualize the shape of the inputs and outputs.
This small input matrix has shape `5x12` and the output matrix with `means()` should be `5x1`.

Then create a `1000x100000` matrix t to make it more computationally intensive.  
Write a function to calculate averages of each row the naive way.

Vectorized and parallelized way: see fn

### 15.3.2 Using a custom struct based on Tensor type
Now we copy our vectorized and parallelized implementation of row-wise mean() and make it a function in a custom Struct based on Tensor type:

See ``matrix_mean_row2.mojo`:
```mojo
from tensor import Tensor, TensorShape, TensorSpec
from math import trunc, mod
from memory import memset_zero
from sys.info import simdwidthof, simdbitwidth
from algorithm import vectorize, parallelize, vectorize_unroll
from utils.index import Index
from random import rand, seed
from python import Python
import time

# idiom:
alias dtype = DType.float32
alias simd_width: Int = simdwidthof[dtype]()
alias reps = 10

struct myTensor[dtype: DType]:
    var t: Tensor[dtype]

    @always_inline
    fn __init__(inout self, *dims: Int):
        self.t = rand[dtype](TensorSpec(dtype, dims))

    @always_inline
    fn __init__(inout self,  owned t: Tensor[dtype]):
        self.t = t

    fn mean(self) -> Self:
        var new_tensor = Tensor[dtype](self.t.dim(0),1)
#        alias simd_width: Int = simdwidthof[dtype]()
        @parameter
        fn parallel_reduce_rows(idx1: Int)->None:
            @parameter
            fn vectorize_reduce_row[simd_width: Int](idx2: Int) -> None:
                new_tensor[idx1] += self.t.simd_load[simd_width](idx1*self.t.dim(1)+idx2).reduce_add()
            vectorize[2*simd_width,vectorize_reduce_row](self.t.dim(1))
            new_tensor[idx1] /= self.t.dim(1)
        parallelize[parallel_reduce_rows](self.t.dim(0),8)
        return Self(new_tensor)

    fn print(self, prec: Int=4)->None:
        let t = self.t
        let rank = t.rank()
        if rank == 0:
            print("Error: Nothing to print. Tensor rank = 0")
            return
        var dim0:Int=0
        var dim1:Int=0
        var dim2:Int=0
        if rank==0 or rank>3:
            print("Error: Tensor rank should be: 1,2, or 3. Tensor rank is ", rank)
            return
        if rank==1:
            dim0 = 1
            dim1 = 1
            dim2 = t.dim(0)
        if rank==2:
            dim0 = 1
            dim1 = t.dim(0)
            dim2 = t.dim(1)
        if rank==3:
            dim0 = t.dim(0)
            dim1 = t.dim(1)
            dim2 = t.dim(2)
        var val:SIMD[dtype, 1]=0.0
        for i in range(dim0):
            if i==0 and rank==3:
                print("[")
            else:
                if i>0:
                    print()
            for j in range(dim1):
                if rank!=1:
                    if j==0:
                        print_no_newline("  [")
                    else:
                        print_no_newline("\n   ")
                print_no_newline("[")
                for k in range(dim2):
                    if rank==1:
                        val = t[k]
                    if rank==2:
                        val = t[j,k]
                    if rank==3:
                        val = t[i,j,k]
                    let int_str: String
                    if val > 0:
                        int_str = String(trunc(val).cast[DType.int32]())
                    else:
                        int_str = "-"+String(trunc(val).cast[DType.int32]())
                        val = -val
                    let float_str: String
                    float_str = String(mod(val,1))
                    let s = int_str+"."+float_str[2:prec+2]
                    if k==0:
                        print_no_newline(s)
                    else:
                        print_no_newline("  ",s)
                print_no_newline("]")
            if rank>1:
                print_no_newline("]")
            print()
        if rank>2:
            print("]")
        print("Tensor shape:",t.shape().__str__(),", Tensor rank:",rank,",","DType:", dtype.__str__())


fn main():
    let tx = myTensor[dtype](5, 10)
    tx.print()
    tx.mean().print()

    let tx2 = myTensor[dtype](1000, 100_000)
    let tm = time.now()
    for i in range(reps):
        _ = tx2.mean()
    let dur = time.now() - tm
    print("Mojo Vectorized and parallelized mean in a struct:", dur / reps / 1000000, "ms")

# [[0.1315   0.4586   0.2189   0.6788   0.9346   0.5194   0.0345   0.5297   0.0076   0.0668]
#    [0.6867   0.9304   0.5269   0.6539   0.7011   0.7621   0.0474   0.3282   0.7564   0.3653]
#    [0.9825   0.7533   0.0726   0.8847   0.4364   0.4777   0.2749   0.1665   0.8976   0.0605]
#    [0.5045   0.3190   0.4939   0.0907   0.0737   0.3841   0.9138   0.4644   0.0500   0.7702]
#    [0.1253   0.6884   0.6295   0.7254   0.8885   0.3063   0.5132   0.8459   0.8415   0.4153]]
# Tensor shape: 5x10 , Tensor rank: 2 , DType: float32
#   [[0.3580]
#    [0.5758]
#    [0.5007]
#    [0.4064]
#    [0.5979]]
# Tensor shape: 5x1 , Tensor rank: 2 , DType: float32

# Mojo Vectorized and parallelized mean in a struct: 6.927613 ms
# 1.14 x faster than previous version, 3.2 x faster than Numpy
```
