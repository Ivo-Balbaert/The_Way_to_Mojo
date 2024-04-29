
fn mojo():
    var a: String = "mojo"
    var b = set_fire(a^)
    # print(a)        # error: use of uninitialized value 'a'
    print(b)          # => "mojo🔥"

fn set_fire(owned text: String) -> String:   
    text += "🔥"
    return text

fn main():
    mojo()

