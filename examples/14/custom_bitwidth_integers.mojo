@register_passable("trivial")
struct U24[N: Int]:
    var value: __mlir_type.ui24

    alias MAX: Int = 2**24 - 1
    alias ZERO: Int = 0

    alias greater_than_16777215_err_msg: StringLiteral = "Unable to parameterize a value of type `U24` with an integer value greater than 16777215"
    alias lesser_than_0_err_msg: StringLiteral = "Unable to parameterize a value of type `U24` with a negative integer value"

    @always_inline("nodebug")
    fn __init__() -> Self:
        constrained[N <= Self.MAX, Self.greater_than_16777215_err_msg]()
        constrained[N >= Self.ZERO, Self.lesser_than_0_err_msg]()
        return Self {
            value: __mlir_op.`index.castu`[_type = __mlir_type.ui24](N.__mlir_index__())
        }

    @always_inline("nodebug")
    fn __add__[M: Int](self: Self, other: U24[M]) -> U24[Self.N + M]:
        return U24[Self.N + M]()


fn main() raises:
    print("Size of `sizeof[U24]`: ", sizeof[U24[0]]())  # => Size of `sizeof[U24]`:  3
    alias c = U24[600]()
    # print("c = ", c.__into_int__())  # Should print "c = 600"
    # print(c)

    let plus = U24[600]() + U24[650]()
