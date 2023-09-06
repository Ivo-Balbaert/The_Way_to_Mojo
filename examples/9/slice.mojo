fn main():
    let original = String("MojoDojo")
    print(original[0:4])  # => Mojo
    print(original[0:8])  # => MojoDojo
    print(original[1:8:2])  # => oooo
    print(original[0:4:2])  # => Mj

    print(original[slice(0, 4)])      # => Mojo
    let slice_expression = slice(0, 4)
    print(original[slice_expression]) # => Mojo

    let x = String("slice it!")
    let a: slice = slice(5)
    let b: slice = slice(5, 9)
    let c: slice = slice(1, 4, 2)

    print(x[a])  # => slice
    print(x[b])  # =>  it!
    print(x[c])  # => lc    