# broken after v 0.4.0, worked in 0.3.0
# from mypackage.mymodule import MyPair  #  error: unable to locate module 'mymodule'
# from mypackage.mymodule import MyPair as mp1 #  error: unable to locate module 'mymodule'
import mypackage.mymodule
import mypackage.mymodule as mp              

fn main():
    let mine = MyPair(2, 4)    # 3
    mine.dump()     # => 2 4
    let mine2 = mp1(2, 4)    # 3
    mine2.dump()     # => 2 4
    let mine3 = mymodule.MyPair(2, 4)    
    mine3.dump()    # => 2 4
    let mine4 = mp.MyPair(2, 4)    
    mine4.dump()    # => 2 4