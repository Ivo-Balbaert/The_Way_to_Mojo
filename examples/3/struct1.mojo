struct IntPair:   
    var first: Int          # 1
    var second: Int         # 2

    fn __init__(inout self, first: Int, second: Int):   # 3
        self.first = first
        self.second = second

    fn __lt__(self, rhs: IntPair) -> Bool:
        return self.first < rhs.first or
              (self.first == rhs.first and
               self.second < rhs.second)
    
    fn dump(inout self):
        print(self.first)
        print(self.second)

def pair_test() -> Bool:
    let p = IntPair(1, 2)   # 4 
    # dump(p)               # => 1
                            # => 2
    let q = IntPair(2, 3)
    # does this work?
    if p < q:  # this is automatically translated to __lt__
        print("p < q")

    return True

fn main():
    pair_test()

    