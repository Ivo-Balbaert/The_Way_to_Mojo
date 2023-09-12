from python import Python

fn main() raises:
    let plt = Python.import_module("matplotlib.pyplot")

    let x = [1, 2, 3, 4]
    let y = [30, 20, 50, 60]
    _ = plt.plot(x, y)
    _ = plt.show()