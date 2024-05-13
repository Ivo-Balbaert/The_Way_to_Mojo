from sys import ffi

alias c_atof_type = fn(s: Pointer[Int8]) -> Float64

def main():
  var handle = ffi.DLHandle("")
  var c_atof = handle.get_function[c_atof_type]("atof")

  var float_str = StringRef("1.234")
  var val = c_atof(float_str.data._as_scalar_pointer())
  print("The parsed Float64 value is: ", val) # => The parsed Float64 value is:  1.234