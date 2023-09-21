from mymodule import MyPair        # 1
from mymodule import MyPair as mp1 # 1B
import mymodule                    # 2
import mymodule as mp              # 3

fn main():
    let mine = MyPair(2, 4)    # 3
    mine.dump()     # => 2 4
    let mine2 = mp1(2, 4)    # 3
    mine2.dump()     # => 2 4
    let mine3 = mymodule.MyPair(2, 4)    
    mine3.dump()    # => 2 4
    let mine4 = mp.MyPair(2, 4)    
    mine4.dump()    # => 2 4
