fn print_nicely(**kwargs: Int) raises:
    for key in kwargs.keys():
        print(key[], "=", kwargs[key[]])

fn main() raises:
    print_nicely(a=7, y=8)

# =>
# a = 7
# y = 8