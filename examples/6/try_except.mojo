def func1(a, b):
    var c = a
    if c != b:
        var d = b
        print(d)  # => 3

fn main():
    try:
        _ = func1(2, 3)
    except:  
        print("error")
