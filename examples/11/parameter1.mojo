from testing import assert_true

fn main():
    alias my_debug_build = 1  # 2
    @parameter
    if my_debug_build == 1:
        _ = assert_true(1==2, "assertion failed")
    # => ASSERT ERROR: assertion failed