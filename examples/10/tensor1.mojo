from tensor import Tensor, TensorSpec, TensorShape
from utils.index import Index
from random import rand

let height = 256
let width = 256
let channels = 3

fn main():
    # Create the tensor of dimensions height, width, channels
    # and fill with random values.
    let image = rand[DType.float32](height, width, channels)

    # Declare the grayscale image.
    let spec = TensorSpec(DType.float32, height, width)
    var gray_scale_image = Tensor[DType.float32](spec)

    # Perform the RGB to grayscale transform.
    for y in range(height):
        for x in range(width):
            let r = image[y,x,0]
            let g = image[y,x,1]
            let b = image[y,x,2]
            gray_scale_image[Index(y,x)] = 0.299 * r + 0.587 * g + 0.114 * b

    print(gray_scale_image.shape().__str__()) # => 256x256
