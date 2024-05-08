from time import now

def add(x, y):
    return x + y

def main():
    z = 0
    start = now()
    for i in range(1_000_000):
        z = int(add(i, i + 1)) # this conversion was needed
    end = now()
    
    print("It took Mojo", end - start , " nanoseconds")
    # => It took Mojo 37  nanoseconds
