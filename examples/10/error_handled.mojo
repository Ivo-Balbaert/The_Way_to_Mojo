fn main() raises:
    try:
        print(return_error())
    except exc:
        print("The important error is handled")
    
    print("The program continues!")

def return_error():
    raise Error("This signals an important error!")  # 1

# =>
# The important error is handled
# The program continues!