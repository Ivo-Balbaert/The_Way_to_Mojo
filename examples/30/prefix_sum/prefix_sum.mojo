from time import now

fn main():
    var list = List[Int](capacity = 10_000)
    for _ in range(10_000):
        list.append(1)
    var tik = now()
    for i in range(1, len(list)):
        list[i] += list[i - 1]
    var tok = now()
    print("Time spent per element:", (tok - tik) / len(list), "ns")
    # => Time spent per element: 0.22500000000000001 ns
