@register_passable("trivial")
struct UInt8:
    alias Data = __mlir_type.ui8

    var value: Self.Data

    @always_inline
    fn __init__(value: Int) -> Self:
        return Self {
            value: __mlir_op.`index.castu`[_type : Self.Data](value.__mlir_index__())
        }

    @always_inline
    fn __add__(self, rhs: Self) -> Self:
        return Self(
            __mlir_op.`index.add`[_type : __mlir_type.index](
                __mlir_op.`index.castu`[_type : __mlir_type.index](self.value),
                __mlir_op.`index.castu`[_type : __mlir_type.index](rhs.value),
            )
        )

    @always_inline
    fn __sub__(self, rhs: Self) -> Self:
        return Self(
            __mlir_op.`index.sub`[_type : __mlir_type.index](
                __mlir_op.`index.castu`[_type : __mlir_type.index](self.value),
                __mlir_op.`index.castu`[_type : __mlir_type.index](rhs.value),
            )
        )

    @always_inline
    fn to_int(self) -> Int:
        return Int(__mlir_op.`index.castu`[_type : __mlir_type.index](self.value))

    fn print(self):
        print(self.to_int())


fn main():
    let i: UInt8 = 42
    i.print()
