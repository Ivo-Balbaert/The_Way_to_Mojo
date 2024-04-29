from python import Python

fn main() raises:
    var plt = Python.import_module("matplotlib.pyplot")

    var x = [1, 2, 3, 4]
    var y = [30, 20, 50, 60]
    _ = plt.plot(x, y)
    _ = plt.show()