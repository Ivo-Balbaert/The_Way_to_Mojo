# 2 - Setting up a development environment

## 2.1 Architectures and compilers

**Target OS’s and platforms** 
2023 Aug 26: Currently, the Mojo SDK is for Linux only (Ubuntu 16.04 or higher)
Native support for Windows is coming.

The LLVM/MLIR compiler infrastructure together form a cutting-edge compiler and code generation system. Because Mojo uses this system, it can target a very wide spectrum of operating systems, computation environments and hardware platforms.

    the MLIR/LLVM repo uses bazel: https://bazel.build/start/cpp

    Mojo primarily uses the LLVM and Index dialects of MLIR. These are the mainline MLIR dialects used by Modular. The Mojo compiler also has a number of internal dialects, including pop and kgen, but they are not documented and are subject to frequent changes as they are internal implementation details of the compiler. It's recommended to stick with the LLVM and other dialects that are more stable.

    For specific hardware and accelerators, the dialects used can vary. For example, Modular uses LLVM level dialects and leverages LLVM for the targets it supports, such as talking directly to both the Apple and Intel AMX instructions.

**Compiler**  
The compiler is written in C++.
By default, Mojo code is AOT (Ahead Of Time) compiled.  
But Mojo can also be interpreted for metaprogramming, or JIT-compiled, as in the Mojo Playground (see ??) or the Mojo REPL.
If the Mojo app contains dynamic (Python) code, this is executed by running the dynamic code at compile time with an embedded CPython interpreter. This mechanism also makes possible compile-time meta-programming.

**Runtime**
- to call the CPython interpreter and call with the Mojo compiler ??
- a built-in GC to clean up Python objects, based on reference counting


**Standard library**   
Mojo has a growing standard library called `MojoStdlib` or SDK, which already contains a growing number of *modules*, such as Atomic, Benchmark, List, OS, Tensor, Testing, and so on (see § ??).
A package is a collection of modules that serve the same purpose,
example: the math package contains the bit, math, numerics, and polynomial modules
The packages are built as binaries into the SDK to improve startup speed.
Package and module names are lowercase (like Python).

Version 0.2.0 ships with the following packages:
* algorithm
* autotune
* base64
* benchmark
* builtin
* complex
* math
* memory
* os
* python
* random
* runtime
* sys
* tensor
* testing
* time
* utils

## 2.2 Using a Mojo binary release
?? These can be downloaded from [here]().

### 2.2.1 On Windows
This is currently (??) still in a testing phase.

### 2.2.2 On Linux (or WSL2 on Windows)
2023 Aug 26: Mojo can be used on Windows with a Linux container or remote system.

STEPS:
1- Install VS Code, the WSL extension, and the Mojo extension.
2- Install Ubuntu 22.04 for WSL and open it.
3- In the Ubuntu terminal, install the Modular CLI:
    `curl https://get.modular.com | \
        MODULAR_AUTH=mut_e793ec8f3c514c5c9e794607eec73c84 \
        sh -`

