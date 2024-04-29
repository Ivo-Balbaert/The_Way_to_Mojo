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
    
    fn dump(self):
        print(self.first)
        print(self.second)

fn pair_test() -> Bool:
    var p = IntPair(1, 2)   # 4 
    # return p < 4          # => error
    p.dump()                # => 1
                            # => 2
    var q = IntPair(2, 3)
    if p < q:  # this is automatically translated to __lt__
        print("p < q")  # => p < q

    return True

fn main():
   print(pair_test()) # => True

    