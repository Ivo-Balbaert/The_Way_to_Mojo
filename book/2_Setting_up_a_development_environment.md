# 2 - Setting up a development environment

## 2.1 Architectures and compilers

**Target OS’s and platforms**  
Because Mojo has an LLVM/MLIR compiler infrastructure, it can target a very wide spectrum of operating systems, computation environments and hardware platforms.

**Compiler**  
By default, Mojo code is AOT (Ahead Of Time) compiled.  
But Mojo can also be interpreted or JIT-compiled, as in the Mojo Playground (see ??) or the Mojo REPL.
If the Mojo app contains dynamic (Python) code, this is executed by running the dynamic code at compile time with an embedded CPython interpreter. This mechanism also makes possible compile-time meta-programming.

**Standard library**   
Mojo has a growing standard library called `MojoStdlib` , which already contains a growing number of *modules*, such as Atomic, Benchmark, List, OS, Tensor, Testing, and so on (see § ??).

## 2.2 Using a Mojo binary release
?? These can be downloaded from [here]().

### 2.2.1 On Windows
This is currently (??) still in a testing phase.

### 2.2.2 On Linux (or WSL2 on Windows)

**Some info on WSL**  
You can view Linux folders in Explorer by giving the following command in WSL: `explorer.exe .`
When having trouble starting a remote WSL window in VSCode, uninstall and reinstall the Remote WSL Window extension in VSCode; restart VSCode.
When the WSL terminal doesn’t start up, disable Windows Hypervisor in Windows Features, reboot, enable Windows Hypervisor in Windows Features , reboot.
(Alternatively, you can do wsl --terminate and wsl --update)   
See also: [Troubleshooting Windows Subsystem for Linux | Microsoft Docs](https://learn.microsoft.com/en-us/windows/wsl/troubleshooting)

### 2.2.3 On MacOS

## 2.3 Testing the installation - Mojo's option flags

## 2.4 How to install Mojo platform dependencies

## 2.5 Building Mojo from source

### 2.5.1 Downloading the Mojo source code
For this you need the `git` tool.  
If you don't already have git installed:  
* On Windows: Install via chocolatey:
- install chocolatey: https://chocolatey.org/install
- choco install git
* On Linux (WSL2): `sudo apt install git`

On Windows:
    - Go to c:\ in a cmd-terminal with Administrator priviliges.
    - Download the Mojo repo (+- 116 MB) with the command: `git clone https://github.com/Mojo-lang/Mojo`
      the Mojo repository will now be in c:\Mojo.

On Linux:
    - Make a new folder $HOME/Mojo_repo, `cd Mojo_repo`
    - Download the Mojo repo (+- 116 MB) with the command: `git clone https://github.com/Mojo-lang/Mojo`

On both platforms, you'll see an output like:  
```
Cloning into 'Mojo'...
remote: Enumerating objects: 208673, done.
remote: Counting objects: 100% (4878/4878), done.
remote: Compressing objects: 100% (1735/1735), done.
Receiving objects: 100% (208673/208673), 88.53 MiB | 11.05 MiB/s, done.d 203795

Resolving deltas: 100% (142374/142374), done.
```

### 2.5.2  Building Mojo

## 2.6  Running the Mojo test suite

## 2.7  Editors

## 2.7.1 The Mojo online playground
Mojo has an [online playground](https://playground.modular.com/), which you can access by admission and a token. 
This is useful when:
* you don't have access (yet) to a local Mojo installation 
* you don't want to clutter your machine with a local Mojo installation 

Mojo works in a REPL environment, like a Jupyter notebooks. To do that, it is interpreted, or JIT (Just In Time) compiled. 
In the Playground Mojo is running on a hosted JupyterLab server. Access is granted after signing in with your email-address.  

**To get entrance:**  
1- Go to the [official Modular Get Started form](https://www.modular.com/get-started)
2- Fill out the form, tick Mojo and press submit
3- In a few hours/days you'll get an email with a button "Access the Mojo Playground"

**Alternative way:**   
In general the PlayGround's URL is `https://playground.modular.com/user/<your_email>`.
You need a token for initial entry, and for subsequent accesses after expiration of the tokens. The token is sent to you by email, but you can generate one [here](https://playground.modular.com/hub/token) too.
Then change the email address and token in the following URL:
`https://playground.modular.com/user/<your_email>/?token=<your_token>`

The Playground is a collection of Jupyter notebooks which you can execute. They are run by a Mojo kernel. You can also save them under a different name, and change or add new code.

When working with Jupyter notebooks, it's not allowed to mix Python and Mojo code in one cell. 
The `%%python` is used at the top of a notebook cell in Mojo to indicate that the cell contains Python code. Variables, functions, and imports defined in a Python cell are available for access in future Mojo cells. This allows you to write and execute normal Python code within a Mojo notebook.

Example:
When the Playground is started up, start a new notebook with:  
> File > New Notebook

Then add some code and push the run button  "▶" and the computation result is shown below the cell.  
Don't worry about the program code, that will all be explained in the coming sections.
See [screenshot](https://github.com/Ivo-Balbaert/The_Way_to_Mojo/blob/main/images/Mojo%20Playground.png)

To install Jupyter notebook locally:  
* First install Python from `https://www.python.org/downloads/`
* pip install notebook
Then `jupyter notebook` command starts up a local browser page where you can start a new notebook with the `.ipynb` extension.

See also: § 2.7.2 for how to work with a Jupyter notebook in VS Code.

### 2.7.2 Visual Studio Code (VS Code)
This is one of the most popular programmer’s editors today (https://code.visualstudio.com/)

There is an *official plugin Mojo Lang* (mojo-lang) [here](https://marketplace.visualstudio.com/items?itemName=mojo-lang.mojo-lang&ssr=false#review-details) which is at v0.1.0 and provides syntax-highlighting. Later a LS (Language Server) will be added.

There is also another plugin [Mojo-lang](https://marketplace.visualstudio.com/items?itemName=CristianAdamo.mojo&ssr=false#review-details) by Cristian Adamo.


#### 2.7.2.1 An easy way to execute code 
(?? this works only after local installation)  

Install the [vs-code-runner](https://marketplace.visualstudio.com/items?itemName=HarryHopkinson.vs-code-runner).  
File, Preferences, Settings:  
	Search for:  code-runner:   
    Click on the "edit in settings.json" button.  
    Now a .json-file should've opened. Add the "Mojo" line to the Executor map:  
    "code-runner.executorMap": {
        "Mojo": "Mojo $fileName",
    ...
    }
    Close Settings  
    Restart VSCode.  

Now F1 + select "Run Custom Command" or "CTRL+ALT+N" compiles and executes the source code in the editor. See [screenshot](https://github.com/Ivo-Balbaert/The_Way_to_Mojo/blob/main/images/Using_Mojo_Playground_in_VSCode.png).


#### 2.7.2.2 How to work with a Jupyter notebook in VS Code 
You can also use the Mojo Playground (§ 2.7.1) to run a notebook from within VS Code.

**Here are the steps:**     
1- Install the [Jupyter VS Code extension](https://marketplace.visualstudio.com/items?itemName=ms-toolsai.jupyter)  
2- From the Command Palette (CTRL+SHIFT+P or CMD+SHIFT+P) select "Create: New Jupyter Notebook"  
3- Then from the Command Palette again select Notebook: "Select Notebook Kernel" and follow the options:  
Select another kernel > Existing Jupyter Server > Enter the URL of a 
running Jupyter Server.   
Enter: `https://playground.modular.com/user/<your_email>/?token=<your_token>`  

It is often easier to first restart the Mojo Playground server is you still have a browser session open with it. Then you can connect to it from within VS Code.  
Now you can write Mojo code and run it within a cell of the notebook!  
See next section for a screenshot of code in this environment.

**Tips and Troubleshooting:**    
Every time you want to use it, you'll need to start the server from your browser. But you can the add the link without your username and it'll remember your session via cookies through the command: `open 'https://playground.modular.com'`.

You'll likely need to restart the kernel at some point, you can use:
Command Palette > Jupyter: Restart Kernel

See:  
* https://marketplace.visualstudio.com/items?itemName=ms-toolsai.jupyter
* https://github.com/microsoft/vscode-jupyter/wiki/Connecting-to-a-remote-Jupyter-server-from-vscode.dev

#### 2.7.2.3 Compiling and executing a simple program
To get started with Mojo code, [here](https://github.com/Ivo-Balbaert/The_Way_to_Mojo/blob/main/images/first_program.png) are two simple snippets:  


You can find the code in `first_code.ipynb`, or in the corresponding Mojo source files.
The first is the usual "Hello World!" program, which is in Mojo exactly the same as in Python, because Mojo is a superset of Python:

See `hello_world.mojo`:
```py
fn main():
    print("Hello World from Mojo!") # => Hello World! from Mojo
```

In a source file however we have to use a starting point function called `main` (see § 3.1).

(To show the output of statements in code sections, we'll show them in a comment that starts with `# =>`.)

The second snippet shows a main function, which declares an integer x, increments it and then prints it out. The function is then called with main().

See `using_main.mojo`:
```py
fn main():
    var x: Int = 1
    x += 1
    print(x)  # => 2

main()
```

We'll dive deeper into this code at the start of the next chapter.