# 13 Modules and packages

## 3.6 Importing modules 
(does this need to be here??)
Mojo can import Python modules as well as modules written in Mojo itself. Here we show you the general syntax for doing so. We'll encounter many more concrete examples later on.

## 3.6.1 Mojo modules
The code of the standard library is written in *modules*. Modules are sometimes bundled together in *packages*. Module- and package names are written in all lowercase, like in Python.  

The most common code is stored in the package `builtin`, like modules bool, int and dtype. Their code is automatically imported, so the types and functions of these modules are always available in your Mojo programs. 

Other modules can be imported like this: (better example ??)

```py
from benchmark import benchmark
```

Then you can use the type benchmark with the dot-notation to access its members like this:  
`benchmark.run`

To avoid name-clashes or simply to shorten the name, you can use `as` to define an alias:  
```py
from benchmark import benchmark as bm
```

Then access its members with: `bm.run`

`memory` is a package, containing the modules anypointer, memory and unsafe. To import something from the unsafe module, write the following:

```py
from memory.unsafe import Pointer
```

>Note: These from statements can be written everywhere in code, but code clarity can be enhanced by grouping them at the start of a code file.

If you have many types to import, enclose them within (), like this:
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
`from math import *`.  
However, it is recommended to only import the things you need.

>Note: You can also use:
```py
import benchmark
# or:
import benchmark as bm
```

But then you have to access its members with: `benchmark.Benchmark.num_warmup` or `bm.Benchmark.num_warmup`, prefixing the member name with the module name. This is better than using from ... import *, because doing so you loose the info from which module the function/type is imported.

For some examples see: ??

## 3.6.2 Python modules
Mojo can access the whole Python ecosystem by importing Python modules.
Importing and using a Python package in Mojo is very easy.  
Here's an example (from a Jupyter notebook cell) of how to import the NumPy package:

```py
from python import Python                   # 1
alias np = Python.import_module("numpy")      # 2
```

First you have to import the Python module as in line 1: `from python import Python`.  
Then you can use the `Python.import_module()` function with the module name (see line 2). You give it a constant name (here `np`), which can be used later to call module methods.
(The equivalent of this line in Python would be: `import numpy as np`.) 
Note that the .py extension for the module is not needed.
For some concrete examples see: ??

--------------------------------------------------------------------------------------------------
We talked about how to import modules from the standard libraries of Mojo and Python in § 3.6, and how to import a local custom Python module in § 8.4. 
Now we'll see how we import a local custom Mojo module in § 13.2.
Mojo provides a packaging system that allows you to organize and compile code libraries into importable files.  
Here we'll learn how to organize your code into modules and packages (which is a lot like Python), and shows you how to create a packaged binary with the `mojo package` command.

## 13.1 What are modules and packages?
We have seen that the Mojo standard library is organized in *packages*, each package grouping one or more related *modules*.  

Most of our programs until now contains a fn main() starting point, and were meant to be run (with their name)  
But often you want to assemble code (like a struct with its methods and helper functions) so that you can reuse this in many programs. In that case the code you write is called a module, which doesn't need a main() function because we don't want the code to start as such. The functions/types (the API) of this module can be imported in another program, which does contain a main() function to start it.

A Mojo *module* is a single Mojo source file that includes code like an API, suitable for use by other files that import it.  
The module gets its name from the filename (without the extension), for example: a file `module1.mojo` contains the code for module `module1`.  
The code in a module has no main() function, so you can't execute a module like in module1.mojo. However, you can import this into another file with a main() function and use it there.  

A Mojo *package* is just a collection of Mojo modules in a directory that includes an `__init__.mojo` file. The directory name works as the package name when importing the package.  

>Note: The packages of the Mojo standard library are stored in `/home/username/.modular/pkg/packages.modular.com_mojo/lib/mojo`


You can import all the modules from a package together or individually.
For example: the map() function resides in the `functional` module in the `algorithm` package, so you can import it as:
`from algorithm.functional import map`.  
Optionally, you can also compile the package into a `.mojopkg` or `.📦` file that's easier to share (see § 13.3.2).

## 13.2 Importing a local Mojo module
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
from mymodule import MyPair as mp1 # 1B
import mymodule                    # 2
import mymodule as mp              # 3

fn main():
   varmine = MyPair(2, 4)    # 3
    mine.dump()     # => 2 4
   varmine2 = mp1(2, 4)    # 3
    mine2.dump()     # => 2 4
   varmine3 = mymodule.MyPair(2, 4)    
    mine3.dump()    # => 2 4
   varmine4 = mp.MyPair(2, 4)    
    mine4.dump()    # => 2 4
```

The familiar syntax `from modname import type/method` us used. In line 2 we see that we can even rename the imported object with `as`, for shortness or to avoid name clashes. The code in main makes 2 MyPair instances, and prints them out.
This works when the module is in the same folder as use_module.mojo. Example other location??
(Currently Sep 2023, you can't import .mojo files as modules if they reside in other directories.)

You can import the whole module and then access its members through the module name.   
Then line 1 changes to:  `import mymodule`                
and line 3 to:           `let mine = mymodule.MyPair(2, 4)`

Here also you can give the module another name, so you could write:  
Line 1                :  `import mymodule as mp`                
and line 3 to:           `let mine = mp.MyPair(2, 4)`

## 13.3 Importing a local Mojo package
You can import a package and its modules either directly from source files or from a compiled `.mojopkg` or `.📦` file. It makes no real difference to Mojo which way you import a package. When importing from source files, the directory name works as the package name, whereas when importing from a compiled package, the filename is the package name (which you specify with the mojo package command, so it can differ from the directory name).  

## 13.3.1 Importing the package as source code
(?? Issue 1011)
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
   varmine = MyPair(2, 4)    # 3
    mine.dump()     # => 2 4
   varmine2 = mp1(2, 4)    # 3
    mine2.dump()     # => 2 4
   varmine3 = mymodule.MyPair(2, 4)    
    mine3.dump()    # => 2 4
   varmine4 = mp.MyPair(2, 4)    
    mine4.dump()    # => 2 4
```

>Note: The __init__.mojo is crucial here. If you delete it, then Mojo doesn't recognize the directory as a package and it cannot import mymodule.  

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

The code in a .mojopkg file is parametric bytecode, obtained by compiling Mojo source code with OrcJIT.

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
`from algorithm import map`