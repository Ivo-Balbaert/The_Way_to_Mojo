alias OurTrue = OurBool(__mlir_attr.`true`)
alias OurFalse: OurBool = __mlir_attr.`false`


@register_passable("trivial")
struct OurBool:
    var value: __mlir_type.i1  # 1

    # fn __init__(inout self):
    #     self.value = __mlir_op.`index.bool.constant`[value : __mlir_attr.`false`,]()

    # fn __init__() -> Self:
    #     return Self {
    #         value: __mlir_op.`index.bool.constant`[
    #             value : __mlir_attr.`false`,
    #         ]()
    #     }

    # Simplification:
    fn __init__() -> Self:
        return OurFalse

    fn __init__(value: __mlir_type.i1) -> Self:
        return Self {value: value}

    # fn __copyinit__(inout self, rhs: Self):
    #         self.value = rhs.value

    # Our new method converts `OurBool` to `Bool`:
    # fn __bool__(self) -> Bool:
    #     return Bool(self.value)

    # Our new method converts `OurBool` to `i1`:
    fn __mlir_i1__(self) -> __mlir_type.i1:
        return self.value

    fn __eq__(self, rhs: OurBool) -> Self:
        let lhsIndex = __mlir_op.`index.casts`[_type : __mlir_type.index](
            self.value
        )
        let rhsIndex = __mlir_op.`index.casts`[_type : __mlir_type.index](
            rhs.value
        )
        return Self(
            __mlir_op.`index.cmp`[
                pred : __mlir_attr.`#index<cmp_predicate eq>`
            ](lhsIndex, rhsIndex)
        )

    fn __invert__(self) -> Self:
        return OurFalse if self == OurTrue else OurTrue


fn main():
    # let a: OurBool                # 2
    let a = OurBool()  # 3  - this needs an __init__ method !
    let b = a  # 4 error: 'OurBool' does not implement the '__copyinit__' method

    let e = OurTrue
    let f = OurFalse

    let g = OurTrue
    if g:
        print("It's true!")  # 5  - __bool__ is needed here => It's true!

    # After defining the  __mlir_i1__, the __bool__ method is no longer needed
    let h = OurTrue
    if h:
        print("No more Bool conversion!")

    let i = OurFalse
    if ~i: print("It's false!")   # 6 => It's false!
