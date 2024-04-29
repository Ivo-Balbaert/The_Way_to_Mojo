# definition of `struct tm`
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
            tm_isdst: 0
        }

fn main():
    # time_t ts
    var ts : Int = 0
    # time(&ts);
    var tsPtr = Pointer[Int].address_of(ts)
    _ = external_call["time", Int, Pointer[Int]](tsPtr)
    # struct tm *tm = gmtime(&ts)
    var tmPtr = external_call["gmtime", Pointer[C_tm], Pointer[Int]](tsPtr)
    var tm = tmPtr.load()
    print(tm.tm_hour, ":", tm.tm_min, ":", tm.tm_sec) # => 10 : 35 : 46