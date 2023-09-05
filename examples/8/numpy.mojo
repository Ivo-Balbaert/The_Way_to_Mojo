from python import Python                    # 1

fn main() raises:
    let np = Python.import_module("numpy")   # 2

    let array = np.array([1, 2, 3])          # 3
    print(array)  # => [1  2  3]

    var arr = np.ndarray([5])        
    print(arr)  
    # => [4.67092872e-310 0.00000000e+000 0.00000000e+000 4.67150278e-310 2.37151510e-322]
    arr = "this will work fine"  # Python is loosely typed, so:
    print(arr)                   # => this will work fine

    let ar = np.arange(15).reshape(3, 5)
    print(ar)
    # =>
    # [[ 0  1  2  3  4]
    # [ 5  6  7  8  9]
    # [10 11 12 13 14]]
    print(ar.shape)                          # 4
    # => (3, 5)


    