@value
struct Counter:
    var count: Int

    fn increase(inout self, amount: Int):
        self.count += amount

fn main():
    var myCounter = Counter(0)    
    print(myCounter.count)    # => 0    
    myCounter.increase(3)         
    print(myCounter.count)    # => 3  