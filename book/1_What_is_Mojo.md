# 1 – What is Mojo?
Mojo is a new general purpose programming language*, with an initial focus on AI applications. Over time, the whole spectrum of general-purpose programming will be covered.
It is the first language which is based on the [MLIR compiler infrastructure](https://mlir.llvm.org/), so it can run on all hardware.

It combines the usability of Python with the performance of C++/C and the safety of Rust.

It uses the *Python syntax and semantics* model: it already can run a lot of Python code. It will eventually become a *superset of Python*, able to execute all existing Python code, as well as specific Mojo code.
    Why?   
    - Because Python is one of the (if not the) most popular language(s) (2023 Aug: the number one language in the [Tiobe index](https://www.tiobe.com/tiobe-index/), and it was the Tiobe top language in 2020-21).  
    - Because Python is the number one language used in machine learning and AI projects.   
This makes it easy for Python-savvy developers to learn and use it almost immediately.


## 1.1 Write everything in one language
Mojo aims to to solve the three-language problem in current AI-research and industry. 

* Data scientists and AI-ML researchers want to model in Python, because Python makes prototyping and modelling easy. But when an AI project goes into production, Python often can't deliver the necessary performance.
* For that reason, product engineers want to deploy an AI project in a low-level language. This often entails rewriting large parts of the project in C++.
* To get access to GPU's and other accelerators, often parts of the model have to be rewritten in CUDA, or accelerator languages required for CPUs, GPUs, TPUs, and so on, which are even lower-level.

Mojo is created to solve this problem:
* It has the usability and intuitiveness of Python for model development, adding meta-programming features, like a truly high-level language. The entire Python ecosystem is made available to Mojo through CPython. 
* It has the performance and system programming capabilities of a low-level language like C++ or Rust.
* Mojo is built on top of next-generation compiler technologies. By taking advantage of MLIR, Mojo code can access a variety of AI-tuned hardware features, such as TensorCores and AMX extensions. 
MLIR removes the necessity to use CUDA at the lowest level. This compatibility allows the same code to be compiled for different devices *without modifications*.

This will lead to accelerated development and production-use of AI technologies.

## 1.2 Targets and Characteristics of the language
*Mojo is F(ast), - S(calable), A(ccelerated)*.  

Mojo combines the parts of Python that researchers love with the systems programming features that require the use of C, C++ and CUDA

Let's analyze each of these characteristics.

### 1.2.1 A Fast language
Mojo utilizes next-generation compiler technologies with integrated caching, multithreading, and cloud distribution technologies.
It compiles to *machine code* specific to the target platform. It uses the MLIR compiler toolchain (which is itself based on LLVM) to achieve that. That way it harnesses all of LLVM/MLIR execution speed optimizations, and through MLIR, which talks to all exotic hardware platforms, it can unlock the performance potential of modern hardware.  
By progressively using types in code, performance can be enhanced.

" - Autotuning: With autotuning, Mojo can automatically find the best values for your parameters, which can drastically streamline the programming process  

- Tiling optimization: Mojo includes a built-in tiling optimization tool that effectively caches and reuses data, which helps optimize performance by using memory located near each other at a given time and reusing it. 
(Mojo has a built-in tiling optimization tool that improves cache locality and memory access patterns by dividing computations into smaller tiles that fit into fast cache memory.) 

- Parallel computing: 
Python has the GIL (Global Interpreter Lock) limitation: even if your app is multithreaded, Python can only execute one thread (so use one of you machine's cores) at a time.
Mojo introduces inbuilt parallelization, enabling multithreaded code execution, which can increase execution speed by 2,000x. It simplifies writing of efficient, parallel code through automatic parallelization across multiple hardware backends, without requiring low-level parallelization knowledge.

- Mojo has no GC (garbage collection), so it doesn't suffer from GC pauses, and can be used in real-time domains. Instead, it has *automatic memory management*: it implements ownership and borrow-checking and lifetime concepts similar to Rust, but simplifying the syntax. Mojo's compiler tracks the lifetime of a variable using static analysis and destroys data as soon as it is no longer in use.

It also offers control over memory storage: struct field values are inline-allocated values.

- Mojo also doesn't suffer from Python's GIL (Global Interpreter Lock), so it can put to use multiple threads and concurrency much better.

**Benchmarks**
- Early benchmark comparisons show that Mojo has the performance level of C/C++ (or faster) and Rust:
![benchmark comparisons](https://github.com/Ivo-Balbaert/The_Way_to_Mojo/blob/main/images/performance.png) 
It easily beats Python performance with 4 orders of magnitude.
It uses the whole range of possibilities offered by modern compiler optimizations, including automatic parallel processing across multiple cores. This is nicely illustrated in the section starting at 33:08 by Jeremy Howard of the [Keynote speech](https://www.youtube.com/watch?v=-3Kf2ZZU-dg) which announced Mojo to the world.

### 1.2.2 A Scalable language
Mojo offers native support for multiple hardware backends: Mojo allows for utilization of CPUs, GPUs, TPUs, and custom ASICs, catering to the strengths of each hardware type.
Starting with writing code like Python, you can scale all the way down to the metal and enabling you to program the multitude of low-level AI hardware, thanks to Mojo's MLIR foundation. Because of its LLVM fundament, it targets a wide diversity of OS platforms. MLIR itself has great adaptability to new kinds of hardware stacks and allows Mojo to scale to new exotic hardware types and domains.

Conclusion: Mojo can run almost everywhere.

A Mojo project compiles to a single executable: this makes for easy deployment, just copy the executable to the target machine and run it.

### 1.2.3 An Accelerated language
Mojo has been specifically designed to run AI-projects on diverse hardware, for example: GPUs for running CUDA, TCPU's, xCPUS's and so on.

Mojo is also *safe and reliable* because of:   
* It has a statically typed (AOT - ahead of time) compilation, resulting in faster execution times and better optimization. 
>Note: When running a Mojo kernel in a Jupyter notebook, JIT (Just In Time) compilation is used.
(See also § 2.1)

Mojo prefers compile-time errors to runtime errors, because solving bugs at runtime is so much more painful (as developers in dynamic languages like Python and Ruby know well): this gives developers more confidence in their codebase.
* It offers *type inference* in many cases to make development easier.

* Its automatic memory management prevents memory errors (segfaults) and memory-leakage, a common cause for bugs in C++ applications.

[Note on MLIR]
MLIR stands for "Multi-Level Intermediate Representation".
(https://llvm.org/devmtg/2020-09/slides/MLIR_Tutorial.pdf)
MLIR is a replacement for LLVM’s IR for the modern age of many-core computing and AI workloads.It’s critical for fully leveraging the power of hardware like GPUs, TPUs, and the vector units increasingly being added to server-class CPUs.

## 1.3 Use cases of the language
Mojo is designed in the first place for AI development (?? elaborate). But it is also a general purpose language, suitable for building high-quality servers, CLI's (command-line applications), graphical native desktop UI's (user interfaces), database extensions, editor plugins, robotics, embedded applications, and so on.  
It is used to develop AI algorithms and can also be used for other tasks like high-performance computing (HPC), data transformations, writing pre/post-processing operations, and more.
As a kind of *Python++*, Mojo could serve the whole software industry.

"
* Systems Programming: Mojo is well-suited for systems programming tasks, such as developing operating systems, device drivers, or firmware. Its low-level capabilities and efficient memory management make it ideal for these types of applications.
* Performance-Critical Applications: Mojo’s ability to optimize code execution makes it a good choice for performance-critical applications. This includes tasks like scientific computing, data analysis, or simulations that require efficient processing of large amounts of data.
* Embedded Systems: Mojo can be used in developing software for embedded systems, which are specialized computer systems found in devices like smartphones, IoT devices, or automotive systems. Its lightweight nature and close integration with hardware make it a valuable tool for embedded programming.
* Networking and Network Protocols: Mojo provides extensive support for network programming, making it useful for developing networking applications and protocols. Whether it’s creating web servers, implementing network protocols, or building communication systems, Mojo offers the necessary functionality.
* Game Development: The performance and low-level control offered by Mojo make it suitable for game development. It allows developers to create high-performance games with complex graphics and physics engines.
* Cryptography and Security: Mojo’s ability to work with low-level operations and efficient algorithms makes it well-suited for cryptography and security-related applications. It enables the development of secure communication systems, encryption algorithms, and cryptographic protocols.
* High-Performance Web Applications: Mojo’s performance optimizations and ability to handle high concurrency make it a good choice for building high-performance web applications. It can handle a large number of requests efficiently, making it ideal for handling heavy web traffic.
* Machine Learning and AI: Mojo’s compatibility with existing Python packages and libraries makes it useful for machine learning and artificial intelligence tasks. It allows developers to leverage popular machine learning frameworks and libraries to build and deploy AI models.
"

## 1.4 Languages that influenced Mojo
Mojo belongs to the Python dynamic languages family (Python, CPython, Numpy, PyPy, and so on).  
It is a direct descendant of Python, but extends its use greatly. Mojo picks up where Python stops, helping in use cases that are out of Python's scope, mostly high-performance applications.  
It also builds on Rust, Swift and Julia, for which it certainly is seen as a competitor.    

**Interop with other languages and migration strategy**  
Mojo code can be mixed with Python. It can also call all Python libraries from its vast ecosystem, which are executed through the CPython interpreter, which talks to Mojo. This gives you a way to incrementally transition a legacy code base from Python to Mojo, making migration of Python easy. When Mojo becomes a superset of Python, all you have to do is to change the file extension from .py to .🔥(or .mojo), and you are running your code in Mojo!

The Mojo runtime also has a built-in GC to clean up Python objects, based on reference counting.

**Interaction with C/C++:**
It is on the roadmap.  Currently, you can use Python's C++ interop libraries like ctypes (https://docs.python.org/3/library/ctypes.html) or Cython (https://cython.org/) to call your C++ code from Python, and then use Mojo's Python integration to work with the results.

## 1.5 Summary 
Here are the killer features of Mojo: 
0- PROGRESSIVE/STATIC TYPING: Leverage types for better performance and error checking.
1- fast compilation  
2- fast execution (runtime performance): ZERO COST ABSTRACTIONS: Take control of storage by inline-allocating values into structures. Mojo includes a *high-performance concurrent runtime*. 
3- automatic memory management:  OWNERSHIP + BORROW CHECKER: Take advantage of memory safety without the rough edges.
>Note: if really needed, you could do manual memory management in Mojo. It provides a manual management system using pointers similar to C++ and Rust.

4- seamless use of Python code (a superset of Python)  
5- adaptability to custom hardware through MLIR: 
    PORTABLE PARAMETRIC ALGORITHMS: Leverage compile-time meta-programming to write hardware-agnostic algorithms and reduce boilerplate. 
    AUTO-TUNNING: Automatically find the best values for your parameters to take advantage of target hardware.
6- built-in support for SIMD 
7- built-in support for concurrency/parallelism (the `parallelize` function)
8- ease of use, readability
9- specifically designed for AI hardware
10- autotuning
    The `autotune` module in Mojo offers interfaces for adaptive compilation. It helps you find the best parameters for your target hardware by automatically tuning your code.

Mojo is also better to tackle climate-change: a Mojo program uses only 10% of the energy usage of an equivalent Python program.
