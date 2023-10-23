# 17 - Foreign Function Interface (FFI)

# 17.1 - Mojo and C 
See https://github.com/ihnorton/mojo-ffi/

## 17.1.1 Linking to functions of the C standard library
The C standard library is implicitly available in the REPL, or explicitly(??) linked by mojo build.

### 17.1.1.1 Mojo calls C via external_call
external_call takes the function name, return type, and up to six (?) argument types as parameters, and then the corresponding argument values as input. However, external_call does not currently support specifying the function library name, so by default it can *only call functions in libc.*

```mojo
let eightball = external_call["rand", Int32]()
print(eightball)
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
  let val = c_atof(float_str.data.as_scalar_pointer())
  print("The parsed Float64 value is: ", val) # => The parsed Float64 value is:  1.234
```

This example demonstrates calling atof to parse a C string and return a double value from the string.