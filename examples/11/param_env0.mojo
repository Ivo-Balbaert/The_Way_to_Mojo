fn add(a: Int, b: Int) -> Int:
    return a + b


# Execute with "mojo -D add_it <filename>" for a non-zero value
alias added_conditionally = add(1, 2) if is_defined["add_it"]() else 0


fn main():
    print(added_conditionally)  # => 3
