def func1(a, b):
    let c = a
    if c != b:
        let d = b
        print(d)  # => 3

fn main():
    try:
        _ = func1(2, 3)
    except:  
        print("error")
