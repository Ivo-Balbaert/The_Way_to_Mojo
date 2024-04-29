fn main():
    var list = List[Int](1, 2, 3)                  # 1
    # var explicit_list: ListLiteral[Int, Int, Int] = [1, 2, 3]
    print(list[0]) # => 1
    for i in range(len(list)):
        print(list[i])

    # var list2 = (1, 5.0, "Mojo🔥")
    # print(list2.get[0, Int]()) # => 1
    # print(list2.get[2, StringLiteral]())  # 2B => Mojo🔥

    # print(len(list2)) # => 3
 
    
    

    