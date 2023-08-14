# 2 - Setting up a development environment

## 2.1 The Mojo online playground
Mojo works in a REPL environment, like a Jupyter notebooks. To do that, it is interpreted, or JIT (Just In Time) compiled.  
Use the [online playground](https://playground.modular.com/) to try out the language without local installation (In the Playground Mojo is running Mojo on a hosted JupyterLab server). Access is granted after signing in with your email-address.  
This is a collection of Jupyter notebooks, which you can execute. You can also save them under a different name, and change or add new code. 

## 2.2 Architectures and compilers

Target OS’s and platforms:

**Compiler**  
By default, Mojo code is AOT (Ahead Of Time) compiled. If the Mojo app contains dynamic (Python) code, this is executed by running the dynamic code at compile time with an embedded interpreter. This mechanism also makes possible compile-time meta-programming.

**Standard library**  

## 2.3 Using a Mojo binary release
?? These can be downloaded from [here]().

============================================================================

### 2.2.1 On Windows
This is currently (??) still in a testing phase.

### 2.2.2 On Linux (or WSL2 on Windows)

**Some info on WSL**  
You can view Linux folders in Explorer by giving the following command in WSL: `explorer.exe .`
When having trouble starting a remote WSL window in VSCode, uninstall and reinstall the Remote WSL Window extension in VSCode; restart VSCode.
When the WSL terminal doesn’t start up, disable Windows Hypervisor in Windows Features, reboot, enable Windows Hypervisor in Windows Features , reboot.
(Alternatively, you can do wsl --terminate and wsl --update)   
See also: [Troubleshooting Windows Subsystem for Linux | Microsoft Docs](https://learn.microsoft.com/en-us/windows/wsl/troubleshooting)

### 2.2.4 On MacOS

## 2.4 Testing the installation - Mojo's option flags

## 2.5 How to install Mojo platform dependencies

### 2.4.1 On Windows

### 2.4.2 On Linux (or WSL2 on Windows)

### 2.4.3 On MacOS
??

## 2.6 Building Mojo from source

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


### 2.5.6  Building Mojo

### 2.5.7  Running the Mojo test suite

## 2.7  Editors

### 2.6.1 Vim

### 2.6.2 Visual Studio Code (VS Code)
This is one of the most popular programmer’s editors today (https://code.visualstudio.com/)

There is an official plugin Mojo Lang (mojo-lang) [here](https://marketplace.visualstudio.com/items?itemName=mojo-lang.mojo-lang&ssr=false#review-details) which is at v0.1.0 and provides syntax-highlighting.

There is also another plugin [Mojo-lang](https://marketplace.visualstudio.com/items?itemName=CristianAdamo.mojo&ssr=false#review-details) by Cristian Adamo.




#### 2.6.2.1 An easy way to execute code
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

Now F1 + select "Run Custom Command" or "CTRL+ALT+N" compiles and executes the source code in the editor. See [screenshot](https://github.com/Ivo-Balbaert/The_Book_Of_Mojo/blob/master/images/vscode.png).


## 2.7.3 Benchmarks
