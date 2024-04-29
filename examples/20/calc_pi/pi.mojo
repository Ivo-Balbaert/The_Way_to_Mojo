from time import now

fn calculate_pi(terms: Int) -> Float64:
    var pi: Float64 = 0
    var temp: Float64 = 0
    for i in range(terms):
        temp = ((-1) ** i) / (2 * i + 1)
        pi += temp
    pi *= 4
    return pi

fn main():
    var start = now()     # 2
    print(calculate_pi(100000000))
    var calc_time = now() - start
    print("Mojo pi2 Calculates PI in ", calc_time/1e9, " seconds")

# => 3.141592643589326
# => Mojo pi2 Calculates PI in  1.160146935  seconds