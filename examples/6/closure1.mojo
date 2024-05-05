fn outer(f: fn() -> None):   # 2   # Here -> None is required.
    f()                      # 3

fn call_it():
    fn inner():             # 1
        print("inner")

    outer(inner) 

fn main():
    call_it()  # => inner
