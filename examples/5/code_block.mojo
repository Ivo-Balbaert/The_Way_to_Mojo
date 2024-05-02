def loop():
    for x in range(5):
        if x % 2 == 0:
            print(x, end=" / ")


fn main() raises:
    loop()  # => 0 / 2 / 4 /
