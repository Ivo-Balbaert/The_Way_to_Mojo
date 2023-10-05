from memory import *
from memory.unsafe import Pointer, DTypePointer
from algorithm import vectorize
from sys.info import simdwidthof


alias simd_width_u8 = simdwidthof[DType.uint8]()

fn chars_len[simd_width: Int](s: StringLiteral) -> Int:
    let p = DTypePointer[DType.int8](s.data()).bitcast[DType.uint8]()
    let l = len(s)
    var offset = 0
    var result = 0
    while l - offset >= simd_width:
        result += (
            ((p.simd_load[simd_width](offset) >> 6) != 0b10)
            .cast[DType.uint8]()
            .reduce_add()
            .to_int()
        )
        offset += simd_width

    if offset < l:
        let rest_p: DTypePointer[DType.uint8] = stack_allocation[simd_width, UInt8, 1]()
        memset_zero(rest_p, simd_width)
        memcpy(rest_p, p.offset(offset), l - offset)
        result += (
            ((rest_p.simd_load[simd_width]() >> 6) != 0b10)
            .cast[DType.uint8]()
            .reduce_add()
            .to_int()
        )
        result -= simd_width - (l - offset)

    return result

fn chars_count(s: StringLiteral) -> Int:
    let p = DTypePointer[DType.int8](s.data()).bitcast[DType.uint8]()
    let string_byte_length = len(s)
    var result = 0
    
    @parameter
    fn count[simd_width: Int](offset: Int):
        result += ((p.simd_load[simd_width](offset) >> 6) != 0b10).cast[DType.uint8]().reduce_add().to_int()
    
    vectorize[simd_width_u8, count](string_byte_length)
    return result

fn main():
    # StringLiteral
    let s = "hello"
    let p = Pointer(s.data())
    for i in range(len(s)):
        print_no_newline(p[i], " - ")
    # => 104  - 101  - 108  - 108  - 111  -
    # String
    print()
    let s2: String = "hello"
    for i in range(len(s2)):
        print_no_newline(s2[i], " - ")
    # => h  - e  - l  - l  - o  -
    # String with non ASCII Unicode character
    print()
    let s3: String = "hello 🔥"
    for i in range(len(s3)):
        print_no_newline(s3[i], " - ")
    # => h  - e  - l  - l  - o  -    - �  - �  - �  - �  -
    # via StringLiteral
    print()
    print(len(s3))  # => 10
    let s4 = "hello 🔥"
    let p4 = Pointer(s4.data())
    for i in range(len(s4)):
        print_no_newline(p[i], " - ")
    # => 104  - 101  - 108  - 108  - 111  - 0  - 0  - 0  - 0  - 0  -
    print()
    print(len(s4))  # => 10
    print(String(s4)[6:10])  # => 🔥

    print(chars_len[32](s4))  # => 7
    print(chars_count(s4))    # => 7
