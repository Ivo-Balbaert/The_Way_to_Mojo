from sys.param_env import is_defined
from tensor import Tensor, TensorSpec

alias float_type: DType = DType.float32 if is_defined["FLOAT32"]() else DType.float64

fn main():
    print("float_type is: ", float_type)  # => float_type is:  float32
    let spec = TensorSpec(float_type, 256, 256)
    let image = Tensor[float_type](spec)