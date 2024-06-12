from tensor import Tensor, TensorShape, TensorSpec
from math import trunc
from memory import memset_zero
from sys.info import simdwidthof, simdbitwidth
from algorithm import vectorize, parallelize
from utils.index import Index
from random import seed
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
        self.t = Tensor[dtype].rand(TensorShape(dims))

    @always_inline
    fn __init__(inout self,  owned t: Tensor[dtype]):
        self.t = t

    fn mean(self) -> Self:
        var new_tensor = Tensor[dtype](self.t.dim(0),1)
#        alias simd_width: Int = simdwidthof[dtype]()
        @parameter
        fn parallel_reduce_rows(idx1: Int) -> None:
            @parameter
            fn vectorize_reduce_row[simd_width: Int](idx2: Int) -> None:
                new_tensor[idx1] += self.t.load[width=simd_width](idx1*self.t.dim(1)+idx2).reduce_add()
            vectorize[vectorize_reduce_row, 2*simd_width](self.t.dim(1))
            new_tensor[idx1] /= self.t.dim(1)
        parallelize[parallel_reduce_rows](self.t.dim(0),8)
        return Self(new_tensor)

    fn print(self, prec: Int=4)->None:
        var t = self.t
        var rank = t.rank()
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
                        print("  [", end="")
                    else:
                        print("\n   ", end="")
                print("[", end="")
                for k in range(dim2):
                    if rank==1:
                        val = t[k]
                    if rank==2:
                        val = t[j,k]
                    if rank==3:
                        val = t[i,j,k]
                    var int_str: String
                    if val > 0:
                        int_str = String(trunc(val).cast[DType.int32]())
                    else:
                        int_str = "-"+String(trunc(val).cast[DType.int32]())
                        val = -val
                    var float_str: String
                    float_str = String(val % 1)
                    var s = int_str+"."+float_str[2:prec+2]
                    if k==0:
                        print(s, end="")
                    else:
                        print("  ",s, end="")
                print("]", end="")
            if rank>1:
                print("]", end="")
            print()
        if rank>2:
            print("]")
        print("Tensor shape:",t.shape().__str__(),", Tensor rank:",rank,",","DType:", dtype.__str__())


fn main():
    var tx = myTensor[dtype](5, 10)
    tx.print()
    tx.mean().print()

    var tx2 = myTensor[dtype](1000, 100_000)
    var tm = time.now()
    for i in range(reps):
        _ = tx2.mean()
    var dur = time.now() - tm
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
