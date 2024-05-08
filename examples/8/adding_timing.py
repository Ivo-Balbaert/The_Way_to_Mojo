import time

def add(x, y):
    return x + y

start = time.perf_counter()

for i in range(1_000_000):
    z = add(i, i + 1)

end = time.perf_counter()
# After 1000000 rounds:
# perf_counter() function always returns the float value of time in seconds
# https://www.geeksforgeeks.org/time-perf_counter-function-in-python/
# so we have to multiply it by 1_000_000_000 to get the elapsed time in nanoseconds
print("It took Python", (end - start) * 1_000_000_000, " nanoseconds")
# => It took Python 63848700.000562534  nanoseconds
