# 11 Memory and Input/Output

?? Better explanation why traits are useful

A lot of structs in a project and among projects share the same characteristics (fields or methods). Characteristics that are common could be collected in a so-called `trait`, even without code. Structs could then be said to conform to this trait when they provide code (implement) all of its characteristics.

Trait exist in many languages (Rust, ...) and are sometimes called interfaces (in Java and C# for instance).

## 8.1 What are traits?
" A trait is like a template of characteristics for a struct. If you want to create a struct with the characteristics defined in a trait, you must implement each characteristic (for example: each method). Each characteristic in a trait is a "requirement" for the struct, and when your struct implements each requirement, it's said to "conform" to the trait. "

This makes it possible to write generic functions, which can take traits as arguments, so accept all struct types that implement these traits! Traits also bring more structure to the type-hierarchy (??).

>Note: Currently (May 2024) traits can contain only method signatures 

See for example: (?? other example)
`traits1.mojo`:
```py
trait SomeTrait:
    fn required_method(self, n: Int): ...

@value
struct SomeStruct(SomeTrait):
    fn required_method(self, n: Int):
        print("hello traits", n)   # => hello traits 42

fn fun_with_traits[T: SomeTrait](x: T):  # 2
    x.required_method(42)

fn main():
    var thing = SomeStruct()
    fun_with_traits(thing)  # 1
```

Notice that in line 1 we pass a struct instance to the function, but the function in line 2 accepts this as a generic trait type T, which is defined as a parameter. The function works for all structs that implement the trait.

" The function can accept any type for x as long as it conforms to SomeTrait. Thus, fun_with_traits## 10.10 Working with command-line arguments
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

## 10.11 Working with memory

See also:  Buffer § 10.4, 10.5
           Pointer § 12
See examples memset, memcpy, memset_zero

The `stack_allocation` function lets you allocate data buffer space on the stack, given a data type and number of elements, for example:  
`varrest_p: DTypePointer[DType.uint8] = stack_allocation[simd_width, UInt8, 1]()`


## 10.12 Working with files
This is done through the file module (v 0.4.0).

Suppose we have a my_file.txt with contents: "I like Mojo!"

See `read_file.mojo`
```py
fn main() raises:
    var f = open("my_file.txt", "r")
    print(f.read())     # => I like Mojo!
    f.close()   

    with open("my_file.txt", "r") as f:      # 1
        print(f.read()) # => I like Mojo!
```

The with in line 1 closes the file automatically.

## 10.13 The module sys.param_env
Suppose we want to define a Tensor with an element type that we provide at the command-line, like this:  mojo -D FLOAT_32 param_env1.mojo
The module sys.param_env provides a function is_defined, which returns true when the same string was passed at the command-line.

See `param_env1.mojo`:
```py
from sys.param_env import is_defined
from tensor import Tensor, TensorSpec

alias float_type: DType = DType.float32 if is_defined["FLOAT32"]() else DType.float64

fn main():
    print("float_type is: ", float_type)  # => float_type is:  float32
   varspec = TensorSpec(float_type, 256, 256)
   varimage = Tensor[float_type](spec)
```

In the same way, you can also use name-value pairs, like -D customised=1234. In that case use the functions env_get_int or env_get_string.

Another example simulating a testing environment with mojo -D testing comes https://github.com/rd4com/mojo-learning, see `param_env2.mojo`. It also shows how to print in color on the command-line.