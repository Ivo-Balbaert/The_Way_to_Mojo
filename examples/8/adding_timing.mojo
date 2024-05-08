from time import now

fn add(x: Int, y: Int) -> Int:
    return x + y

fn main():
    var z: Int
    var start = now()
    for i in range(1_000_000):
        z = add(i, i + 1)
    var end = now()
    
    print("It took Mojo", end - start , " nanoseconds")
# => It took Mojo 27  nanoseconds
# This is 2_364_767 times faster than Python!

# now() Returns the current monotonic time time in nanoseconds
# https://docs.modular.com/mojo/stdlib/time/time.html

