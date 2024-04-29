from python import Python
from math import abs
from complex import ComplexSIMD, ComplexFloat64
from tensor import Tensor
from utils.index import Index
from benchmark import Benchmark

alias float_type = DType.float64

alias width = 960
alias height = 960
alias MAX_ITERS = 1000

alias min_x = -2.0
alias max_x = 0.6
alias min_y = -1.5
alias max_y = 1.5


# Compute the number of steps to escape.
fn mandelbrot_kernel_2(c: ComplexFloat64) -> Int:
    var z = c
    var nv = 0
    for i in range(1, MAX_ITERS):
        if z.squared_norm() > 4:
            break
        z = z.squared_add(c)
        nv += 1
    return nv

def compute_mandelbrot() -> Tensor[float_type]:
    # create a matrix. Each element of the matrix corresponds to a pixel
    t = Tensor[float_type](height, width)

    dx = (max_x - min_x) / width
    dy = (max_y - min_y) / height

    y = min_y
    for row in range(height):
        x = min_x
        for col in range(width):
            t[Index(row, col)] = mandelbrot_kernel_2(ComplexFloat64(x, y))
            x += dx
        y += dy
    return t


def show_plot(tensor: Tensor[float_type]):
    alias scale = 10
    alias dpi = 64

    np = Python.import_module("numpy")
    plt = Python.import_module("matplotlib.pyplot")
    colors = Python.import_module("matplotlib.colors")

    numpy_array = np.zeros((height, width), np.float64)

    for row in range(height):
        for col in range(width):
            numpy_array.itemset((col, row), tensor[col, row])

    fig = plt.figure(1, [scale, scale * height // width], dpi)
    ax = fig.add_axes([0.0, 0.0, 1.0, 1.0], False, 1)
    light = colors.LightSource(315, 10, 0, 1, 1, 0)

    image = light.shade(
        numpy_array, plt.cm.hot, colors.PowerNorm(0.3), "hsv", 0, 0, 1.5
    )
    plt.imshow(image)
    plt.axis("off")
    plt.show()

def benchmark_mandelbrot(python_secs: Float64):
    @parameter  # this makes test_fn capture C, A and B
    fn test_fn():
        try:
            _ = compute_mandelbrot()
        except:
            pass

    var mojo_secs = Benchmark().run[test_fn]() / 1e9
    print("mojo seconds:", mojo_secs)
    print("speedup:", python_secs / mojo_secs)

fn main() raises:
    var python_secs = 11.530147033001413
    _ = benchmark_mandelbrot(python_secs)

    # _ = show_plot(compute_mandelbrot())

# mojo seconds: 0.26846232199999998
# speedup: 42.948846404604268