Output:  
```
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  3176  100  3176    0     0  13282      0 --:--:-- --:--:-- --:--:-- 13288
[sudo] password for ivo:
Executing the  setup script for the 'modular/installer' repository ...

   OK: Checking for required executable 'curl' ...
   OK: Checking for required executable 'apt-get' ...
   OK: Detecting your OS distribution and release using system methods ...
 ^^^^: ... Detected/provided for your OS/distribution, version and architecture:
 >>>>:
 >>>>: ... distro=ubuntu  version=22.04  codename=jammy  arch=x86_64
 >>>>:
 NOPE: Checking for apt dependency 'apt-transport-https' ...
   OK: Updating apt repository metadata cache ...
   OK: Attempting to install 'apt-transport-https' ...
   OK: Checking for apt dependency 'ca-certificates' ...
Selecting previously unselected package python3-distutils.
Preparing to unpack .../08-python3-distutils_3.10.8-1~22.04_all.deb ...
Unpacking python3-distutils (3.10.8-1~22.04) ...
Selecting previously unselected package python3-setuptools.
Preparing to unpack .../09-python3-setuptools_59.6.0-1.2ubuntu0.22.04.1_all.deb ...
Unpacking python3-setuptools (59.6.0-1.2ubuntu0.22.04.1) ...
Selecting previously unselected package python3-wheel.
Preparing to unpack .../10-python3-wheel_0.37.1-2ubuntu0.22.04.1_all.deb ...
Unpacking python3-wheel (0.37.1-2ubuntu0.22.04.1) ...
Selecting previously unselected package python3-pip.
Preparing to unpack .../11-python3-pip_22.0.2+dfsg-1ubuntu0.3_all.deb ...
Unpacking python3-pip (22.0.2+dfsg-1ubuntu0.3) ...
Selecting previously unselected package modular.
Preparing to unpack .../12-modular_0.1.2_amd64.deb ...
Unpacking modular (0.1.2) ...
Selecting previously unselected package python3.10-dev.
Preparing to unpack .../13-python3.10-dev_3.10.12-1~22.04.2_amd64.deb ...
Unpacking python3.10-dev (3.10.12-1~22.04.2) ...
Selecting previously unselected package python3-dev.
Preparing to unpack .../14-python3-dev_3.10.6-1~22.04_amd64.deb ...
Unpacking python3-dev (3.10.6-1~22.04) ...
Setting up javascript-common (11+nmu1) ...
Setting up libexpat1-dev:amd64 (2.4.7-1ubuntu0.2) ...
Setting up libpython3.10-dev:amd64 (3.10.12-1~22.04.2) ...
Setting up python3.10-dev (3.10.12-1~22.04.2) ...
Setting up libjs-jquery (3.6.0+dfsg+~3.5.13-1) ...
Setting up python3-lib2to3 (3.10.8-1~22.04) ...
Setting up libjs-underscore (1.13.2~dfsg-2) ...
Setting up python3-distutils (3.10.8-1~22.04) ...
Setting up libpython3-dev:amd64 (3.10.6-1~22.04) ...
Setting up python3-setuptools (59.6.0-1.2ubuntu0.22.04.1) ...
Setting up python3-wheel (0.37.1-2ubuntu0.22.04.1) ...
Setting up python3-pip (22.0.2+dfsg-1ubuntu0.3) ...
Setting up libjs-sphinxdoc (4.3.2-1) ...
Setting up python3-dev (3.10.6-1~22.04) ...
Setting up modular (0.1.2) ...
Processing triggers for man-db (2.10.2-1) ...
  __  __           _       _
 |  \/  | ___   __| |_   _| | __ _ _ __
 | |\/| |/ _ \ / _` | | | | |/ _` | '__|
 | |  | | (_) | (_| | |_| | | (_| | |
 |_|  |_|\___/ \__,_|\__,_|_|\__,_|_|

Welcome to the Modular CLI!
For info about this tool, type "modular --help".

To install Mojo🔥, type "modular install mojo".

For Mojo documentation, see https://docs.modular.com/mojo.
To chat on Discord, visit https://discord.gg/modular.
To report issues, go to https://github.com/modularml/mojo/issues.
```

Now the `Modular` tool is installed:
```
ivo@megaverse:~$ modular --help
NAME
        modular — The Modular command line interface.

SYNOPSIS
        modular <command>
        modular [options]

DESCRIPTION
        Interact with Modular's products.

COMMANDS
        install   — Install a package.
        uninstall — Uninstall a package.
        auth      — Auth to the modular service.
        clean     — Clean all packages and settings.
        host-info — Get hardware information about host hardware.

OPTIONS
    Diagnostic options
        --version, -v
            Prints the Modular version and exits.

    Common options
        --help, -h
            Displays help information.

ivo@megaverse:~$ modular -v
modular 0.1.2
ivo@megaverse:~$ modular host-info
  Host Information
  ================

  Target Triple: x86_64-unknown-linux
  CPU: alderlake
  CPU Features: 64bit, adx, aes, avx, avx2, avxvnni, bmi, bmi2, cldemote, clflushopt, clwb, cmov, crc32, cx16, cx8, f16c, fma, fsgsbase, fxsr, gfni, hreset, invpcid, kl, lzcnt, mmx, movbe, movdir64b, movdiri, pclmul, pconfig, pku, popcnt, prfchw, ptwrite, rdpid, rdrnd, rdseed, sahf, serialize, sgx, sha, shstk, sse, sse2, sse3, sse4.1, sse4.2, ssse3, vaes, vpclmulqdq, waitpkg, widekl, x87, xsave, xsavec, xsaveopt, xsaves
```

