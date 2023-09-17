@value
struct Pet:
    var name: String
    var age: Int

fn main():
    # Creating a new pet
    let myCat = Pet("Wia", 6)
    print("Original cat name: ", myCat.name)
    print("Original cat age: ", myCat.age)
    # Copying a pet
    let copiedCat = Pet(myCat.name, 7)
    print("Copied cat name: ", copiedCat.name)
    print("Copied cat age: ", copiedCat.age)
    let movedCat = myCat
    print("Moved cat name: ", movedCat.name)
    print("Moved cat age: ", movedCat.age)
# =>
# Original cat name:  Wia
# Original cat age:  6
# Copied cat name:  Wia
# Copied cat age:  7
# Moved cat name:  Wia
# Moved cat age:  6