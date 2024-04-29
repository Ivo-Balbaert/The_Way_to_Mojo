from python import Python

fn main():
    try:
        var pd = Python.import_module("pandas")
        print(pd.DataFrame([1,2,3,4,5]))
    except ImportError:
        print('error importing pandas module')
    # => error importing pandas module

