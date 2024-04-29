struct enum_type:
    alias invalid = 0
    alias bool = 1
    alias int8 = 2
    alias uint8 = 3
    alias int16 = 4
    alias uint16 = 5
    alias float32 = 15

fn main():
    var en = enum_type.bool
    print(en)  # => 1