4- Install the Mojo SDK:  
A. Via an installation script:

`modular install mojo`

Output:
```
# Found release for https://packages.modular.com/mojo @ 0.2.0, installing to /home/ivo/.modular/pkg/packages.modular.com_mojo
# Downloads complete, setting configs...
# Configs complete, running post-install hooks...
Defaulting to user installation because normal site-packages is not writeable
Collecting find_libpython==0.3.0
  Downloading find_libpython-0.3.0-py3-none-any.whl (8.5 kB)
Collecting papermill==2.4.0
  Downloading papermill-2.4.0-py3-none-any.whl (38 kB)
Collecting jupyter_client>=8.3.0
  Downloading jupyter_client-8.3.0-py3-none-any.whl (103 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 103.2/103.2 KB 3.2 MB/s eta 0:00:00
Collecting click
  Downloading click-8.1.7-py3-none-any.whl (97 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 97.9/97.9 KB 7.9 MB/s eta 0:00:00
Collecting nbclient>=0.2.0
  Downloading nbclient-0.8.0-py3-none-any.whl (73 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 73.1/73.1 KB 6.6 MB/s eta 0:00:00
Collecting tqdm>=4.32.2
  Downloading tqdm-4.66.1-py3-none-any.whl (78 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 78.3/78.3 KB 6.2 MB/s eta 0:00:00
Collecting tenacity
  Downloading tenacity-8.2.3-py3-none-any.whl (24 kB)
Collecting nbformat>=5.1.2
  Downloading nbformat-5.9.2-py3-none-any.whl (77 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 77.6/77.6 KB 5.8 MB/s eta 0:00:00
Requirement already satisfied: pyyaml in /usr/lib/python3/dist-packages (from papermill==2.4.0->-r /home/ivo/.modular/pkg/packages.modular.com_mojo/scripts/post-install/requirements.txt (line 2)) (5.4.1)
Collecting ansiwrap
  Downloading ansiwrap-0.8.4-py2.py3-none-any.whl (8.5 kB)
Collecting requests
  Downloading requests-2.31.0-py3-none-any.whl (62 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 62.6/62.6 KB 5.6 MB/s eta 0:00:00
Collecting entrypoints
  Downloading entrypoints-0.4-py3-none-any.whl (5.3 kB)
Collecting jupyter-core!=5.0.*,>=4.12
  Downloading jupyter_core-5.3.1-py3-none-any.whl (93 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 93.7/93.7 KB 6.3 MB/s eta 0:00:00
Collecting traitlets>=5.3
  Downloading traitlets-5.9.0-py3-none-any.whl (117 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 117.4/117.4 KB 7.2 MB/s eta 0:00:00
Collecting tornado>=6.2
  Downloading tornado-6.3.3-cp38-abi3-manylinux_2_5_x86_64.manylinux1_x86_64.manylinux_2_17_x86_64.manylinux2014_x86_64.whl (427 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 427.7/427.7 KB 9.4 MB/s eta 0:00:00
Collecting python-dateutil>=2.8.2
  Downloading python_dateutil-2.8.2-py2.py3-none-any.whl (247 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 247.7/247.7 KB 8.4 MB/s eta 0:00:00
Collecting pyzmq>=23.0
  Downloading pyzmq-25.1.1-cp310-cp310-manylinux_2_28_x86_64.whl (1.1 MB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 1.1/1.1 MB 10.2 MB/s eta 0:00:00
Collecting platformdirs>=2.5
  Downloading platformdirs-3.10.0-py3-none-any.whl (17 kB)
Collecting jsonschema>=2.6
  Downloading jsonschema-4.19.0-py3-none-any.whl (83 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 83.4/83.4 KB 6.5 MB/s eta 0:00:00
Collecting fastjsonschema
  Downloading fastjsonschema-2.18.0-py3-none-any.whl (23 kB)
Requirement already satisfied: six>=1.5 in /usr/lib/python3/dist-packages (from python-dateutil>=2.8.2->jupyter_client>=8.3.0->-r /home/ivo/.modular/pkg/packages.modular.com_mojo/scripts/post-install/requirements.txt (line 3)) (1.16.0)
Collecting textwrap3>=0.9.2
  Downloading textwrap3-0.9.2-py2.py3-none-any.whl (12 kB)
Collecting urllib3<3,>=1.21.1
  Downloading urllib3-2.0.4-py3-none-any.whl (123 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 123.9/123.9 KB 7.9 MB/s eta 0:00:00
Collecting charset-normalizer<4,>=2
  Downloading charset_normalizer-3.2.0-cp310-cp310-manylinux_2_17_x86_64.manylinux2014_x86_64.whl (201 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 201.8/201.8 KB 8.7 MB/s eta 0:00:00
Collecting certifi>=2017.4.17
  Downloading certifi-2023.7.22-py3-none-any.whl (158 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 158.3/158.3 KB 8.2 MB/s eta 0:00:00
Collecting idna<4,>=2.5
  Downloading idna-3.4-py3-none-any.whl (61 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 61.5/61.5 KB 4.7 MB/s eta 0:00:00
Collecting attrs>=22.2.0
  Downloading attrs-23.1.0-py3-none-any.whl (61 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 61.2/61.2 KB 5.0 MB/s eta 0:00:00
Collecting referencing>=0.28.4
  Downloading referencing-0.30.2-py3-none-any.whl (25 kB)
Collecting jsonschema-specifications>=2023.03.6
  Downloading jsonschema_specifications-2023.7.1-py3-none-any.whl (17 kB)
Collecting rpds-py>=0.7.1
  Downloading rpds_py-0.9.2-cp310-cp310-manylinux_2_17_x86_64.manylinux2014_x86_64.whl (1.2 MB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 1.2/1.2 MB 10.3 MB/s eta 0:00:00
Installing collected packages: textwrap3, find_libpython, fastjsonschema, urllib3, traitlets, tqdm, tornado, tenacity, rpds-py, pyzmq, python-dateutil, platformdirs, idna, entrypoints, click, charset-normalizer, certifi, attrs, ansiwrap, requests, referencing, jupyter-core, jupyter_client, jsonschema-specifications, jsonschema, nbformat, nbclient, papermill
  WARNING: The script find_libpython is installed in '/home/ivo/.local/bin' which is not on PATH.
  Consider adding this directory to PATH or, if you prefer to suppress this warning, use --no-warn-script-location.
  WARNING: The script tqdm is installed in '/home/ivo/.local/bin' which is not on PATH.
  Consider adding this directory to PATH or, if you prefer to suppress this warning, use --no-warn-script-location.
  WARNING: The script normalizer is installed in '/home/ivo/.local/bin' which is not on PATH.
  Consider adding this directory to PATH or, if you prefer to suppress this warning, use --no-warn-script-location.
  WARNING: The scripts jupyter, jupyter-migrate and jupyter-troubleshoot are installed in '/home/ivo/.local/bin' which is not on PATH.
  Consider adding this directory to PATH or, if you prefer to suppress this warning, use --no-warn-script-location.
  WARNING: The scripts jupyter-kernel, jupyter-kernelspec and jupyter-run are installed in '/home/ivo/.local/bin' which is not on PATH.
  Consider adding this directory to PATH or, if you prefer to suppress this warning, use --no-warn-script-location.
  WARNING: The script jsonschema is installed in '/home/ivo/.local/bin' which is not on PATH.
  Consider adding this directory to PATH or, if you prefer to suppress this warning, use --no-warn-script-location.
  WARNING: The script jupyter-trust is installed in '/home/ivo/.local/bin' which is not on PATH.
  Consider adding this directory to PATH or, if you prefer to suppress this warning, use --no-warn-script-location.
  WARNING: The script jupyter-execute is installed in '/home/ivo/.local/bin' which is not on PATH.
  Consider adding this directory to PATH or, if you prefer to suppress this warning, use --no-warn-script-location.
  WARNING: The script papermill is installed in '/home/ivo/.local/bin' which is not on PATH.
  Consider adding this directory to PATH or, if you prefer to suppress this warning, use --no-warn-script-location.
Successfully installed ansiwrap-0.8.4 attrs-23.1.0 certifi-2023.7.22 charset-normalizer-3.2.0 click-8.1.7 entrypoints-0.4 fastjsonschema-2.18.0 find_libpython-0.3.0 idna-3.4 jsonschema-4.19.0 jsonschema-specifications-2023.7.1 jupyter-core-5.3.1 jupyter_client-8.3.0 nbclient-0.8.0 nbformat-5.9.2 papermill-2.4.0 platformdirs-3.10.0 python-dateutil-2.8.2 pyzmq-25.1.1 referencing-0.30.2 requests-2.31.0 rpds-py-0.9.2 tenacity-8.2.3 textwrap3-0.9.2 tornado-6.3.3 tqdm-4.66.1 traitlets-5.9.0 urllib3-2.0.4
Testing `MODULAR_HOME=/home/ivo/.modular`
* `/home/ivo/.modular/pkg/packages.modular.com_mojo/bin/mojo`...
TEST: `mojo --help`... OK
TEST: `mojo run --help`... OK
TEST: `mojo build test_mandelbrot.mojo`... OK
TEST: `mojo build test_python.mojo`... OK
TEST: `mojo demangle`... OK
reformatted /tmp/tmpzyqvco3j/test_format.mojo

All done! ✨ 🍰 ✨
1 file reformatted.
TEST: `mojo format`... OK
TEST: `mojo package`... OK
TEST: `mojo test_mandelbrot.mojo`... OK
TEST: `mojo test_python.mojo`... OK
TEST: `mojo repl`... OK

🔥 Mojo installed! 🔥

Now run the following commands:

echo 'export MODULAR_HOME="/home/ivo/.modular"' >> ~/.bashrc
echo 'export PATH="/home/ivo/.modular/pkg/packages.modular.com_mojo/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

Then enter 'mojo' to start the Mojo REPL.

For tool help, enter 'mojo --help'.
For more docs, see https://docs.modular.com/mojo.
```

