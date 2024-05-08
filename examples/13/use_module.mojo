from mymodule import MyPair        # 1
from mymodule import MyPair as mp1 # 2
import mymodule                    # 3
import mymodule as mp              # 4

fn main():
    var mine = MyPair(2, 4)    # 1B
    mine.dump()     # => 2 4
    var mine2 = mp1(2, 4)    # 2B
    mine2.dump()     # => 2 4
    var mine3 = mymodule.MyPair(2, 4) # 3B   
    mine3.dump()    # => 2 4
    var mine4 = mp.MyPair(2, 4)   # 4B 
    mine4.dump()    # => 2 4
