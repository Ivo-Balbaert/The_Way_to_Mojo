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

# 3 Starting to program
## 3.1 Some preliminary remarks
## 3.2 Comments and Doc comments
## 3.2.1 Normal comments with #
## 3.2.2 Doc comments with """
## 3.3 The main function
## 3.3.1 The main function is necessary
## 3.3.2 print and print_no_newline
## 3.3.3 Building a Mojo source file
## 3.4  Variables and types - def and fn
## 3.5  Typing in Mojo
## 3.6 Importing modules
## 3.6.1 Mojo modules
## 3.6.2 Python modules

# 4 Basic types
## 4.1 The Bool type
## 4.2 The numerical types
### 4.2.1 The Integer type
### 4.2.2 The FloatLiteral type and conversions
## 4.2.3 Random numbers
## 4.3 The String types
### 4.3.1 The StringLiteral type
### 4.3.2 The String type
### 4.3.3 The StringRef type
### 4.3.4 Some String methods
## 4.4 Defining alias types
## 4.5 Sorting a DynamicVector

# 5 Control flow
## 5.1 if else and Bool values
## 5.2 Using for loops
## 5.3 Using while loops
## 5.4 Catching exceptions with try-except-finally

# 6 Functions
## 6.1 Difference between fn and def
## 6.2  A fn that calls a def needs a try/except
## 6.3 Function arguments and return type
## 6.4 Argument passing: control and memory ownership
### 6.4.1 General rules for def and fn arguments
### 6.4.2 Making arguments changeable with inout 
### 6.4.2 Making arguments owned
### 6.4.3 Making arguments owned and transferred with ^
## 6.5 Closures

# 7 Structs
## 7.1 First example
## 7.2 Comparing a FloatLiteral and a Bool
## 7.3 A second example
## 7.4 Overloading
### 7.4.1 Overloaded functions and methods
### 7.4.2 Overloaded operators
## 7.5 The __copyinit__ and __moveinit__ special methods
## 7.6 Using a large struct instance as function argument
## 7.7 Using inout with structs
## 7.8 Transfer struct arguments with owned and ^
# 7.9 Compile-time metaprogramming in Mojo
## 7.9.1 Parametric types in structs and functions
## 7.9.2 Parametric structs
## 7.9.3 Improving performance with the SIMD struct
## 7.9.4 How to create a custom parametric type: Array
## 7.9.5 Parametric functions and methods
# 7.10 Lifetimes
## 7.10.1 Types that cannot be instantiated
## 7.10.2 Non-movable and non-copyable types

# 8 Python integration
## 8.0 Comparing the same program in Python and Mojo
## 8.1 Running Python code
## 8.2 Running Python code in the interpreter mode or in the Mojo mode
## 8.3 Working with Python modules
### 8.3.2 How to do an HTTP-request from Python?
## 8.4 Importing local Python modules
## 8.5 Mojo types in Python

# 9 - Other built-in types
## 9.1 The ListLiteral type
## 9.2 The Tuple type
## 9.3 The slice type
## 9.4 The Error type

# 10 Standard library examples
## 10.1 Assert statements
### 10.1.1 constrained
### 10.1.2 debug_assert
?? ## 10.2 Module testing 
## 10.3 Module benchmark
## 10.4 Type Buffer from module memory.buffer
## 10.5 Type NDBuffer from module memory.buffer
## 10.6 Querying the host target info with module sys.info
## 10.7 The time module
## 10.8 Vectors from the module utils.vector
## 10.8.1 DynamicVector
## 10.8.2 InlinedFixedVector
## 10.8.3 UnsafeFixedVector
## 10.9 Working with command-line arguments

# 11 – Decorators
## 11.1 - @value
## 11.2 - @register_passable
## 11.3 - @parameter if
## 11.4 - @parameter 
## 11.5 - @staticmethod
## 11.6 - @always_inline
## 11.7 - @noncapturing

# 12 – Working with Pointers
## 12.1 - What is a pointer?
## 12.2 - Defining and using pointers
## 12.3 - Writing safe pointer code
## 12.4 - Working with DTypePointers

# 13 Modules and packages
## 13.1 What are modules and packages?
## 13.2 Importing a local Mojo module
## 13.3 Importing a local Mojo package
## 13.3.1 Importing the package as source code
## 13.3.2 Compiling the package to a package file
## 13.3.3 The __init__ file

# 20 – Projects
## 20.1 - Calculating the sum of two vectors
## 20.2 - Calculating the Euclidean distance between two vectors