Now Mojo (the mojo tool, the lsp-server, an lldb tool, a crashpad handler) is installed in `/home/ivo/.modular/pkg/packages.modular.com_mojo/bin/mojo`

`/home/ivo/.modular/pkg/packages.modular.com_mojo/lib/mojo` contains the pre-compiles Mojo packages.

An environment variable `MODULAR_HOME=/home/ivo/.modular` was made.
To update the PATH variable, enter the following commands:
```
echo 'export MODULAR_HOME="/home/ivo/.modular"' >> ~/.bashrc
echo 'export PATH="/home/ivo/.modular/pkg/packages.modular.com_mojo/bin:$PATH"' >> ~/.bashrc
echo 'export PATH="/home/ivo/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

Getting help:
$ mojo --help
NAME
        mojo — The Mojo🔥 command line interface.

SYNOPSIS
        mojo <command>
        mojo [run-options] <path>
        mojo [options]
        mojo

DESCRIPTION
        The `mojo` CLI provides all the tools you need for Mojo development, such
        as commands to run, compile, and package Mojo code. A list of all
        commands are listed below, and you can learn more about each one by
        adding the `--help` option to the command (for example, `mojo package
        --help`).

        However, you may omit the `run` and `repl` commands. That is, you can run
        a Mojo file by simply passing the filename to `mojo`:

            mojo hello.mojo

        And you can start a REPL session by running `mojo` with no commands.

COMMANDS
        run      — Builds and executes a Mojo file.
        build    — Builds an executable from a Mojo file.
        repl     — Launches the Mojo REPL.
        package  — Compiles a Mojo package.
        format   — Formats Mojo source files.
        doc      — Compiles docstrings from a Mojo file.
        demangle — Demangles the given name.

OPTIONS
    Diagnostic options
        --version, -v
            Prints the Mojo version and exits.

    Common options
        --help, -h
            Displays help information.

$ mojo -v
mojo 0.2.0 (4c0ef274)

**Info about debug options**
$ mojo build -h

This gives the following output:  
```
$ mojo build -h
NAME
        mojo-build — Builds an executable from a Mojo file.

