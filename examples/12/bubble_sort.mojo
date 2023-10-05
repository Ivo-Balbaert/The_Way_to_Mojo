from memory.unsafe import Pointer

fn main():
    let n = 10
    var mylist = [9, 6, 0, 8, 2, 5, 1, 3, 7, 4]  # 1 - a ListLiteral
    let arr = Pointer.address_of(mylist).bitcast[Int]()   # 2

    # bubblesort
    print(mylist)  # => [9, 6, 0, 8, 2, 5, 1, 3, 7, 4]
    var temp = 0
    for i in range(n):                          # 3
        for j in range(n - i - 1):
            if arr[j] > arr[j + 1]:
                temp = arr[j]
                arr.store(j, arr[j + 1])
                arr.store(j + 1, temp)
    print(mylist)  # => [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
