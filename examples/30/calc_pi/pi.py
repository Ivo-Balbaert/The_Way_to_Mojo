import timeit

def calculate_pi(terms):
    pi = 0
    for i in range(terms):
        term = ((-1) ** i) / (2 * i + 1)
        pi += term
    pi *= 4
    return pi

def main():
    print("PI is: ", calculate_pi(100000000) )
    secs = timeit.timeit(lambda: calculate_pi(100000000), number = 1)
    print("Python seconds: ", secs)

if __name__ == "__main__":
    main()

# => PI is:  3.141592643589326
# => Python seconds:  20.803975880000507