SYNOPSIS
        mojo build [options] <path>

DESCRIPTION
        Compiles the Mojo file at the given path into an executable.

        By default, the executable is saved to the current directory and named
        the same as the input file, but without a file extension.

OPTIONS
    Output options
        -o <PATH>
            Sets the path and filename for the executable output. By default, it
            outputs the executable to the same location as the Mojo file, with
            the same name and no extension.

    Compilation options
        --no-optimization, -O0
            Disables compiler optimizations. This might reduce the amount of time
            it takes to compile the Mojo source file. It might also reduce the
            runtime performance of the compiled executable.

        --target-triple <TRIPLE>
            Sets the compilation target triple. Defaults to the host target.

        --target-cpu <CPU>
            Sets the compilation target CPU. Defaults to the host CPU.

        --target-features <FEATURES>
            Sets the compilation target CPU features. Defaults to the host
            features.

        -march <ARCHITECTURE>
            Sets the architecture to generate code for.
        -mcpu <CPU>
            Sets the CPU to generate code for.

        -mtune <TUNE>
            Sets the CPU to tune code for.

        -I <PATH>
            Appends the given path to the list of directories to search for
            imported Mojo files.

        -D <KEY=VALUE>
            Defines a named value that can be used from within the Mojo source
            file being executed. For example, `-D foo=42` defines a name `foo`
            that, when queried with the `ParamEnv` module from within the Mojo
            program, would yield the compile-time value `42`.

        --parsing-stdlib
            Parses the input file(s) as the Mojo standard library.

    Diagnostic options
        --warn-missing-doc-strings
            Emits warnings for missing or partial docstrings.

        --max-notes-per-diagnostic <INTEGER>
            When the Mojo compiler emits diagnostics, it sometimes also prints
            notes with additional information. This option sets an upper
            threshold on the number of notes that can be printed with a
            diagnostic. If not specified, the default maximum is 10.

    Experimental compilation options
        --debug-level <LEVEL>
            Sets the level of debug info to use at compilation. The value must be
            one of: `none` (the default value), `line-tables`, or `full`. Please
            note that there are issues when generating debug info for some Mojo
            programs that have yet to be addressed.

        --sanitize <CHECK>
            Turns on runtime checks. The following values are supported:
            `address` (detects memory issues), and `thread` (detects
            multi-threading issues). Please note that these checks are not
            currently supported when executing Mojo programs.

    Common options
        --help, -h
            Displays help information.



