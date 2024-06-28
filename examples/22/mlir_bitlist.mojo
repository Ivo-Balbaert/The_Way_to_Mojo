alias _0 = __mlir_attr.`0:i1`
alias _1 = __mlir_attr.`1:i1`

struct BitList(Stringable):

    var value: List[__mlir_type.i1]

    fn __init__(inout self, *values: __mlir_type.i1):
        self.value = List[__mlir_type.i1]()
        for i in values:
            self.value.append(i)
    
    fn __str__(self) -> String:
        var s = String("0b")
        for i in self.value:
            s += String(Int(__mlir_op.`index.castu`[_type=__mlir_type.index](i[])))
        return s

fn main():
    print(BitList(_0, _1, _0, _1)) # => 0b0101