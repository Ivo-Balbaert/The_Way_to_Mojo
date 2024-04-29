from time import now, sleep, time_function

fn sleep1ms():
    sleep(0.001)

fn measure():
    fn closure() capturing:
        sleep1ms()

    var nanos = time_function[closure]()   # 3
    print("sleeper took", nanos, "nanoseconds to run")
    # => sleeper took 1066729 nanoseconds to run

fn main():
    print(now())    # 1 => 227897314188

    # sleep()
    var tic = now()     # 2
    sleep(0.001)
    var toc = now() - tic
    print("slept for", toc, "nanoseconds")
    # => slept for 1160397 nanoseconds

    measure()   

