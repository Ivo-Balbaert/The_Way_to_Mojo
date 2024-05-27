from time import now


fn main():
    var list = List[Int](capacity=10_000)
    for _ in range(10_000):
        list.append(1)
    var cum_time = 0.0
    for i in range(1, 100):
        var tik = now()
        for i in range(1, len(list)):
            list[i] += list[i - 1]
        var tok = now()
        # print("Time spent per element:", (tok - tik) / len(list), "ns")
        cum_time += (tok - tik) / len(list)

    print("Time spent per element (averaged):", cum_time / 100, "ns")
    # => Time spent per element (averaged): 0.21279600000000007 ns
