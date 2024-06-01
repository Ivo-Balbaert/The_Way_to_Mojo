# 26 - Value ownership and lifecycle

# 26.1 Memory management 
A program is nothing without data, and all modern programming languages store data in one of two places: the call stack and the heap.

What is the stack?
The stack is a region of memory that stores temporary variables created by each function (including the main function). It is managed in a Last-In-First-Out (LIFO) order, meaning that the last variable pushed onto the stack is the first one to be popped off. The stack is very efficient for managing memory because allocating and deallocating variables on the stack is extremely fast. However, the stack is limited in size and scope. It's ideal for storing short-lived *fixed-size* local values, simple data like function parameters, return addresses, and local variables.

The heap is a larger pool of memory used for dynamic allocation. Unlike the stack, the heap does not follow a LIFO order. Instead, it allows for flexible and arbitrary memory allocation and deallocation. This makes it suitable for storing data that needs to live for an unpredictable duration or whose size may change. The trade-off is that managing heap memory requires more effort and can be slower due to the overhead of finding and managing free space.

Because memory is limited, it is important that programs remove unused data from the heap ("free" or "deallocate" the memory) as quickly as possible. This can be done automatically with a garbage collector as in Java or C#, or manually in code by the developer as in C++. 
This last option is error-prone: programmers might accidentally deallocate data before the program is done with it (causing "use-after-free" errors), or they might deallocate it twice ("double free" errors), or they might never deallocate it ("leaked memory" errors). 

Mojo uses a third approach called *ownership* (as in Rust) that relies on a collection of rules that programmers must follow when passing values. The rules ensure there is only one "owner" for each chunk of memory at a time, and that the memory is deallocated accordingly. In this way, Mojo automatically allocates and deallocates heap memory for you, but it does so in a way that's deterministic and safe from the errors mentioned above. Also, it does so with a very low performance overhead.

# 26.2 Value semantics and reference semantics.

In *value semantics* the value of a variable is *copied* when the variable is assigned to another variable or passed as an argument to a function. That's why it's also called "pass by value". 
Each variable maintains unique ownership of its value.

!! examples like in https://docs.modular.com/mojo/manual/values/value-semantics

In *reference semantics* a reference (or pointer) is *copied* when the variable is passed as an argument to a function. That's why it's called "pass by reference". 

!! examples 

Mojo doesn't enforce value semantics or reference semantics. It supports them both and allows each type to define how it is created, copied, and moved (if at all). So, if you're building your own type, you can implement it to support value semantics, reference semantics, or a bit of both. 

That said, Mojo is designed with argument behaviors that *default to value semantics*, and it provides tight controls for reference semantics that avoid memory errors.
The default behavior for all function arguments is to use value semantics. If the function wants to modify the value of an incoming argument, then it must explicitly declare so, which avoids accidental mutations.

In Mojo, the default rules for passing arguments to a function follow *value semantics*:
* All Mojo types passed to a `def` function are *passed by value*
* `fn` functions instead receive *arguments as immutable references*, by default (borrowed). This is a memory optimization to avoid making unnecessary copies.
This behavior is predictable and safe: called functions cannot change anything in the calling functions.

But *reference semantics*, which also means mutable references must be allowed, for performance memory-efficiency reasons. 
The rules to ensure that are: 
1- every value has only one (exclusive) owner at any time - this is ensured by the "borrow checker", which is a process in the Mojo compiler;
    also it checks that the following conditions are satisfied:
    - multiple mutable references (inout) for the same value are forbidden
    - a mutable reference (inout) if there exists an immutable reference (borrowed) for the same value is forbidden
2- each value is destroyed (asap) when the lifetime of its owner ends;

> Note: Python's argument-passing convention is called "pass by object reference.:  a reference to the object is passed, as a value. Eventually, Mojo will also implement "pass by object reference" as described above for all dynamic types (no type declaration) in a def function. 

# 26.3 Ownership and borrowing
In Mojo, three conventions are used when passing arguments to an fn function:
* `borrowed`: The function receives an *immutable reference*. This means the function can read the original value (it is not a copy), but it cannot mutate (modify) it.
* `inout`: The function receives a *mutable reference*. This means the function can read and mutate the original value (it is not a copy).
* `owned`: The function takes ownership. This means the *function has exclusive mutable access* to the argument. The function caller does not have access to this value anymore. Often, this also implies that the caller should transfer ownership to this function.

# 26.4 Lifecycle of a value
The "lifetime" of a value is defined by the span of time during program execution in which each value is considered valid. The life of a value begins when it is initialized and ends when it is destroyed (immediately after last-use), which generally spans from __init__() to __del__().

This is defined by various dunder methods in a struct. Each lifecycle event is handled by a different method, such as:

* the constructor (__init__())              # 1
* the copy constructor (__copyinit__())     # 2
* the move constructor (__moveinit__())     # 3
* the destructor (__del__())                # 4

A struct without a constructor cannot have instances, so it doesn't have a life-cycle. It can only serve as a namespace for static methods.

# 1: 
    With (at least one) __init__() method, instances of a struct can be created.
    Alternatively, the @value decorator can be used to generate an __init__() method, to which you can add your own constructors if you want.

# 2:
    This is triggered by an assignment (=), copying a to b: `var b = a`
    It should do a *deep copy*, resulting in an independent second copy in memory.
    !! image

# 3:
    This is triggered by the transfer operator (^), moving a to b: `var b = a^`
    Here the memory data block remains the same (it doesn't move), but the pointer to that memory moves to a new variable.
    The __moveinit__() method performs a consuming or destructive move: it transfers ownership of a value from one variable to another, and the original variable's lifetime ends.
    !! image

# 4:
    A destructor to destroy an object is not required. As long as all fields in the struct are destructible (every type in the standard library is destructible, except for pointers), then Mojo knows how to destroy the type when its lifetime ends. For a struct with pointers, don't forget a __del__ method to free their memory!
    __del__() can't be called explicitly.

