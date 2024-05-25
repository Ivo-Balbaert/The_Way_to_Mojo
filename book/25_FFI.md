# 25 - Foreign Function Interface (FFI)

# 25.1 - Mojo and C 
See also: https://github.com/ihnorton/mojo-ffi/

## 25.1.1 Calling functions from the C standard library
The C standard library is implicitly available in the REPL, or explicitly(??) linked by mojo build.
The sys package contains a module ffi, that implements a foreign functions interface (FFI), and which must be imported as:
`from sys import ffi`.

### 25.1.1.1 Mojo calls C via external_call
external_call has the following signature:  
`external_call[c_function_name, return_type, arg0_type, arg1_type, ...](arg0, arg1, ...) -> return_type`
It takes the function name, return type, and up to five argument types as parameters, and then the corresponding argument values as input. However, external_call does not currently support specifying the function library name, so by default it can *only call functions in libc.*
It is defined in module sys.intrinsics, but this doesn't need an import: `from sys.intrinsics import external_call` is not necessary.

See `external_call.mojo`:
```py
fn main() raises:
    var eightball = external_call[    # 1
        "rand", Int32
    ]()  
    print(eightball) # => 475566294 # random 4-byte integer

    var ts : Int
    ts = external_call["time", Int, Pointer[Int]](Pointer[Int]())
    print(ts)  # => 1698747912

    # time(&ts);
    var tsPtr = Pointer[Int].address_of(ts)
    var ts2 = external_call["time", Int, Pointer[Int]](tsPtr)
    print(ts2)  # => 1698747912
```

Line 1 calls the rand function in the C stdlib, with return type Int32 (first parameter) and no function arguments.

See `mojo_calls_c_ec.mojo`:
```py
# Declare the return type struct, a pair of int32_t values
@register_passable('trivial')
struct Div_t:
    var quot: Int32
    var rem: Int32

fn clib_div(numer: Int32, denom: Int32) -> Div_t:
    return external_call["div", Div_t, Int32, Int32](numer, denom)

def main():
    var res = clib_div(17,4)
    print("quotient, remainder: (", res.quot, ", ", res.rem, ")") 
    # => quotient, remainder: ( 4 ,  1 )
```

The following example calls the gmtime function:

See `calling_gmtime.mojo`:
```py
alias int = Int32

# definition of `struct tm`
@value
@register_passable("trivial")
struct C_tm:
    var tm_sec: int
    var tm_min: int
    var tm_hour: int
    var tm_mday: int
    var tm_mon: int
    var tm_year: int
    var tm_wday: int
    var tm_yday: int
    var tm_isdst: int
    
    fn __init__() -> Self:
        return Self {
            tm_sec: 0,
            tm_min: 0,
            tm_hour: 0,
            tm_mday: 0,
            tm_mon: 0,
            tm_year: 0,
            tm_wday: 0,
            tm_yday: 0,
            tm_isdst: 0
        }

fn main():
    # time_t ts
    var ts : Int = 0
    # time(&ts);
    var tsPtr = Pointer[Int].address_of(ts)
    _ = external_call["time", Int, Pointer[Int]](tsPtr)
    # struct tm *tm = gmtime(&ts)
    var tmPtr = external_call["gmtime", Pointer[C_tm], Pointer[Int]](tsPtr)
    var tm = tmPtr.load()
    print(tm.tm_hour, ":", tm.tm_min, ":", tm.tm_sec) # => 10 : 35 : 46
```

### 25.1.1.2 Mojo calls C via a function pointer
Declare a function pointer type, and just call it! Mojo uses the platform C calling convention for at least simple fn alias declarations. Such function pointers may be loaded using sys.ffi.DLHandle (undocumented) and then called.

See `mojo_calls_c_fp.mojo`:
```py
from sys import ffi

alias c_atof_type = fn(s: Pointer[Int8]) -> Float64

def main():
    var handle = ffi.DLHandle("")
    var c_atof = handle.get_function[c_atof_type]("atof")

    var float_str = StringRef("1.234")
    var val = c_atof(float_str.data._as_scalar_pointer())
    print("The parsed Float64 value is: ", val) # => The parsed Float64 value is:  1.234
```

This example demonstrates calling atof to parse a C string and return a double value from the string.