# 1 – What is Mojo?
Mojo is a new general purpose programming language*, with an initial focus on AI applications. It is the first language which is based on the [MLIR compiler infrastructure](https://mlir.llvm.org/), so it can run on all hardware.
("CL: we don’t plan to stop at AI, the north star is for Mojo to support the whole gamut of general-purpose programming over time.")

It combines the usability of Python with the performance of C++/C and the safety of Rust.

It uses the *Python syntax* model, and will eventually become a *superset of Python*, able to execute all existing Python code, as well as specific Mojo code.
    Why?   
    - Because Python is one of the most (if not the) popular languages (2023 Aug: the number one language in the [Tiobe index](https://www.tiobe.com/tiobe-index/))  
    - Because Python is the number one language used in machine learning and AI- projects.   

## 1.1 Write everything in one language
Mojo aims to to solve the two-language problem in current AI-research and industry. 
(?? cfr. Julia)

* Data scientists and AI-ML researchers want to model in Python, because Python makes prototyping and modelling easy. When an AI project goes into , but Python can't deliver the necessary performance in a production environment.
* For that reason, product engineers want to deploy an AI project in a low-level language. This often entails rewriting large parts of the project in C++ and/or CUDA.

Mojo is created to solve this problem:
* It has the usability and intuitiveness of Python for model development, adding meta-programming features, like a truly high-level language. The entire Python ecosystem is made available to Mojo through CPython. 
* It has the performance and system programming capabilities of a low-level language like C++ or Rust.

This will lead to accelerated development and use in production of AI technologies.

## 1.2 Targets and Characteristics of the language
*Mojo is F(ast), - S(calable), A(ccelerated)*.  
Let's analyze each of these characteristics.

### 1.2.1 A Fast language
- Mojo compiles to *machine code* specific to the target platform. It uses the MLIR compiler toolchain (which is itself based on LLVM) to achieve that. That way it harnesses all of LLVM execution speed optimizations.

- Mojo has no GC (garbage collection), so it doesn't suffer from GC pauses, and can be used in real-time domains. Instead, it has *automatic memory management*: it implements ownership-checking and lifetime concepts similar to Rust, simplifying the syntax.

- Early ![benchmark comparisons](https://github.com/Ivo-Balbaert/The_Way_to_Mojo/blob/main/images/performance.png) show out that Mojo has the performance level of C/C++ (or faster) and Rust.
It uses the whole range of possibilities offered by modern compiler optimizations, including automatic parallel processing across multiple cores. This is nicely illustrated in this section of the Keynote speech (??) which announced Mojo to the world.

### 1.2.2 A Scalable language
Starting with writing code like Python, you can scale all the way down to the metal and enabling you to program the multitude of low-level AI hardware. 
 You can program the multitude of low-level AI hardware thanks to Mojo's MLIR foundation. Because of its LLVM fundament, it targets a wide diversity of OS platforms. MLIR itself has great adaptability to new kinds of hardware stacks and allows Mojo to scale to new exotic hardware types and domains.


  
Conclusion: Mojo can run almost everywhere.

A Mojo project compiles to a single binary asset (??): this makes for easy deployment, just copy the executable to the target machine and run it.

### 1.2.3 An Accelerated language
(??)

Mojo is also *safe and reliable* because of:   
* It has a statically typed (AOT - ahead of time) compilation. Mojo prefers compile-time errors to runtime errors, because solving bugs at runtime is so much more painful (as developers in dynamic languages like Python and Ruby know well): this gives developers more confidence in their codebase.

* Its automatic memory management prevents memory errors (segfaults) and memory-leakage, a common cause for bugs in C++ applications.

[Note on MLIR]
MLIR stands for "Multi-Level Intermediate Representation".
(https://llvm.org/devmtg/2020-09/slides/MLIR_Tutorial.pdf)

## 1.3 Use cases of the language
Mojo is designed in the first place for AI development (?? elaborate). But it is also a general purpose language, suitable for building high-quality servers, CLI's (command-line applications), graphical native desktop UI's (user interfaces), database extensions, editor plugins, robotics, embedded applications, and so on.
As a kind of *Python++*, Mojo could serve the whole software industry.

**Interop with other languages and migration strategy**  
Mojo code can be mixed with Python, and can also call all Python libraries from its vast ecosystem, which are executed through CPython. This gives you a way to incrementally transition a legacy code base from Python to Mojo.
?? Interaction with C/C++, ...

## 1.4 Languages that influenced Mojo
Mojo belongs to the Python dynamic languages family (Python, CPython, Numpy, PyPy, and so on).  
It is a direct descendant of Python, but extends its use greatly. Mojo picks up where Python stops, helping in use cases that are out of Python's scope, mostly high-performance applications.  
It also builds on Rust, Swift, ??

## 1.5 Summary 
Here are the killer features of Mojo:  
1- fast compilation  (?? )
2- fast execution (runtime performance)  
3- automatic memory management  
4- seamless use of Python code  
5- adaptability to custom hardware through MLIR  

Mojo is also better to tackle climate-change: a Mojo program uses only 10% of the energy usage of an equivalent Python program.
