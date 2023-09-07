# 10 Standard library examples

## 10.1 Assert statements
Both constrained and debug_assert are built-in.

### 10.1.1 constrained
`constrained[cond, error_msg]` asserts that the condition cond is true at compile-time. It is used to place constraints on functions.

In the following example we ensure that the two parameters to `assert_positives` are both > 0:

See `constrained.mojo`:
```py
fn add_positives[x: Int, y: Int]() -> UInt8:
    constrained[x > 0, "use a positive number"]()     # 1A
    constrained[y > 0]()     # 1B
    return x + y

fn main():
    let res = add_positives[2, 4]()
    print(res)  # => 6
    # _ = add_positives[-2, 4]()  # 2
```

If the condition fails, you get a compile error, and optionally the error message is displayed.
Line 2 gives the error:  
```
constrained.mojo:2:23: note:               constraint failed: param assertion failed
    constrained[x > 0]()     # 1A
                      ^
```

Or if you supplied a custom error message:
```
constrained.mojo:2:23: note:               constraint failed: use a positive number
```

### 10.1.2 debug_assert
`debug_assert[cond, err_msg]` checks that the condition is true, but only in debug builds. It is removed from the compilation process in release builds. It works like assert in C++.

See `debug_assert.mojo`:
```py
fn test_debug_assert[x: Int](y: Int):
    debug_assert(x == 42, "x is not equal to 42")
    debug_assert(y == 42, "y is not equal to 42")

fn main():
    test_debug_assert[1](2)
```

When run as `mojo debug_assert.mojo` there is no output.
??`mojo --debug-level full debug_assert1.mojo` also doesn't give any output (2023 Sep 9)

>Note: debug_assert doesn't work in the Playground because this is not a debug build.

## 10.2 Testing module


## 10.3 