**Starting the Mojo REPL**  
```
$ mojo
Welcome to Mojo! 🔥
Expressions are delimited by a blank line.
Type `:mojo help` for further assistance.
1> let n = 3
2. print(n)
3.
3
(Int) n = {
  (index) value = 3
}
3>
```

If you want to run Python code, use %%python:  
```
1> %%python
2. import sys
3. print("Python version from python:", sys.version)
4.
Python version from python: 3.10.12 (main, Jun 11 2023, 05:26:28) [GCC 11.4.0]
(PythonObject) sys = {
  (PyObjectPtr) py_object = {
    (pointer<scalar<si8>>) value = 0x00007fd70b6c6390
  }
}
```

Top-level python declarations are available in subsequent Mojo expressions (example ??).

The Mojo REPL is based on LLDB, the complete set of LLDB debugging commands is also available as described below (?? examples).  
Type :quit to leave the REPL.

**Testing the CLI mojo command**  
Create folder $HOME/mojo.  
Copy in examples from § 2.

$ mojo hello_world.mojo
Hello World from Mojo!
$ mojo hello_world.🔥
Hello World from Mojo!
$ $ mojo using_main.mojo
Hello Mojo!
2

B. Manual installation instructions:
(Ubuntu 16.04 and later)  

Open a terminal, as root give the command:
```
apt-get install -y apt-transport-https
  keyring_location=/usr/share/keyrings/modular-installer-archive-keyring.gpg
  curl -1sLf 'https://dl.modular.com/bBNWiLZX5igwHXeu/installer/gpg.0E4925737A3895AD.key' |  gpg --dearmor >> ${keyring_location}
  curl -1sLf 'https://dl.modular.com/bBNWiLZX5igwHXeu/installer/config.deb.txt?distro=debian&codename=wheezy' > /etc/apt/sources.list.d/modular-installer.list
  apt-get update
  apt-get install modular
```

