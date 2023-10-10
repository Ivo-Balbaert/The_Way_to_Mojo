alias int = Int32


@value
@register_passable("trivial")
struct C_tm:
    var tm_sec: int
    var tm_min: int
    var tm_hour: int
    var tm_mday: int
    var tm_mon: int
    var tm_year: int
    var tm_wday: int
    var tm_yday: int
    var tm_isdst: int

    fn __init__() -> Self:
        return Self {
            tm_sec: 0,
            tm_min: 0,
            tm_hour: 0,
            tm_mday: 0,
            tm_mon: 0,
            tm_year: 0,
            tm_wday: 0,
            tm_yday: 0,
            tm_isdst: 0,
        }


fn main():
    var rawTime: Int = 0
    let rawTimePtr = Pointer[Int].address_of(rawTime)
    __mlir_op.`pop.external_call`[
        func = "time".value,
        _type = None,
    ](rawTimePtr.address)

    let tm = __mlir_op.`pop.external_call`[
        func = "gmtime".value,
        _type = Pointer[C_tm],
    ](rawTimePtr).load()

    print(tm.tm_hour, ":", tm.tm_min, ":", tm.tm_sec)  # => 17 : 41 : 6
