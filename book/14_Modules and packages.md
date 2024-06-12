# 14 Modules and packages
In this section we discuss how to import modules from the standard libraries of Mojo and Python in § 14.1, and how to import a local Python module in § 14.1.2. 

In § 14.2 we'll see how we import a local custom Mojo module.
Mojo provides a packaging system that allows you to organize and compile code libraries into importable files.  
Here we'll learn how to organize your code into modules and packages (which is a lot like Python), and shows you how to create a packaged binary with the `mojo package` command.

If you want more examples on how to integrate Python modules, see § 8 !!.


## 14.1 Importing standard-library modules 
Mojo can import Python modules as well as modules written in Mojo itself. Here we show you the general syntax for doing so. 

### 14.1.1 Mojo modules
The code of the standard library is written in *modules*. Modules are sometimes bundled together in *packages*. Module- and package names are written in all lowercase, like in Python.  

The most common code is stored in the package `builtin`, like modules bool, int and dtype. Their code is automatically imported, so the types and functions of these modules are always available in your Mojo programs. 

Other structs or functions in modules can be imported like this: 

```py
from testing import assert_equal     # function
from memory.unsafe import Pointer    # struct
```

Here `memory` is a package containing the `unsafe` module.
Then you can use the type's methods with the dot-notation to access its members like in this code snippet:  
```py
fn main():
    var a = 1
    var ptr = Pointer.address_of(a)   
    print(ptr.__int__())    # => 140735944706984
```

To avoid name-clashes or simply to shorten the name, you can use `as` to define an alias:  
```py
from memory.unsafe import Pointer as Pt
```

Then access its members with: `Pt.address_of(a)`

>Note: These from statements can be written everywhere in code, but code clarity can be enhanced by grouping them at the start of a code file.

If you have many things to import, enclose them within (), like this:
```py
from sys.info import (
    alignof,
    sizeof,
    bitwidthof,
    simdwidthof,
    simdbitwidth,
    simdbytewidth,
)
```

To import all types and functions from a module (say math), use:  
`from math import *` or
`import math`
This general form has two drawbaks:
* Importing everything needs more memory, perhaps for things you won't need.
* Also you loose the info from which module the function/type is imported, which can be important while developing/debugging.

### 14.1.2 Python modules
Mojo can access the whole Python ecosystem by importing Python modules.
Importing and using a Python package in Mojo is very easy.  
Here's an example of how to import the NumPy package:

```py
from python import Python                     # 1
alias np = Python.import_module("numpy")      # 2
```

First you have to import the Python module as in line 1: `from python import Python`.  
Then you can use the `Python.import_module()` function with the module name (see line 2). 
(For this the work, the numpy module must already be installed on the local machine.)
You give it a constant name (here `np`), which can be used later to call module methods.
(The equivalent of this line in Python would be: `import numpy as np`.) 
Note that the .py extension for the module is not needed.
For some concrete examples see § 8.3


## 14.2 What are modules and packages?
We have seen that the Mojo standard library is organized in *packages*, each package grouping one or more related *modules*.   
A Mojo *module* is a single Mojo source file that includes code (like an API), suitable for use by other files that import it. The source file name is also the module's name.  

*Why making a module?*
Most of our programs until now contains a fn main() starting point, and were meant to be run (with their name)  
But often you want to assemble code (like a struct with its methods and helper functions) so that you can reuse this in many programs. In that case the code you write is called a module, which doesn't need a main() function because we don't want the code to start as such. The functions/types (the API) of this module can be imported in another program that uses the module, and which does contain a main() function to start it.

The module gets its name from the filename (without the extension), for example: a file `module1.mojo` contains the code for module `module1`.  
The code in a module has no main() function, so you can't execute a module like in module1.mojo. However, you can import this into another file with a main() function and use it there.  

A Mojo *package* is just a collection of Mojo modules in a directory that includes an `__init__.mojo` file. By organizing modules together in a directory, you can then import all the modules together or individually. The directory name works as the package name when importing the package. Optionally, you can also compile the package into a .mojopkg or .📦 file that's easier to share and still compatible with other system architectures. 

>Note: The packages of the Mojo standard library are stored in `/home/username/.modular/pkg/packages.modular.com_mojo/lib/mojo`

You can import all the modules from a package together or individually.
For example: the map function resides in the `functional` module in the `algorithm` package, so you can import it as:
`from algorithm.functional import map`.  
Optionally, you can also compile the package into a `.mojopkg` or `.📦` file that's easier to share (see § 14.3.2).

