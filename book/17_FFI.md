# 17 - Foreign Function Interface (FFI)

# 17.1 - Mojo and C 
See also §  14.5

See https://github.com/ihnorton/mojo-ffi/

## 17.1.1 Linking to functions of the C standard library
The C standard library is implicitly available in the REPL, or explicitly(??) linked by mojo build.

### 17.1.1.1 Mojo calls C via external_call
external_call has the following signature:  
`external_call[c_function_name, return_type, arg0_type, arg1_type, ...](arg0, arg1, ...) -> return_type`
It takes the function name, return type, and up to five argument types as parameters, and then the corresponding argument values as input. However, external_call does not currently support specifying the function library name, so by default it can *only call functions in libc.*
It is defined in module sys.intrinsics, but this doesn't need an import: `from sys.intrinsics import external_call` is not necessary.

See `external_call.mojo`:
```mojo
fn main() raises:
    let eightball = external_call[
        "rand", Int32
    ]()  # => 475566294 # random 4-byte integer
    print(eightball)

    var ts : Int
    ts = external_call["time", Int, Pointer[Int]](Pointer[Int]())
    print(ts)  # => 1698747912

    # time(&ts);
    let tsPtr = Pointer[Int].address_of(ts)
    let ts2 = external_call["time", Int, Pointer[Int]](tsPtr)
    print(ts2)  # => 1698747912
```

This calls the rand function in the C stdlib, with return type Int32 (first parameter) and no function arguments.

See `mojo_calls_c_ec.mojo`:
```mojo
# Declare the return type struct, a pair of int32_t values
@register_passable('trivial')
struct div_t:
  var quot: Int32
  var rem: Int32

fn clib_div(numer: Int32, denom: Int32) -> div_t:
  return external_call["div", div_t, Int32, Int32](numer, denom)

def main():
  let res = clib_div(17,4)
  print("quotient, remainder: (", res.quot, ", ", res.rem, ")") # => quotient, remainder: ( 4 ,  1 )
```

### 17.1.1.2 Mojo calls C via a function pointer
Declare a function pointer type, and just ... call it! Mojo appears to use the platform C calling convention for at least simple fn alias declarations. Such function pointers may be loaded using sys.ffi.DLHandle (undocumented) and then called.

See `mojo_calls_c_fp.mojo`:
```mojo
from sys import ffi

alias c_atof_type = fn(s: Pointer[Int8]) -> Float64

def main():
  let handle = ffi.DLHandle("")
  let c_atof = handle.get_function[c_atof_type]("atof")

  let float_str = StringRef("1.234")
  let val = c_atof(float_str.data._as_scalar_pointer())
  print("The parsed Float64 value is: ", val) # => The parsed Float64 value is:  1.234
```

This example demonstrates calling atof to parse a C string and return a double value from the string.

The following example calls the gmtime function:

See `calling_gmtime.mojo`:
```mojo
# definition of `struct tm`
alias int = Int32
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
    let tsPtr = Pointer[Int].address_of(ts)
    _ = external_call["time", Int, Pointer[Int]](tsPtr)
    # struct tm *tm = gmtime(&ts)
    let tmPtr = external_call["gmtime", Pointer[C_tm], Pointer[Int]](tsPtr)
    let tm = tmPtr.load()
    print(tm.tm_hour, ":", tm.tm_min, ":", tm.tm_sec) # => 10 : 35 : 46
```