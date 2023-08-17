
from String import String   # 1

fn main():
    mojo()

fn mojo():
    let a: String = "mojo"
    let b = set_fire(a)
    print(a)        # => "mojo"
    print(b)        # => "mojo🔥"

fn set_fire(owned text: String) -> String:   # 2
    text += "🔥"
    return text

