from time import now

fn add(x: Int, y: Int) -> Int:
    return x + y

fn main():
    let start = now()
    for i in range(1000000):
        let z = add(i, i + 1)
    let end = now()
    
    print("It took Mojo", end - start , " nanoseconds")

# Returns the current monotonic time time in nanoseconds
# https://docs.modular.com/mojo/stdlib/time/time.html

# print("It took Mojo", (end - start) , " nanoseconds")
# => It took Mojo 27  nanoseconds
# This is 2_422_525 times faster than Python!