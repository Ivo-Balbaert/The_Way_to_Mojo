# 1 – What is Mojo?
## 1.1 Write everything in one language
## 1.2 The super powers of Mojo
### 1.2.1 A Fast language
### 1.2.2 A Scalable language
### 1.2.3 An Accelerated language
## 1.3 Use cases of the language
## 1.4 Languages that influenced Mojo
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
### 2.1.1 Target OS's and platforms
### 2.1.2 Compiler
### 2.1.3 Runtime
### 2.1.4 Standard library
## 2.2 Installing the Modular and Mojo toolkit
### 2.2.1 On Windows
### 2.2.2 On MacOS 
### 2.2.3 On Linux Ubuntu 20-22 (or WSL2 on Windows)
## 2.3 Starting the Mojo REPL
## 2.4 Testing the mojo command
## 2.5 Some info on WSL
## 2.6 How to update Modular and Mojo
## 2.7 How to remove Mojo
## 2.8 Downloading the Mojo source code
## 2.9 The Mojo configuration file
## 2.10  Editors
### 2.10.1 A vim plugin
### 2.10.2 Working with a Jupyter notebook
### 2.10.3 Visual Studio Code (VS Code)
### 2.10.4 How to work with a Jupyter notebook locally in VS Code 
### 2.10.5 Using a Docker file (?? updating)
### 2.10.6 PyCharm plugin
## 2.11 Compiling and executing a simple program

# 3 Starting to program
## 3.1 Some preliminary remarks
## 3.2 Comments and Doc comments
## 3.2.1 Normal comments with #
## 3.2.2 Doc comments with """
## 3.3 The main function
## 3.4 The print function
## 3.5 Using assert_equal
## 3.6 Building a Mojo source file
## 3.7 Compile-time and runtime
## 3.8 Variables, types and addresses
### 3.8.1 Using def and fn
### 3.8.2 Late initialization
### 3.8.3 Name shadowing
### 3.8.4 Global variables
### 3.8.5 Variable addresses
## 3.9  Typing in Mojo

# 4 Basic types
## 4.1 The data type DType
## 4.2 The Bool type
## 4.3 Numerical types
### 4.3.1 The Integer types
#### 4.3.1.1 Using Ints as indexes
#### 4.3.1.2 Converting integers
#### 4.3.1.3 Converting Bool to Int
#### 4.3.1.4 Handling big integers
### 4.3.2 The Float types
#### 4.3.2.1 Declarations and conversions
#### 4.3.2.2 The i (in-place) operations
#### 4.3.2.3 The r (right hand side or rhs) operations
#### 4.3.2.4 Comparing a FloatLiteral and a Bool
## 4.4 SIMD
### 4.4.1 Defining SIMD vectors
### 4.4.2 SIMD system properties
### 4.4.3 Using element type and group size as compile-time constants
### 4.4.4  Splat, join and cast
## 4.5 The String types
### 4.5.1 The StringLiteral type
#### 4.5.1.1 Converting a StringLiteral to an integer
### 4.5.2 The String type
### 4.5.3 The StringRef type
### 4.5.4 Some String methods
## 4.6 Defining constants and types with alias types
### 4.6.1 Using alias
### 4.6.2 Defining an enum type using alias
## 4.7 The object type
## 4.8 Special types
### 4.8.1 Register-passable types
### 4.8.2 Trivial types
### 4.8.3 Memory-only types
### 4.8.4 AnyType and AnyRegType
### 4.8.5 NoneType

# 5 Control flow
## 5.1 Code blocks
## 5.2 if else and Bool values
### 5.2.1 The walrus operator :=
## 5.2 Using for loops
## 5.3 Using while loops
## 5.4 Catching exceptions with try-except-finally
## 5.5 The with statement
## 5.6 Exiting from a program

# 6 Functions
## 6.1 Difference between fn and def
## 6.2 An fn that calls a def needs the raises keyword
## 6.3 Function arguments and return type
### 6.3.1 Function type
### 6.3.2 Optional arguments
### 6.3.3 Keyword arguments
### 6.3.4 Positional-only arguments
### 6.3.5 Keyword-only arguments
## 6.4 Functions with a variable number of arguments.
### 6.4.1 Using variadic arguments
### 6.4.2 Homogeneous variadic arguments
### 6.4.3 Heterogeneous variadic arguments
### 6.4.4 Variadic keyword arguments
### 6.4.5 Variadic argument followed by a keyword argument
## 6.5 Argument passing: control and memory ownership
### 6.5.1 General rules for def and fn arguments
### 6.5.2 Making arguments changeable with inout 
### 6.5.3 Making arguments owned
### 6.5.4 Making arguments owned and transferred with ^
## 6.6 Overloading functions
## 6.7 Running a function at compile-time and run-time
## 6.8 Closures
### 6.8.1 Example of a closure
### 6.8.2 Example of a capturing closure
## 6.9 Callbacks through parameters

