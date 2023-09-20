from full_name import FullName              # 1
from full_name import FullName as class1    # 2

fn main():
    let full_name = FullName("John", "Doe")
    full_name.print()  # => John Doe
    let full_name2 = class1("John", "Doe")
    full_name2.print() # => John Doe
    