## 14.3 Importing a local Mojo module
Doing this is as easy as for Python modules.
Suppose we have functionality of a pair of integers in `mymodule.mojo`. 

See `mymodule.mojo`:
```py
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
```py
from mymodule import MyPair        # 1
from mymodule import MyPair as mp1 # 2
import mymodule                    # 3
import mymodule as mp              # 4

fn main():
    var mine = MyPair(2, 4)    # 1B
    mine.dump()     # => 2 4
    var mine2 = mp1(2, 4)    # 2B
    mine2.dump()     # => 2 4
    var mine3 = mymodule.MyPair(2, 4) # 3B   
    mine3.dump()    # => 2 4
    var mine4 = mp.MyPair(2, 4)   # 4B 
    mine4.dump()    # => 2 4
```
The file structure for this example is:
```
somefolder/
    mymodule.mojo
    use_module.mojo or main.mojo
```

The familiar syntax `from modname import type/method` is used. In line 2 we see that we can even rename the imported object with `as`, for shortness or to avoid name clashes. The code in main makes 2 MyPair instances, and prints them out.

You can import the whole module and then access its members through the module name.   
Then line 1 changes to:  `import mymodule`                
and line 3 to:           `let mine = mymodule.MyPair(2, 4)`

Here also you can give the module another name, so you could write:  
Line 1                :  `import mymodule as mp`                
and line 3 to:           `let mine = mp.MyPair(2, 4)`

>Note: This works when the module is in the same folder as use_module.mojo. Example other location!!
(Currently Sep 2023, you can't import .mojo files as modules if they reside in other directories.)

## 14.4 Importing a local Mojo package
You can import a package and its modules either directly from source files or from a compiled `.mojopkg` or `.📦` file. It makes no real difference to Mojo which way you import a package. When importing from source files, the directory name works as the package name, whereas when importing from a compiled package, the filename is the package name (which you specify with the mojo package command, so it can differ from the directory name).  

### 14.4.1 Importing the package as source code
For our example, let's continue to work on the code from § 14.2. Suppose our project structure is like this:   

The file structure for this example using packages is:
```
somefolder/
    use_package.mojo  or main.mojo
    mypackage/
        __init__.mojo
        mymodule.mojo
```

mymodule.mojo is exactly the same as in § 14.1, __init__.mojo must be an empty file.
use_package.mojo has the same code in main(), but the import statements are now prefixed wit the package name:

See ``use_package.mojo`:
```py
from mypackage.mymodule import MyPair   # 1

fn main():
    var mine = MyPair(2, 4)  # 1B
    mine.dump()     # => 2 4
```

>Note: The __init__.mojo is crucial here. If you delete it, then Mojo doesn't recognize the directory as a package and it cannot import mymodule.  

Executing `mojo use_package.mojo`  gives as output:
```
2 4
```

>Note: sometimes stil crash when starting with code only (usie 1011), ben then when package file is made, it works as a package. When package is removed it still works with code only.


### 14.4.2 Compiling the package to a package file
You can compile the package's source code into a package file like this:
`mojo package mypackage -o mypackage.mojopkg`

The code in a .mojopkg file is parametric bytecode, obtained by compiling Mojo source code with OrcJIT.

Now the package source code can be moved elsewhere (so the user doesn't need to have the source code on his machine), and the project structure looks like this:
```
use_package.mojo
mypackage.mojopkg
```

Executing `mojo use_package.mojo` still gives the same output.

>Note: You could have named the package file in the command as mypack.mojopkg. Then you would have to change the import statements using mypack.mymodule instead of mypackage.mymodule. Renaming the package file after executing the package command does not work.
>Note: If you change the name of the package folder, you have to run a new package command and change the import statement.

If you want to get rid of the package file, use the command:  
`mojo build use_package.mojo -o executable`  
Then `./executable` gives the same output, even when the .mojopkg file is removed.
Now you app is distributable in only one file.


### 14.4.3 Using the __init__ file to simplify import
This file must be in the package folder in order for Mojo to recognize the folder as a package.  
It can be empty, or it can already import the module members, like this:
`from .mymodule import MyPair`  
Then the import statements in `use_package.mojo` can be simplified to:  
`from mypackage import MyPair`

This is applied in the standard library. For example: algorithm/__init__.mojo contains:  
```py
from .functional import *
from .reduction import *
```

so the statement for importing the map() function can be reduced to:  
`from algorithm import map` instead of writing:
`from algorithm.functional import map`