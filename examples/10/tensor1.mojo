from tensor import Tensor, TensorSpec, TensorShape, rand
from utils.index import Index

var height = 256
var width = 256
var channels = 3


fn main():
    # Create the tensor of dimensions height, width, channels
    # and fill with random values.
    var ts = VariadicList[Int](height, width, channels)
    var image = rand[DType.float32](ts)

    # Declare the grayscale image.
    var spec = TensorSpec(DType.float32, height, width)
    var gray_scale_image = Tensor[DType.float32](spec)

    # Perform the RGB to grayscale transform.
    for y in range(height):
        for x in range(width):
            var r = image[y, x, 0]
            var g = image[y, x, 1]
            var b = image[y, x, 2]
            gray_scale_image[Index(y, x)] = 0.299 * r + 0.587 * g + 0.114 * b

    print(gray_scale_image.shape().__str__())  # => 256x256

    # 0x0  ??   2024-04-24
