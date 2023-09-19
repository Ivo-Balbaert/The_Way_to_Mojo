fn outer(f: fn() capturing -> Int):
    print(f())

fn call_it():
    let a = 5               # 1
    fn inner() -> Int:      # 2  
        return a

    outer(inner) 

fn main():
    call_it()  # => 5
