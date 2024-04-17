from testing import assert_true

alias debug_mode = True  # 1


fn example():
    @parameter
    if debug_mode:     # 2
        print("debug")


fn main() raises:
    @parameter
    if debug_mode:      # 1B
        _ = assert_true(1 == 2, "assertion failed")
    # => ASSERT ERROR: assertion failed

    example()  # => debug

    
