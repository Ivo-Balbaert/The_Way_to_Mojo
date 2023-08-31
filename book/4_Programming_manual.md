# 4 – Programming manual

## 4.1 The __copyinit__ and __moveinit__ special methods
For advanced use cases, Mojo allows you to define custom constructors (using Python’s existing __init__ special method), custom destructors (using the existing __del__ special method) and custom copy and move constructors using the new __copyinit__ and __moveinit__ special methods.  
When a struct has no __copyinit__ method, an instance of that struct cannot be copied.

See `copy_init.mojo`

## 4.2 Immutable arguments (borrowed)
When passing an instance of SomethingBig to a function, it’s necessary to pass a reference because SomethingBig cannot be copied (it has no __copyinit__ method). And, as mentioned above, fn arguments are immutable references by default, but you can explicitly define it with the borrowed keyword as shown in the use_something_big() function here:

See `borrowed.mojo`

## 4.3 Mutable arguments (inout)

See `inout2.mojo`, `swap.mojo`


## 4.4 Transfer arguments (owned and ^)


the cast() method is a generic method definition that gets instantiated at compile-time instead of runtime, based on the parameter value.