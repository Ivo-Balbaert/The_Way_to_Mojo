# Declare the return type struct, a pair of int32_t values
@register_passable('trivial')
struct Div_t:
  var quot: Int32
  var rem: Int32

fn clib_div(numer: Int32, denom: Int32) -> Div_t:
  return external_call["div", Div_t, Int32, Int32](numer, denom)

def main():
  var res = clib_div(17, 4)
  print("quotient, remainder: (", res.quot, ", ", res.rem, ")") 
  # => quotient, remainder: ( 4 ,  1 )