# This is not really a unique pointer, we just model its behavior here
# to serve the examples below.
struct UniquePointer:
    var ptr: Int
    
    fn __init__(inout self, ptr: Int):
        self.ptr = ptr
    
    fn __moveinit__(inout self, owned existing: Self):
        self.ptr = existing.ptr
        
    fn __del__(owned self):
        self.ptr = 0


fn take_ptr(owned p: UniquePointer):
    print("take_ptr")  # => take_ptr
    print(p.ptr)       # => 100

fn use_ptr(borrowed p: UniquePointer):
    print("use_ptr")  # => use_ptr
    print(p.ptr)      # => 100
    
fn work_with_unique_ptrs():
    let p = UniquePointer(100)
    use_ptr(p)    # Pass to borrowing function.
    take_ptr(p^)  # Pass ownership of the `p` value to another function.

    # Uncomment to see an error:
    # use_ptr(p) # error: use of uninitialized value 'p' - p is no longer valid here!

fn main():
    work_with_unique_ptrs()


    