If the package has been installed manually, you will need to do the auth manually as well, e.g.:
```
modular auth mut_e793ec8f3c514c5c9e794607eec73c84
modular install mojo
```

**Some info on WSL**  
You can view Linux folders in Explorer by giving the following command in WSL: `explorer.exe .`
When having trouble starting a remote WSL window in VSCode, uninstall and reinstall the Remote WSL Window extension in VSCode; restart VSCode.
When the WSL terminal doesn’t start up, disable Windows Hypervisor in Windows Features, reboot, enable Windows Hypervisor in Windows Features , reboot.
(Alternatively, you can do wsl --terminate and wsl --update)   
See also: [Troubleshooting Windows Subsystem for Linux | Microsoft Docs](https://learn.microsoft.com/en-us/windows/wsl/troubleshooting)

**How to update the installation**
1- Execute the command:         `modular clean`
2- Then do a fresh install:     `modular install mojo`
displaying:
```
# Found release for https://packages.modular.com/mojo @ 0.2.1, installing to /home/ivo/.modular/pkg/packages.modular.com_mojo
# ...
```

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

## 2.7.0 A vim plugin
See https://github.com/czheo/mojo.vim for Mojo syntax highlighting.

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

A Mojo kernel then runs a Jupyter notebook in a server at `/user/<your_email>/`

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

The *official plugin* for Mojo is called [modular-mojotools.vscode-mojo](https://marketplace.visualstudio.com/items?itemName=modular-mojotools.vscode-mojo). It features (v 0.2.0):
* Syntax highlighting for .mojo and .🔥 files
* Code completion
* Code diagnostics and quick fixes
* API docs on hover

Another unofficial plugin is here:
 (mojo-lang) [here](https://marketplace.visualstudio.com/items?itemName=mojo-lang.mojo-lang&ssr=false#review-details) which is at v0.1.0 and provides syntax-highlighting. Later a LS (Language Server) will be added.

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

Now F1 + select "Run Custom Command" or "CTRL+ALT+N" compiles and executes the source code in the editor. This is most easily used by clicking the RIGHT mouse button, and selecting the first option "Run Code".
See [screenshot](https://github.com/Ivo-Balbaert/The_Way_to_Mojo/blob/main/images/Using_Mojo_in_VSCode.png).


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


The first is the usual "Hello World!" program, which is in Mojo exactly the same as in Python, because Mojo is a superset of Python:

See `hello_world.mojo`:
```py
fn main():
    print("Hello World from Mojo!") # => Hello World! from Mojo
```

In a source file however we have to use a starting point function called `main()` (see § 3.1).

>Note: Don't forget the () after main, and also the () containing the value to print out after print!

To compile and run this source code, use the command: 
`mojo hello_world.mojo` or `mojo hello_world.🔥`.
Then the console displays: `Hello World! from Mojo`.

To show the output of statements in code sections, we'll show them in a comment that starts with `# =>`.

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

