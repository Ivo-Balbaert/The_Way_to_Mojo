fn main():
    var x = UInt8(1)           # 1
#    x = "will cause an error" # 2 
# error ourpur when line 2 is uncommented
# change_type.mojo:3:9: error: cannot implicitly convert 'StringLiteral' value to 'SIMD[ui8, 1]' in assignment
#     x = "will cause an error" # error:
#         ^~~~~~~~~~~~~~~~~~~~~
# mojo: error: failed to parse the provided Mojo

     var int_value: Int = "42" # try it!