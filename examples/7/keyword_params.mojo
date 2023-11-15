from tensor import Tensor
from algorithm import vectorize
from math import mul
from time import now
from memory import memcpy


struct SquareMatrix[dtype: DType = DType.float32, dim: Int = 4]():
    var mat: Tensor[dtype]

    fn __init__(inout self, val: SIMD[dtype, 1] = 5):
        self.mat = Tensor[dtype](self.dim, self.dim)
        alias simd_width = simdwidthof[dtype]()  
        
        @parameter
        fn fill_val[simd_width: Int](idx: Int) -> None:
            self.mat.simd_store(
                idx, self.mat.simd_load[simd_width](idx).splat(val)
            )  # works, but ??

        vectorize[simd_width, fill_val](self.mat.num_elements())

    fn __getitem__(self, x: Int, y: Int) -> SIMD[dtype, 1]:
        return self.mat[x, y]

    fn print(self):
        print(self.mat)

    fn prepare_filename(self, fname: String)->String:
        var fpath = fname
        if fpath.count('.') < 2:
            fpath += '.data'
        fpath = fpath.replace(".","_"+self.mat.spec().__str__()+".")
        if fpath.find('/'):
            fpath = './'+fpath
        return fpath

    @staticmethod
    fn load[dtype: DType,dim: Int](fpath:String) raises -> Tensor[dtype]:
        let load_mat = Tensor[dtype].fromfile(fpath)
        let new_tensor = Tensor[dtype](dim,dim)
        memcpy(new_tensor.data(),load_mat.data(),load_mat.num_elements())
        _ = load_mat
        return new_tensor

  fn save(self, fname: String='saved_matrix') raises -> String:
    let fpath = self.prepare_filename(fname)
    self.mat.tofile(fpath)
    print('File saved:',fpath)
    return fpath



fn multiply(sm: SquareMatrix, val: SIMD[sm.dtype, 1]) -> Tensor[sm.dtype]:
    alias simd_width: Int = simdwidthof[sm.dtype]()
    let result_tensor = Tensor[sm.dtype](sm.mat.shape())

    @parameter
    fn vectorize_multiply[simd_width: Int](idx: Int) -> None:
        result_tensor.simd_store[simd_width](
            idx, mul[sm.dtype, simd_width](sm.mat.simd_load[simd_width](idx), val)
        )

    vectorize[simd_width, vectorize_multiply](sm.mat.num_elements())
    return result_tensor


fn main() raises:
    SquareMatrix().print()
    SquareMatrix(val=12).print()
    SquareMatrix[DType.float64](10).print()
    SquareMatrix[DType.float64, dim=3](1).print()
    SquareMatrix[dtype = DType.float64, dim=3](val=1.5).print()

    # Keyword argument in __getitem__()
    var sm = SquareMatrix()
    sm.print()
    print()
    print("Keyword argument in __getitem__()")
    print(sm[x=0, y=3])

    #
    sm = SquareMatrix(5)
    let res = multiply(sm, 100.0)
    print(res)

    let m = SquareMatrix()
    m.print()
    let fpath = m.save('saved_matrix')
    print('Loading Tensor from file:',fpath)
    print()
    let load_mat = SquareMatrix.load[DType.float32,4](fpath)
    print(load_mat)


# =>
# Tensor([[5.0, 5.0, 5.0, 5.0],
# [5.0, 5.0, 5.0, 5.0],
# [5.0, 5.0, 5.0, 5.0],
# [5.0, 5.0, 5.0, 5.0]], dtype=float32, shape=4x4)


# Tensor([[12.0, 12.0, 12.0, 12.0],
# [12.0, 12.0, 12.0, 12.0],
# [12.0, 12.0, 12.0, 12.0],
# [12.0, 12.0, 12.0, 12.0]], dtype=float32, shape=4x4)

# Tensor([[10.0, 10.0, 10.0, 10.0],
# [10.0, 10.0, 10.0, 10.0],
# [10.0, 10.0, 10.0, 10.0],
# [10.0, 10.0, 10.0, 10.0]], dtype=float64, shape=4x4)

# Tensor([[1.0, 1.0, 1.0],
# [1.0, 1.0, 1.0],
# [1.0, 1.0, 1.0]], dtype=float64, shape=3x3)

# Tensor([[1.5, 1.5, 1.5],
# [1.5, 1.5, 1.5],
# [1.5, 1.5, 1.5]], dtype=float64, shape=3x3)

# Tensor([[5.0, 5.0, 5.0, 5.0],
# [5.0, 5.0, 5.0, 5.0],
# [5.0, 5.0, 5.0, 5.0],
# [5.0, 5.0, 5.0, 5.0]], dtype=float32, shape=4x4)

# Keyword argument in __getitem__()
# 5.0


# Tensor([[500.0, 500.0, 500.0, 500.0],
# [500.0, 500.0, 500.0, 500.0],
# [500.0, 500.0, 500.0, 500.0],
# [500.0, 500.0, 500.0, 500.0]], dtype=float32, shape=4x4)

# File saved: ./saved_matrix_4x4xfloat32.data
# Loading Tensor from file: ./saved_matrix_4x4xfloat32.data

