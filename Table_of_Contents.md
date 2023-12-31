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
## 2.6  Mojo configuration file
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
### 4.4.1 Usage of alias
### 4.4.2 Defining an enum type using alias
## 4.5 The object type

# 5 Control flow
## 5.1 if else and Bool values
## 5.2 Using for loops
## 5.3 Using while loops
## 5.4 Catching exceptions with try-except-finally
## 5.5 The with statement
## 5.6 The walrus operator :=
## 5.7 Exiting from a program

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
## 6.6 Functions with a variable number of arguments.
## 6.7 Function types
## 6.8 Running a function at compile-time and run-time
## 6.9 Callbacks through parameters

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
### 7.9.3.1 Defining a vector with SIMD
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

# 9 Other built-in types
## 9.1 The ListLiteral type
## 9.2 The Tuple type
## 9.3 The slice type
## 9.4 The Error type


# 10 Standard library examples
## 10.1 Assert statements
### 10.1.1 constrained
### 10.1.2 debug_assert
## 10.2 Module testing 
## 10.3 Module benchmark
## 10.4 Type Buffer from module memory.buffer
## 10.5 Type NDBuffer from module memory.buffer
## 10.6 Querying the host target info with module sys.info
## 10.7 The time module
## 10.8 Vectors from the module utils.vector
### 10.8.1 DynamicVector
### 10.8.2 InlinedFixedVector
### 10.8.3 UnsafeFixedVector
## 10.9 The Tensor type from module tensor
## 10.10 Working with command-line arguments
## 10.11 Working with memory
## 10.12 Working with files
## 10.13 The module sys.param_env

# 11 – Decorators
## 11.1 - @value
## 11.2 - @register_passable
## 11.3 - @parameter if
## 11.4 - @parameter 
## 11.5 - @staticmethod
## 11.6 - @always_inline
## 11.7 - @noncapturing
## 11.8 - @unroll

# 12 – Working with Pointers
## 12.1 - What is a pointer?
## 12.2 - Defining and using pointers
## 12.3 - Writing safe pointer code
## 12.4 - Working with DTypePointers
## 12.5 Sorting with pointers
### 12.5.1 Sorting with Bubblesort

# 13 Modules and packages
## 13.1 What are modules and packages?
## 13.2 Importing a local Mojo module
## 13.3 Importing a local Mojo package
## 13.3.1 Importing the package as source code
## 13.3.2 Compiling the package to a package file
## 13.3.3 The __init__ file

# 14 MLIR - The basis of Mojo
## 14.1 What is MLIR?
## 14.2 Defining a bool type with MLIR
## 14.3 Defining an integer with MLIR
## 14.4 Copying data with raw pointers
## 14.5 Calling gmtime from C
## 14.6 Custom bitwidth integers

# 15 - Parallellization
# 15.1 - The parallellize function
## 15.1.1 No SIMD example
## 15.1.2 With SIMD
# 15.2 - async/await in Mojo
# 15.3  Parallelization applied to row-wise mean() of a vector
### 15.3.1 Using a function
### 15.3.2 Using a custom struct based on Tensor type

# 16 - Vectorization
# 16.1 - 
## 16.1.1 Vectorize SIMD cosine

# 17 - Foreign Function Interface (FFI)
# 17.1 - Mojo and C 
## 17.1.1 Linking to functions of the C standard library
### 17.1.1.1 Mojo calls C via external_call
### 17.1.1.2 Mojo calls C via a function pointer


# 20 – Projects
## 20.1 - Calculating the sum of two vectors
### 20.1.1 - A naive Python implementation
### 20.1.2 - Using Numpy
### 20.1.3 - A Mojo version of the naive Python implementation
### 20.1.4 - Using SIMD and vectorize
## 20.2 - Calculating the Euclidean distance between two vectors
## 20.3 - Matrix multiplication (matmul)
### 20.3.1 - Naive Python implementation
### 20.3.2 - Importing the Python implementation to Mojo
### 20.3.3 - Adding types to the implementation
### 20.3.4 - Vectorizing the inner most loop
#### 20.3.4.1 - Vectorizing the inner most loop
#### 20.3.4.2 - Using the Mojo vectorize function
### 20.3.5 - Parallelizing Matmul
### 20.3.6 - Tiling Matmul
### 20.3.7 - Unrolling the loops introduced by vectorize of the dot function
### 20.3.8 - Searching for the tile_factor
## 20.4 - Sudoku solver
## 20.5 - Computing the Mandelbrot set
### 20.5.1 The pure Python algorithm
### 20.5.2 Adding types in the funtion signature
### 20.5.3 Changing to an fn function
### 20.5.4 Simplifying the math to reduce computation
### 20.5.5 Adding supporting code
### 20.5.6 - Vectorizing the code
### 20.5.7 - Parallelizing the code
## 20.7 - Working with files
## 20.8 - Calculating PI
## 20.9 - Timing a for loop