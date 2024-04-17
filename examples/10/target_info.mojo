from sys.info import (
    alignof,
    bitwidthof,
    simdwidthof,
    simdbitwidth,
    simdbytewidth,
    sizeof,
    os_is_linux,
    os_is_macos,
    os_is_windows
)
from sys.info import (
    has_avx,
    has_avx2,
    has_avx512f,
    has_intel_amx,
    has_neon,
    has_sse4,
    is_apple_m1
)

struct Foo:
    var a: UInt8
    var b: UInt32

fn main():
    print(alignof[UInt64]())  # => 8
    print(alignof[Foo]())     # 1 => 4
    print(bitwidthof[Foo]())  # 2 => 64
    print(simdwidthof[DType.uint64]()) # 3 => 4
    print(simdbitwidth())     # 4 => 256
    print(simdbytewidth())  # 5 => 32
    print(sizeof[UInt8]())    # 6 => 1

    @parameter                # 7
    if os_is_linux():
        print("this will be included in the binary")
    # => this will be included in the binary
    else:
        print("this will be eliminated from compilation process")

    print(os_is_macos())     # => False
    print(os_is_windows())   # => False

    print(has_sse4())        # => True
    print(has_avx())         # => True
    print(has_avx2())        # => True
    print(has_avx512f())     # => False
    print(has_intel_amx())   # => False
    print(has_neon())        # => False
    print(is_apple_m1())     # => False

   

    

