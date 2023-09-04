
fn mojo():
    let a: String = "mojo"
    let b = set_fire(a)
    print(a)        # => "mojo"
    print(b)        # => "mojo🔥"

fn set_fire(owned text: String) -> String:   # 1
    text += "🔥"
    return text

fn main():
    mojo()

