def make_worldly(inout *strs: String):
    for i in strs:
        i[] += " world"  # 1 # Requires extra [] to dereference the reference for now.


fn make_worldly2(inout *strs: String):
    # This "just works" as you'd expect!
    for i in range(len(strs)):  # 2
        strs[i] += " world"
        print(i, strs[i])


fn main() raises:
    var s1: String = "Hello"
    var s2: String = "beautiful"
    # make_worldly(s1, s2)
    make_worldly2(s1, s2)


# =>
# 0 Hello world
# 1 beautiful world
