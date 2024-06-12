from tensor import Tensor, TensorSpec, TensorShape
from utils.index import Index

var height = 256
var width = 256
var channels = 3

fn main():
    # Create the tensor of dimensions height, width, channels
    # and fill with random values - rand creates a Tensor
    var tshape = TensorShape(height, width, channels)
    var image = Tensor[DType.int64].rand(tshape)
    # Declare the grayscale image.
    var spec = TensorSpec(DType.int64, height, width)
    var gray_scale_image = Tensor[DType.int64](spec)

    # Perform the RGB to grayscale transform.
    for y in range(height):
        for x in range(width):
            var r = image[y, x, 0]
            var g = image[y, x, 1]
            var b = image[y, x, 2]
            gray_scale_image[Index(y, x)] = 0.299 * r + 0.587 * g + 0.114 * b

    print(gray_scale_image.shape().__str__())  # => 256x256