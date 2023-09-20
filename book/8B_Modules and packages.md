# 8B Modules and packages

We talked about how to import modules from the standard libraries of Mojo and Python in § 3.6, and how to import a local custom Python module in § 8.4. 
Now we'll see how we import a local custom Mojo module in § 8B.2.

## 8B.1 What are modules and packages?
We have seen that the Mojo standard library is organized in *packages*, each grouping 1 or more related *modules*.

## 8B.2 Importing a local Mojo module
Doing this is as easy as for Python modules.
Suppose we have functionality around full names in module `full_name.mojo`. Here for brevity we have only 2 fields, an @value decorator and a print method.

See `full_name.mojo`:
```mojo
@value
struct FullName:
    var first_name: String
    var last_name: String

    fn print(self):
        print(self.first_name, self.last_name)
```

We want to use this module in a Mojo program, for example `use_module.mojo`. We can do this as follows:  

See `use_module.mojo`:
```mojo
from full_name import FullName              # 1
from full_name import FullName as class1    # 2

fn main():
    let full_name = FullName("John", "Doe")
    full_name.print()  # => John Doe
    let full_name2 = class1("John", "Doe")
    full_name2.print() # => John Doe
```

The familiar syntax `from modname import type/method` us used. In line 2 we see that we can even rename the imported object with `as`, for shortness or to avoid name clashes. The code in main makes 2 FullName instances, and prints them out.