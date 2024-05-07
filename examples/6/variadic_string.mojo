def make_worldly(inout *strs: String):
    for i in strs:
        i[] += " world"  # 1 # Requires extra [] to dereference the reference for now.


fn make_worldly2(inout *strs: String):
    # This "just works" as you'd expect!
    for i in range(len(strs)):  # 2
        strs[i] += " world"
    
fn main() raises:
    var s1: String = "hello"
    var s2: String = "konnichiwa"
    var s3: String = "bonjour"
    # make_worldly(s1, s2)
    make_worldly2(s1, s2, s3)
    print(s1)  # => hello world
    print(s2)  # => konnichiwa world
    print(s3)  # => bonjour world

   
   

# =>
# 0 Hello world
# 1 beautiful world
