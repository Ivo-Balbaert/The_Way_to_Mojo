# 11 Memory and Input/Output

## 11.1 Working with command-line arguments
This is done with module arg from the sys package.

See `cmdline_args.mojo`:
```py
from sys import argv

fn main():
    print("There are ")
    print(len(argv()))  # => 3
    print("command-line arguments, namely:")
    print(argv()[0])    # => cmdline_args.mojo
    print(argv()[1])    # => 42
    print(argv()[2])    # => abc
```

If this program is executed with the command: `$ mojo cmdline_args.mojo 42 "abc"`;
the output is:
```
There are
3
command-line arguments, namely:
cmdline_args.mojo
42
abc
```

## 11.2 Working with memory

See also:  Pointer § 12
See examples: 

memset: 
memcpy: 
memset_zero: § 12 pointers1.mojo / pointers2.mojo / 

The `stack_allocation` function lets you allocate data buffer space on the stack, given a data type and number of elements, for example:  
`var rest_p: DTypePointer[DType.uint8] = stack_allocation[simd_width, UInt8, 1]()`


## 11.3 The module sys.param_env
Suppose we want to define a Tensor with an element type that we provide at the command-line, like this:  `mojo -D FLOAT32 param_env1.mojo`
The module sys.param_env provides a function `is_defined`, which returns true when the same string was passed at the command-line:

See `param_env1.mojo`:
```py
from sys.param_env import is_defined
from tensor import Tensor, TensorSpec

alias float_type: DType = DType.float32 if is_defined["FLOAT32"]() else DType.float64

fn main():
    print("float_type is: ", float_type)  # => float_type is:  float32
    var spec = TensorSpec(float_type, 256, 256)
    var image = Tensor[float_type](spec)
```

In the same way, you can also use name-value pairs, like -D customised=1234. In that case use the functions `env_get_int` or `env_get_string`.

Another example simulating a testing environment with mojo -D testing comes from https://github.com/rd4com/mojo-learning, see `param_env2.mojo`. It also shows how to print in color on the command-line. Start it with: `mojo -D testing param_env2.mojo`:

See `param_env2.mojo`:
```py
# start from cmd-line as: mojo -D testing param_env2.mojo
from sys.param_env import is_defined

alias testing = is_defined["testing"]()

# let's do colors for fun!
@always_inline
fn expect[message: StringLiteral ](cond: Bool):

    if cond: 
        # print in green
        print(chr(27), end="")
        print("[42m", end="")
    else: 
        # print in red
        print(chr(27), end="")
        print("[41m", end="")

    print(message)
    
    #reset to default colors
    print(chr(27), end="")
    print("[0m", end="")

fn main():
    @parameter
    if testing:
        print("this is a test build, don't use in production")
        expect["math check"](3 == (1 + 2))
        # prints "math check in green"
# => this is a test build, don't use in production
# math check
```

## 11.4 Working with files
This is done through the file module, which is built-in.

Suppose we have a `my_file.txt` with contents: "I like Mojo!"

See `read_file.mojo`
```py
fn main() raises:
    var f = open("my_file.txt", "r")
    print(f.read())     # => I like Mojo!
    f.close()   

    with open("my_file.txt", "r") as f:      # 1
        print(f.read()) # => I like Mojo!
```

The with context in line 1 closes the file automatically.

