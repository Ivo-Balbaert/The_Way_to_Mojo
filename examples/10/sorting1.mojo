from algorithm.sort import sort

fn main():
    var v = DynamicVector[Int](3)

    v.push_back(20)
    v.push_back(10)
    v.push_back(70)

    sort(v)

    for i in range(v.size):
        print(v[i])
# =>
# 10
# 20
# 70