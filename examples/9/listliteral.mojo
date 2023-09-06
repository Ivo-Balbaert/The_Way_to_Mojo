fn main():
    let list = [1,2,3]                   # 1
    print(list) # => [1, 2, 3]
    let explicit_list: ListLiteral[Int, Int, Int] = [1, 2, 3]
    print(explicit_list) # => [1, 2, 3]

    let list2 = [1, 5.0, "Mojo🔥"]
    print(list2.get[2, StringLiteral]())  # 2B => Mojo🔥
    let mixed_list: ListLiteral[Int, FloatLiteral, StringLiteral] 
            = [1, 5.0, "Mojo🔥"] 
    print(mixed_list.get[2, StringLiteral]())  # 2A => Mojo🔥

    print(len(mixed_list)) # => 3
    print(mixed_list.get[0, Int]()) # => 1

    
    

    