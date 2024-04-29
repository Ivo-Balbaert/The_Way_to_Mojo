from time import now

def call():
   x = 0
   for i in range(100_000_000):
       x += i
   return x

def main():
    var start_time = now()
    var res = call()
    var end_time = now()
    print('duration in seconds:',(end_time - start_time)/1e9)
    print(res)

# => duration in seconds: 2.4e-08
# => 4999999950000000