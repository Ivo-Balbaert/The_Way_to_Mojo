fn div_compile_time[a: Int, b: Int]() -> Float64:
    return a / b


fn main():
    print(div_compile_time[3, 4]())  # 1 => 0.75
    print(div_compile_time[b=4, a=3]())  # 2 => 0.75
