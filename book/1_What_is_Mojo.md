# 1 – What is Mojo?
Mojo is a new general purpose programming language*, with an initial focus on AI applications. Over time, the whole spectrum of general-purpose programming will be covered.
It is the first language which is based on the [MLIR compiler infrastructure](https://mlir.llvm.org/), so it can run on all hardware.

It combines the usability of Python with the performance of C++/C and the safety of Rust.

It uses the *Python syntax* model: it already can run a lot of Python code. It will eventually become a *superset of Python*, able to execute all existing Python code, as well as specific Mojo code.
    Why?   
    - Because Python is one of the (if not the) most popular language(s) (2023 Aug: the number one language in the [Tiobe index](https://www.tiobe.com/tiobe-index/), and it was the Tiobe top language in 2020-21).  
    - Because Python is the number one language used in machine learning and AI projects.   

## 1.1 Write everything in one language
Mojo aims to to solve the three-language problem in current AI-research and industry. 

* Data scientists and AI-ML researchers want to model in Python, because Python makes prototyping and modelling easy. But when an AI project goes into production, Python often can't deliver the necessary performance.
* For that reason, product engineers want to deploy an AI project in a low-level language. This often entails rewriting large parts of the project in C++.
* To get access to GPU's and other accelerators, often parts of the model have to be rewritten in CUDA, or accelerator languages required for CPUs, GPUs, TPUs, and so on, which are even lower-level.

Mojo is created to solve this problem:
* It has the usability and intuitiveness of Python for model development, adding meta-programming features, like a truly high-level language. The entire Python ecosystem is made available to Mojo through CPython. 
* It has the performance and system programming capabilities of a low-level language like C++ or Rust.
* MLIR removes the necessity to use CUDA at the lowest level.

This will lead to accelerated development and production-use of AI technologies.

## 1.2 Targets and Characteristics of the language
*Mojo is F(ast), - S(calable), A(ccelerated)*.  
Let's analyze each of these characteristics.

### 1.2.1 A Fast language
Mojo utilizes next-generation compiler technologies with integrated caching, multithreading, and cloud distribution technologies.
It compiles to *machine code* specific to the target platform. It uses the MLIR compiler toolchain (which is itself based on LLVM) to achieve that. That way it harnesses all of LLVM/MLIR execution speed optimizations, and through MLIR, which talks to all exotic hardware platforms, it can unlock the performance potential of modern hardware.  
By progressively using types in code, performance can be enhanced.

" - Autotuning: With autotuning, Mojo can automatically find the best values for your parameters, which can drastically streamline the programming process  

- Tiling optimization: Mojo includes a built-in tiling optimization tool that effectively caches and reuses data, which helps optimize performance by using memory located near each other at a given time and reusing it.  

- Parallel computing: Mojo introduces inbuilt parallelization, enabling multithreaded code execution, which can increase execution speed by 2,000x."

- Mojo has no GC (garbage collection), so it doesn't suffer from GC pauses, and can be used in real-time domains. Instead, it has *automatic memory management*: it implements ownership and borrow-checking and lifetime concepts similar to Rust, simplifying the syntax.  
It also offers control over memory storage: struct field values are inline-allocated values.

- Mojo also doesn't suffer from Python's GIL (Global Interpreter Lock), so it can put to use multiple threads and concurrency much better.

**Benchmarks**
- Early benchmark comparisons show that Mojo has the performance level of C/C++ (or faster) and Rust:
![benchmark comparisons](https://github.com/Ivo-Balbaert/The_Way_to_Mojo/blob/main/images/performance.png) 
It easily beats Python performance with 4 orders of magnitude.
It uses the whole range of possibilities offered by modern compiler optimizations, including automatic parallel processing across multiple cores. This is nicely illustrated in the section starting at 33:08 by Jeremy Howard of the [Keynote speech](https://www.youtube.com/watch?v=-3Kf2ZZU-dg) which announced Mojo to the world.

### 1.2.2 A Scalable language
Starting with writing code like Python, you can scale all the way down to the metal and enabling you to program the multitude of low-level AI hardware. 
You can program the multitude of low-level AI hardware thanks to Mojo's MLIR foundation. Because of its LLVM fundament, it targets a wide diversity of OS platforms. MLIR itself has great adaptability to new kinds of hardware stacks and allows Mojo to scale to new exotic hardware types and domains.

Conclusion: Mojo can run almost everywhere.

A Mojo project compiles to a single executable: this makes for easy deployment, just copy the executable to the target machine and run it.

### 1.2.3 An Accelerated language
Mojo has been specifically designed to run AI-projects on diverse hardware, for example: GPUs for running CUDA, TCPU's, xCPUS's and so on.

Mojo is also *safe and reliable* because of:   
* It has a statically typed (AOT - ahead of time) compilation. Mojo prefers compile-time errors to runtime errors, because solving bugs at runtime is so much more painful (as developers in dynamic languages like Python and Ruby know well): this gives developers more confidence in their codebase.

* Its automatic memory management prevents memory errors (segfaults) and memory-leakage, a common cause for bugs in C++ applications.

[Note on MLIR]
MLIR stands for "Multi-Level Intermediate Representation".
(https://llvm.org/devmtg/2020-09/slides/MLIR_Tutorial.pdf)

## 1.3 Use cases of the language
Mojo is designed in the first place for AI development (?? elaborate). But it is also a general purpose language, suitable for building high-quality servers, CLI's (command-line applications), graphical native desktop UI's (user interfaces), database extensions, editor plugins, robotics, embedded applications, and so on.  
It is used to develop AI algorithms and can also be used for other tasks like high-performance computing (HPC), data transformations, writing pre/post-processing operations, and more.
As a kind of *Python++*, Mojo could serve the whole software industry.

## 1.4 Languages that influenced Mojo
Mojo belongs to the Python dynamic languages family (Python, CPython, Numpy, PyPy, and so on).  
It is a direct descendant of Python, but extends its use greatly. Mojo picks up where Python stops, helping in use cases that are out of Python's scope, mostly high-performance applications.  
It also builds on Rust, Swift, ??

**Interop with other languages and migration strategy**  
Mojo code can be mixed with Python. It can also call all Python libraries from its vast ecosystem, which are executed through the CPython interpreter, which talks to Mojo. This gives you a way to incrementally transition a legacy code base from Python to Mojo, making migration of Python easy.

The Mojo runtime also has a built-in GC to clean up Python objects, based on reference counting.

**Interaction with C/C++:**
It is on the roadmap.  Currently, you can use Python's C++ interop libraries like ctypes (https://docs.python.org/3/library/ctypes.html) or Cython (https://cython.org/) to call your C++ code from Python, and then use Mojo's Python integration to work with the results.

## 1.5 Summary 
Here are the killer features of Mojo:  
1- fast compilation  
2- fast execution (runtime performance)  
3- automatic memory management  
4- seamless use of Python code  
5- adaptability to custom hardware through MLIR  

Mojo is also better to tackle climate-change: a Mojo program uses only 10% of the energy usage of an equivalent Python program.
