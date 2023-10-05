import time

def call1():
    x = 0
    for i in range(100_000_000):
        x += i
    return x

start_time1 = time.time()
res1 = call1()
end_time1 = time.time()
print('duration in seconds:',end_time1 - start_time1)
print(res1)

# => duration in seconds: 1.8694157600402832
# => 4999999950000000