# 7 Structs
## 7.1 First example
## 7.3 A second example <-- 7.2>
## 7.4 Overloading of methods
### 7.4.1 Overloaded methods
### 7.4.2 Overloaded operators
## 7.5 The __copyinit__ and __moveinit__ special methods
## 7.6 Using a large struct instance as function argument
## 7.7 Using inout with structs
## 7.8 Transfer struct arguments with owned and ^
## 7.9 Compile-time metaprogramming in Mojo
### 7.9.1 Parametric types in structs and functions
### 7.9.2 Parametric structs   
### 7.9.3 How to create a custom parametric type: Array
### 7.9.4 Parametric functions and methods
### 7.9.5 Programming compile-time logic
## 7.10 Static methods
## 7.11 Lifetimes
### 7.11.1 Types that cannot be instantiated
### 7.11.2 Non-movable and non-copyable types

# 8 Python integration
## 8.1 Comparing the same program in Python and Mojo
## 8.2 Running Python code in Mojo
## 8.3 Running Python code in the interpreter mode or in the Mojo mode
## 8.4 Working with Python 
### 8.4.1 Importing Python modules
#### 8.4.1.1 Testing that the Python module is available
#### 8.4.1.2 Using numpy
#### 8.4.1.3 Making plots with matplotlib
#### 8.4.1.4 How to do an HTTP-request from Python
### 8.4.2 Working with Python objects
#### 8.4.2.1 How to work with big integers in Mojo
#### 8.4.2.2 Using Pythonobjects for floats and strings
#### 8.4.2.3 Using numpy and matplotlib together
#### 8.4.2.4 Combining numpy and SIMD
## 8.5 Importing local Python modules
# 8.6 Installing Python for interaction with Mojo

# 9 - Collection types
## 9.1 List
### 9.1.1 ListLiteral
### 9.1.2 VariadicList
### 9.1.3 DimList
### 9.1.4 List
### 9.1.5 Implementing a list-like behavior with PythonObject
### 9.1.6  Sorting a List
## 9.2 Dict
## 9.3 Set
## 9.4 Optional
## 9.5 Tuple 
## 9.6 Variant 
## 9.7 InlinedFixedVector 
## 9.8 Slice
## 9.9 Buffer 
## 9.10 NDBuffer
## 9.11 The Tensor type from module tensor

# 10 Errors - Testing - Debugging - Benchmarking
## 10.1 The Error type
## 10.2 Querying the host target
## 10.3 Module testing 
## 10.4 Other assert statements
### 10.4.1 constrained
### 10.4.2 debug_assert
## 10.5 The time module
## 10.6 Module benchmark
## 10.7 Debugging in VSCode

# 11 Memory and Input/Output
## 11.1 Working with command-line arguments
## 11.2 Working with memory
## 11.3 The module sys.param_env
## 11.4 Working with files

# 12 – Working with Pointers
## 12.1 - What is a pointer?
## 12.2 - Defining and using pointers
## 12.3 - Writing safe pointer code
## 12.4 - Working with DTypePointers
## 12.5 Random numbers

# 13 Traits
## 13.1 What are traits?
## 13.2 Common traits
### 13.2.1 Stringable
### 13.2.2 Boolable
### 13.2.3 CollectionElement
### 13.2.4 KeyElement

# 14 Modules and packages
## 14.1 Importing standard-library modules 
### 14.1.1 Mojo modules
### 14.1.2 Python modules
## 14.2 What are modules and packages?
## 14.3 Importing a local Mojo module
## 14.4 Importing a local Mojo package
### 14.4.1 Importing the package as source code
### 14.4.2 Compiling the package to a package file
### 14.4.3 Using the __init__ file to simplify import

# 15 – Decorators
## 15.1 - @value
## 15.2 - @register_passable
## 15.3 - @parameter if
## 15.4 - @parameter runs a function at compile-time
## 15.5 - @staticmethod
## 15.6 - @always_inline
## 15.7 - @unroll

# 22 MLIR - The basis of Mojo
## 22.1 Mojo is built on top of MLIR
## 22.2 What is MLIR?
## 22.3 Defining a bool type with MLIR
## 22.4 Copying data with raw pointers
## 22.5 Calling gmtime from C
## 22.6 Custom bitwidth integers

# 23 - Vectorization
## 23.1 Vectorize SIMD cosine
## 23.2 - Using vectorization with Tensor

