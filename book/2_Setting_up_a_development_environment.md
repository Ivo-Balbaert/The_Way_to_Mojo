# 2 - Setting up a development environment
You can execute code in the [Online Playground](https://docs.modular.com/mojo/playground) or install it locally, see §2.2.


## 2.1 Architectures and compilers

### 2.1.1 Target OS's and platforms
2023 Aug 26: Currently, the Mojo SDK is for Linux only (Ubuntu 16.04 or higher, other distro's)
2023 Oct 19: Now support for Apple silicon is added (M1 and M2 processors)

Native support for Apple (Intel) and Windows is coming.

The LLVM/MLIR compiler infrastructure together form a cutting-edge compiler and code generation system. Because Mojo uses this system, it can target a very wide spectrum of operating systems, computation environments and hardware platforms.

    the MLIR/LLVM repo uses bazel: https://bazel.build/start/cpp

    Mojo primarily uses the LLVM and Index dialects of MLIR. These are the mainline MLIR dialects used by Modular. The Mojo compiler also has a number of internal dialects, including pop and kgen, but they are not documented and are subject to frequent changes as they are internal implementation details of the compiler. It's recommended to stick with the LLVM and other dialects that are more stable.

    For specific hardware and accelerators, the dialects used can vary. For example, Modular uses LLVM level dialects and leverages LLVM for the targets it supports, such as talking directly to both the Apple and Intel AMX instructions.

### 2.1.2 Compiler
The compiler is written in C++, based on MLIR and LLVM.
By default, Mojo code is AOT (Ahead Of Time) compiled, which is needed for AI deployment. 
But Mojo can also be interpreted for metaprogramming, or JIT-compiled, as in the Mojo REPL or Jupyter notebook.
If the Mojo app contains dynamic (Python) code, this is executed by running the dynamic code at compile time with an embedded CPython interpreter. This mechanism also makes possible compile-time meta-programming.

Structure of compiler: video 2023 LLVM Dev Mtg:
    https://www.youtube.com/watch?v=SEwTjZvy8vw  (21' / 24')
    compiler pipeline, Elaborator

OrcJit is used for Just in Time compilation, but also for generating static archive .a file. The system linker then transforms this into an executable file.

### 2.1.3 Runtime
- for Python code: calls the CPython interpreter, which talks toh the Mojo compiler 
- a built-in GC to clean up Python objects, based on reference counting


On a new Ubuntu system, make sure to install:
`sudo apt-get install -y git gcc g++ zlib1g-dev libtinfo-dev`

### 2.1.4 Standard library**   
Mojo has a growing standard library called stdlib or SDK, which already contains a growing number of *packages*, such as algorithm, benchmark, list, os, tensor, testing, and so on.

It is documented here [here](https://docs.modular.com/mojo/lib).

A package is a collection of modules that serve the same purpose,

??
example: the math package contains the bit, math, numerics, and polynomial modules
The packages are built as binaries into the SDK to improve startup speed. (??)
Package and module names are lowercase (like Python).

?? update
Version 24.2.0 (2024 Mar 29) ships with the following 20 packages, containing 83 modules:

* algorithm
* autotune
* base64
* benchmark
* buffer
* builtin
* collections
* complex
* math
* memory
* os
* pathlib
* python
* random
* stat
* sys
* tensor
* testing
* time
* utils

!! adapt


## 2.2 Installing the Mojo toolkit
To do this, we first need to install [Magic](https://docs.modular.com/magic). 
This is a a virtual environment and package manager based on conda. It allows you to create fully contained projects, where the package dependencies and environment settings are magically managed for you.

Magic uses links.  While magic is "adding" max+mojo to every project (that you ask it to), it is not installing the whole SDK to each project. There is a system cache of all packages installed for all the projects and there are links to the cache. 

### 2.2.1 Installing Magic
Install Magic in seconds with the following command: `curl -ssL https://magic.modular.com | bash`

This produces the output:  
```
Installing the latest version of Magic...
######################################################################## 100.0%
Done. The 'magic' binary is in '/home/ivo-balbaert/.modular/bin'

Two more steps:

1. To use 'magic', run this command so it's in your PATH:

source /home/ivo-balbaert/.bashrc 

2. To build with MAX and Mojo, go to http://modul.ar/get-started
```

The source command ensures that the magic command is system-wide usable.

Try `$ magic -h` to see what it can do and `$ magic -V` to check which version is installed.

$ magic -V
magic 0.3.1 - (based on pixi 0.29.0)

Update the tool with: $ magic self-update

Enable auto-completion with: 
BASHRC=$( [ -f "$HOME/.bash_profile" ] && echo "$HOME/.bash_profile" || echo "$HOME/.bashrc" )
echo 'eval "$(magic completion --shell bash)"' >> "$BASHRC"ggg
source "$BASHRC"

Create a `mojo` folder which will contain all our mojo projects, and cd in it. 

Create a Mojo project named `mojo-project1` with magic init: `magic init mojo-project1 --format mojoproject`
```
 Created /home/ivo-balbaert/mojo/mojo-project1/mojoproject.toml
✔ Added max >=24.5.0,<25
```

Mojo is a subset of the Max project, so Mojo is now installed!
The project is by default git ready.

It contains a `mojoproject.toml` file:
```
[project]
channels = ["conda-forge", "https://conda.modular.com/max"]
description = "Add a short description here"
name = "mojo-project1"
platforms = ["linux-64"]
version = "0.1.0"

[tasks]

[dependencies]
max = ">=24.5.0,<25"
```

The `.magic` subfolder (initial size 2.2 Gb) contains all dependencies.
The folder `$HOME/mojo/mojo-project1/.magic/envs/default/lib/mojo` contains amongst others the Mojo stdlib package.

Enter the environment shell for this project with `magic shell`. 
`(mojo-project1) ivo-balbaert@ivo-balbaert-MEG-Z690-Aegis-Ti5-MS-B939:~/mojo/mojo-project1$`
       ^
       |
   you're in your project environment

Running `mojo --version` to get: mojo 24.5.0 (e8aacb95)

[magic.lock](https://docs.modular.com/magic#the-magiclock-file) 


`mojo build using_main.mojo` 
/usr/bin/ld: cannot find -lz: No such file or directory
/usr/bin/ld: cannot find -ltinfo: No such file or directory
collect2: error: ld returned 1 exit status
mojo: error: failed to link executable

Solution: see sudo install above

Run `exit` to get back to the OS shell.

*Global install:*
As of magic v0.4, you can! Run magic global install max -c conda-forge -c https://conda.modular.com/max/ --expose mojo then mojo is globally exposed mojo --version outputs mojo 24.5.0 (e8aacb95)


!!! There is no difference between OS's anymore !!!

### 2.2.2 On Windows
#### 2.2.2.1 Native Windows
This version is currently (!!) still in a testing phase.

#### 2.2.2.2 Using the Windows Subsystem for Linux (WSL2)
1- On Windows: From Microsoft Store: Install Ubuntu 24.04 for WSL and open it.
2- Install VS Code, the WSL extension, and the [Mojo extension](https://marketplace.visualstudio.com/items?itemName=modular-mojotools.vscode-mojo).

### 2.2.3 On MacOS 
See [Mojo website](https://docs.modular.com/mojo/manual/get-started/index.html)

### 2.2.3 On Linux Ubuntu 
For installation on ArchLinux, see:
https://gist.github.com/Sharktheone/79da849c96db13f21eefa2be9430d9ec

For tool help, enter 'mojo --help'.
For more docs, see https://docs.modular.com/mojo.

Display the currently installed Mojo version with:
$ mojo -v
mojo 24.2.0 (c2427bc5)

**Info about debug options**
$ mojo build -h

## 2.3 Starting the Mojo REPL
```
$ mojo
Welcome to Mojo! 🔥
Expressions are delimited by a blank line.
Type `:mojo help` for further assistance.
1> n = 3
2. print(n)
3.
3
(Int) n = 3
3>
```
Type TAB to get code completion.

The Mojo REPL is based on LLDB, the complete set of LLDB debugging commands is also available as described below (!! examples).  
Type :quit or :q to leave the REPL.

## 2.4 Testing the mojo command
Create folder $HOME/mojo.  
Copy in examples from § 2.

$ mojo hello_world.mojo
Hello World from Mojo!
$ mojo hello_world.🔥
Hello World from Mojo!
$ $ mojo using_main.mojo
Hello Mojo!
2

## 2.5 Some info on WSL
You can view Linux folders in Explorer by giving the following command in WSL: `explorer.exe .`
When having trouble starting a remote WSL window in VSCode, uninstall and reinstall the Remote WSL Window extension in VSCode; restart VSCode.
When the WSL terminal doesn't start up, disable Windows Hypervisor in Windows Features, reboot, enable Windows Hypervisor in Windows Features , reboot.
(Alternatively, you can do wsl --terminate and wsl --update)   
See also: [Troubleshooting Windows Subsystem for Linux | Microsoft Docs](https://learn.microsoft.com/en-us/windows/wsl/troubleshooting)

## 2.6 How to update Modular and Mojo
STEPS:
1- `sudo apt-get update`
2- `sudo apt-get install modular`
3- `modular update mojo`

If there is an error about a missing lib, do:
1- Execute the command:         `modular clean`
2- Then do a fresh install:     `modular install mojo`

To install the Python virtual environment:  
`sudo apt install python3.10-venv`

## 2.7 How to remove Mojo
Issue the command: `modular uninstall mojo`

The total size of the Mojo SDK is about 345 Mb. (!!)

## 2.8 Downloading the Mojo source code
The [Mojo repo](https://github.com/modularml/mojo) currently (May 2024) only contains the source of the Mojo standard library.

For this you need the `git` tool.  
If you don't already have git installed:  
* On Windows: Install via chocolatey:
- install chocolatey: https://chocolatey.org/install
- choco install git
* On Linux (or WSL2): `sudo apt install git`

On Windows:
    - Go to c:\ in a cmd-terminal with Administrator priviliges.
    - Download the Mojo repo with the command: `git clone !!`
      the Mojo repository will now be in c:\Mojo.

On Linux:
    - Make a new folder $HOME/Mojo_repo, `cd Mojo_repo`
    - Download the Mojo repo with the command: `git clone !!`

On both platforms, you'll see an output like:  
```
Cloning into 'Mojo'...
remote: Enumerating objects: 208673, done.
remote: Counting objects: 100% (4878/4878), done.
remote: Compressing objects: 100% (1735/1735), done.
Receiving objects: 100% (208673/208673), 88.53 MiB | 11.05 MiB/s, done.d 203795

Resolving deltas: 100% (142374/142374), done.
```

## 2.9 The Mojo configuration file
?? irrelevant
There is a configuration file at `/home/username/.modular/modular.cfg`, which contains a number of mainly path environment variables, which can be edited. 
For example:  
`import_path`, which has as default value /home/username/.modular/pkg/packages.modular.com_mojo/lib/mojo. This contains the path where Mojo searches for packages used in code. You can add your own package folder(s) to the default value (separated by a ;).

## 2.10  Editors
### 2.10.1 A vim plugin
See https://github.com/czheo/mojo.vim for Mojo syntax highlighting.

### 2.10.2 Working with a Jupyter notebook
Mojo works in a REPL environment, like a Jupyter notebooks. 

1) First you have to install the Mojo SDK. 
2) To install Jupyter notebook locally:  
* First install Python from `https://www.python.org/downloads/`
* `pip install notebook`
Then the `jupyter lab` or `jupyter notebook` command starts up a local browser page where you can start a new notebook with the `.ipynb` extension.

Example:
Start a new notebook with:  
> File > New Notebook

Then add some code, choose Mojo as kernel, and push the run button  "▶" and the computation result is shown below the cell.  
Don't worry about the program code, that will all be explained in the coming sections.
3) You can clone the Mojo notebooks sources with `git clone <https://github.com/modularml/mojo.git>`.

When working with Jupyter notebooks, it's not allowed to mix Python and Mojo code in one cell. 
The `%%python` is used at the top of a notebook cell in Mojo to indicate that the cell contains Python code. Variables, functions, and imports defined in a Python cell are available for access in future Mojo cells. This allows you to write and execute normal Python code within a Mojo notebook.

See also: § 2.7.2 for how to work with a Jupyter notebook in VS Code.

### 2.10.3 Visual Studio Code (VS Code)
This is one of the most popular programmer's editors today (https://code.visualstudio.com/)

The *official plugin* for Mojo is called [modular-mojotools.vscode-mojo](https://marketplace.visualstudio.com/items?itemName=modular-mojotools.vscode-mojo). It features (v 24.2.1):
* Syntax highlighting for .mojo and .🔥 files

!! Table with hotkeys (⌘ for macOS, CTRL in Linux and Windows)

* Outline of code, with struct fields and methods, global variables, functions, main() in particular.
* Code completion: To trigger a completion press CTRL+SPACE, pressing CTRL+SPACE again will bring up doc hints
* Hover (or CTRL+K, CTRL+I) over a symbol for API docs
* Signature help with overloading functions: CTRL+SHIFT+SPACE
* Code diagnostics and quick fixes (CTRL+.), use Problems tab, combine with Error Lens extension
* Go to Symbol: CTRL+SHIFT+O in Linux and Windows.
* Doc string code blocks, with code completions and diagnostics
* Code formatting: command palette run Format Document or tick the setting Format on Save
* Run Mojo File: push arrow top right, or right-click file
* When there is a problem: use the command palette, search for Mojo: Restart the extension
* A *fully featured LLDB debugger* and a *Mojo LLDB plugin* are included (see § 10.7).

> Note: If you prefer working with the command-palette, use CTRL+SHIFT+P to open it up. Type in Mojo and you'll see all available commands, then select the one you want to work with.

### 2.10.4 How to work with a Jupyter notebook in VS Code 
Doesn't work !!

" The current Mojo SDK version is incompatible with this version of the Mojo extension. Please update your SDK to ensure the extension behaves correctly. "

1- Install the [Jupyter VS Code extension](https://marketplace.visualstudio.com/items?itemName=ms-toolsai.jupyter)  
2- From the Command Palette (CTRL+SHIFT+P or CMD+SHIFT+P) select "Create: New Jupyter Notebook"  
3- Then from the Command Palette again select Notebook: "Select Notebook Kernel" and follow the options:  

Start up a Jupyter notebook as explained in § 2.10.2

Now you can write Mojo code and run it within a cell of the notebook!  
See next section for a screenshot of code in this environment.

You'll likely need to restart the kernel at some point, you can use:
Command Palette > Jupyter: Restart Kernel

See:  
* https://marketplace.visualstudio.com/items?itemName=ms-toolsai.jupyter
* https://github.com/microsoft/vscode-jupyter/wiki/Connecting-to-a-remote-Jupyter-server-from-vscode.dev


### 2.10.5 Using a Docker file (!! updating)
The repo website https://github.com/modularml/mojo/tree/main/examples/docker contains a Docker example file `Dockerfile.mojosdk`. The following [article](https://medium.com/@1ce.mironov/how-to-install-mojo-locally-using-docker-5346bc23a9fe) goes into detail of how to create and use a Docker image.
See also the following [video](https://www.youtube.com/watch?v=cHyYmF-RhUk).


### 2.10.6 Jetbrains plugin for Mojo
[See here](https://plugins.jetbrains.com/plugin/23371-mojo)

 
### 2.10.7 Cloud setup in one click
https://www.youtube.com/watch?v=547UggxG_M8 


## 2.11 Compiling and executing a simple program
To get started with Mojo code, [here](https://github.com/Ivo-Balbaert/The_Way_to_Mojo/blob/main/images/first_program.png) are two simple snippets:  

The first is the usual "Hello World!" program: 

See `hello_world.mojo`:
```py
fn main():
    print("Hello World from Mojo!") # => Hello World! from Mojo
```

Apart from fn main(), this is exactly the same in Mojo as in Python, because Mojo aims to be a superset of Python:
In a Mojo source file we have to use a starting point function called `main()` (see § 3.1).
(!! Top-level statements as in Python are not yet implemented)

A version with `def` instead of `fn` is also a valid Mojo program:
See `hello_world_def.mojo`:
```py
def main():
    print("Hello World from Mojo!") # => Hello World! from Mojo
```

>Note: Don't forget the () after main, and also the () containing the value to print out after print. main and print are functions, so they expect an argument list between ()

To compile and run this source code, use the command: 
`mojo hello_world.mojo` or `mojo hello_world.🔥`.
Then the console displays: `Hello World! from Mojo`.

To show the output of statements in code sections, we'll show them in a comment that starts with `# =>`.

The second snippet shows a main function, which declares an integer x, increments it and then prints it out. 
See `using_main.mojo`:
```py
fn main():
    var x: Int = 1
    x += 1
    print(x)  # => 2
```

Remark: In the REPL, you can write top-level statements like in Python.

We'll dive deeper into this code at the start of the next chapter.

