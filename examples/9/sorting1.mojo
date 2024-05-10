from algorithm.sort import sort

fn main():
    var v = List[Int](108)

    v.append(20)
    v.append(10)
    v.append(70)

    sort(v)

    for i in range(v.size):
        print(v[i])
# =>
# 10
# 20
# 70
# 108