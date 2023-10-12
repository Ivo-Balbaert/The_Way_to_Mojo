# 13 Modules and packages
We talked about how to import modules from the standard libraries of Mojo and Python in § 3.6, and how to import a local custom Python module in § 8.4. 
Now we'll see how we import a local custom Mojo module in § 13.2.
Mojo provides a packaging system that allows you to organize and compile code libraries into importable files.  
Here we'll learn how to organize your code into modules and packages (which is a lot like Python), and shows you how to create a packaged binary with the `mojo package` command.

## 13.1 What are modules and packages?
We have seen that the Mojo standard library is organized in *packages*, each package grouping one or more related *modules*.  

A Mojo *module* is a single Mojo source file that includes code like an API, suitable for use by other files that import it.  
The module gets its name from the filename (without the extension), for example: a file `module1.mojo` contains the code for module `module1`.  
The code in a module has no main() function, so you can’t execute a module like in module1.mojo. However, you can import this into another file with a main() function and use it there.  

A Mojo *package* is just a collection of Mojo modules in a directory that includes an `__init__.mojo` file. The directory name works as the package name when importing the package.  

>Note: The packages of the Mojo standard library are stored in `/home/username/.modular/pkg/packages.modular.com_mojo/lib/mojo`

You can then import all the modules together or individually.
For example: the map() function resides in the `functional` module in the `algorithm` package, so you can import it as:
`from algorithm.functional import map`.  
Optionally, you can also compile the package into a `.mojopkg` or `.📦` file that’s easier to share (see § 13.3.2).

## 13.2 Importing a local Mojo module
Doing this is as easy as for Python modules.
Suppose we have functionality of a pair of integers in `mymodule.mojo`. 

See `mymodule.mojo`:
```mojo
struct MyPair:
    var first: Int
    var second: Int

    fn __init__(inout self, first: Int, second: Int):
        self.first = first
        self.second = second

    fn dump(self):
        print(self.first, self.second)
```

We want to use this module in a Mojo program, for example `use_module.mojo`. We can do this as follows:  

See `use_module.mojo`:
```mojo
from mymodule import MyPair        # 1
from mymodule import MyPair as mp1 # 1B
import mymodule                    # 2
import mymodule as mp              # 3

fn main():
    let mine = MyPair(2, 4)    # 3
    mine.dump()     # => 2 4
    let mine2 = mp1(2, 4)    # 3
    mine2.dump()     # => 2 4
    let mine3 = mymodule.MyPair(2, 4)    
    mine3.dump()    # => 2 4
    let mine4 = mp.MyPair(2, 4)    
    mine4.dump()    # => 2 4
```

The familiar syntax `from modname import type/method` us used. In line 2 we see that we can even rename the imported object with `as`, for shortness or to avoid name clashes. The code in main makes 2 MyPair instances, and prints them out.
This works when the module is in the same folder as use_module.mojo. Example other location??
(Currently Sep 2023, you can’t import .mojo files as modules if they reside in other directories.)

You can import the whole module and then access its members through the module name.   
Then line 1 changes to:  `import mymodule`                
and line 3 to:           `let mine = mymodule.MyPair(2, 4)`

Here also you can give the module another name, so you could write:  
Line 1                :  `import mymodule as mp`                
and line 3 to:           `let mine = mp.MyPair(2, 4)`

## 13.3 Importing a local Mojo package
You can import a package and its modules either directly from source files or from a compiled `.mojopkg` or `.📦` file. It makes no real difference to Mojo which way you import a package. When importing from source files, the directory name works as the package name, whereas when importing from a compiled package, the filename is the package name (which you specify with the mojo package command, so it can differ from the directory name).  

## 13.3.1 Importing the package as source code
For our example, let's continue to work on the code from § 13.2. Suppose our project structure is like this:   

use_package.mojo  (?? can also be just main.mojo)
mypackage/
    __init__.mojo
    mymodule.mojo

mymodule.mojo is exactly the same as in § 13.1, __init__.mojo must be an empty file.
use_package.mojo has the same code in main(), but the import statements now are prefixed wit the package name:

```py
from mypackage.mymodule import MyPair
from mypackage.mymodule import MyPair as mp1 
import mypackage.mymodule
import mypackage.mymodule as mp              

fn main():
    let mine = MyPair(2, 4)    # 3
    mine.dump()     # => 2 4
    let mine2 = mp1(2, 4)    # 3
    mine2.dump()     # => 2 4
    let mine3 = mymodule.MyPair(2, 4)    
    mine3.dump()    # => 2 4
    let mine4 = mp.MyPair(2, 4)    
    mine4.dump()    # => 2 4
```

>Note: The __init__.mojo is crucial here. If you delete it, then Mojo doesn’t recognize the directory as a package and it cannot import mymodule.  

Executing `mojo use_package.mojo`  gives as output:
```
2 4
2 4
2 4
2 4
```

This doesn't work for me as of 0.4.0: issue # 1011.
However it still works when using the package file as in the following section:

## 13.3.2 Compiling the package to a package file
You can compile the package's source code into a package file like this:
`mojo package mypackage -o mypackage.mojopkg`

Now the package source code can be moved elsewhere, and the project structure looks like this:

use_package.mojo
mypackage.mojopkg

Executing `mojo use_package.mojo` still gives the same output.

>Note: You could have named the package file in the command as mypack.mojopkg. Then you would have to change the import statements using mypack.mymodule instead of mypackage.mymodule. Renaming the package file after executing the package command does not work.

If you want to get rid of the package file, use the command:  
`mojo build use_package.mojo -o executable`  
Then `./executable` gives the same output, even when the .mojopkg file is removed.

Now you module is distributable!

>Note: If you change the name of the package folder, you have to run a new package command and change the import statement.

## 13.3.3 The __init__ file
This file must be in the package folder in order for Mojo to recognize the folder as a package.  
It can be empty, or it can allready import the module members, like this:
`from .mymodule import MyPair`  
Then the import statements in `use_package.mojo` can be simplified to:  
`from mypackage import MyPair`

This is applied in the standard library. For example: algorithm/__init__.mojo contains:  
```mojo
from .functional import *
from .reduction import *
```

so the statement for importing the map() function can be reduced to:  
`from algorithm import map`