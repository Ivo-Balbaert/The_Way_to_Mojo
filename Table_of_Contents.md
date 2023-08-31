# TABLE OF CONTENTS

# 1 – What is Mojo?
## 1.1 Write everything in one language
## 1.2 Targets and Characteristics of the language
### 1.2.1 A Fast language
### 1.2.2 A Scalable language
### 1.2.3 An Accelerated language
## 1.3 Use cases of the language
## 1.4 Languages that influenced Mojo
**Interop with other languages and migration strategy** 
**Interaction with C/C++** 
## 1.5 Summary 

# 1B – General info about Mojo
## 1B.1 Some info about the name and logo.
## 1B.2 Website, community and communication channels
## 1B.3 A brief history, status and roadmap 
## 1B.4 Popularity
## 1B.5 Business and support model
## 1B.6 Some one-liners

# 2 - Setting up a development environment
## 2.1 Architectures and compilers
**Target OS’s and platforms**  
**Compiler**  
**Standard library**   
## 2.2 Using a Mojo binary release
### 2.2.1 On Windows
### 2.2.2 On Linux (or WSL2 on Windows)
**Some info on WSL**  
### 2.2.3 On MacOS
## 2.3 Testing the installation - Mojo's option flags
## 2.4 How to install Mojo platform dependencies
## 2.5 Building Mojo from source
### 2.5.1 Downloading the Mojo source code
### 2.5.2  Building Mojo
## 2.6  Running the Mojo test suite
## 2.7  Editors
## 2.7.1 The Mojo online playground
**To get entrance:**  
**Alternative way:**   
### 2.7.2 Visual Studio Code (VS Code)
#### 2.7.2.1 An easy way to execute code 
#### 2.7.2.2 How to work with a Jupyter notebook in VS Code 
**Here are the steps:**     
**Tips and Troubleshooting:**    
#### 2.7.2.3 Compiling and executing a simple program

# 3 Basic building blocks
## 3.1 The main function, def and fn, variables and types
## 3.2 Function arguments and return type
## 3.3 Can a function change its arguments?
## 3.3.1 inout
## 3.3.2 owned
## 3.3.3 owned and transferred with ^

## 3.4 Structs

## 3.5 Python integration
### 3.5.1 Running Python code
### 3.5.3 Working with Python modules
### 3.5.4 Running Python code in the interpreter mode or in the Mojo mode

## 3.6 if else and Bool values
## 3.7 Basic types
## 3.7.1 Scalar values
### 3.7.1.2 The Bool type
### 3.7.1.3 The numeric types
### 3.7.1.3 The String types
## 3.8 Using for loops

## 3.9 Improving performance with SIMD
## 3.10 The ListLiteral type
## 3.11 The Tuple type
## 3.12 The Slice type

## 3.13 Overloaded functions and methods


Many types are defines as structs
Parametric types / functions
        SIMD
AnyType
None : when a function returns nothing
    def main():, without the explicit None type, can now be used to define the entry point to a Mojo program.

object

%%python
import numpy as np
from timeit import timeit

from .. import .. as

variadic *T  : a variable number of values of type T

alias declaration: a way to define a compile-time temporary value.
    alias UInt8 = SIMD[DType.uint8, 1]
    var n : UInt8 

    both None and AnyType are defined as type aliases.

struct Matrix in Matmul:
    __init__ and __del__ as destructor





