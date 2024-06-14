from collections import Set


fn main():
    var values = Set[Int](42, 0)
    for item in values:
        print(item[])
    # =>
    # 42
    # 0

    var i_like = Set("sushi", "ice cream", "tacos", "pho")
    var you_like = Set("burgers", "tacos", "salad", "ice cream")
    var we_like = i_like.intersection(you_like)

    print("We both like:")
    for item in we_like:  # 1B
        print("-", item[])
    # We both like:
    # - ice cream
    # - tacos
