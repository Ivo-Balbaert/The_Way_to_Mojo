# 22 MLIR - The basis of Mojo

" Mojo supports ahead-of-time compilation. This means that we can run Mojo compiler over our source code to generate the machine code that gets executed on the computer. For a developer it may look as if Mojo reads the source code and directly generates the machine code. However, like many modern compilers, Mojo creates an intermediate representation of our source code before it generates the machine code. This intermediate representation (IR) is a simplified form of the program, which is easier to optimize and reason about. Many compilers use IRs that are custom built for the language supported by the compiler. Mojo does not have its own IR infrastructure, instead it uses Multi-Level Intermediate Representation (MLIR). Unlike other language IRs, MLIR is designed to be extensible and is capable of supporting many programming languages and different types of processors. "

## 22.1 Mojo is built on top of MLIR
MLIR = Multi-Level (Machine Learning) Intermediate Representation
Mojo lowers to MLIR and LLVM.

See:
- https://en.wikipedia.org/wiki/MLIR_(software)
- https://mlir.llvm.org/
- MLIR_primer.pdf
- https://github.com/TeamPuzel/mojo-std/blob/master/std/primitive.mojo
- https://www.modular.com/blog/mojo-llvm-2023

*Direct access to MLIR*
Mojo is syntax sugar for MLIR. In this sense, you could almost say that MLIR is "Mojo Language Intermediate Representation".
Mojo provides the programmer access to all of the low-level primitives that you need to write powerful -- yet zero-cost -- abstractions. These primitives are implemented in [MLIR](https://mlir.llvm.org), an extensible intermediate representation (IR) format for compiler design. Already a lot of different programming languages and compilers translate their source programs into MLIR, and because Mojo provides direct access to MLIR features, this means Mojo programs can enjoy the benefits of each of these tools.

Mojo provides full access to the MLIR dialects and ecosystem. Please take a look at the Low level IR in Mojo notebook how to use the __mlir_type and __mlir_op constructs. All of the built-in and standard library APIs are implemented by just calling the underlying MLIR constructs.

Most Mojo programmers will not need to access MLIR directly, and for the few that do, this \"ugly\" syntax gives them superpowers: they can define high-level types that are easy to use, but that internally plug into MLIR and its powerful system of dialects.

Mojo programs can take full advantage of *anything* that interfaces with MLIR. While this isn't something normal Mojo programmers may ever need to do, it's an extremely powerful capability when extending a system to interface with a new datatype, or an esoteric new accelerator feature.

MLIR is further sub-categorized into many different 'dialects', e.g. `arith` dialect for compiler operations related to arithmetic. Mojo's `Int` type is a wrapper around the `index` dialect.

!! Mojo only uses the LLVM and index dialect (video 2023 LLVM Mtg 34')

Mojo exposes the ability to embed MLIR within its own programs, enabling much deeper optimizations. Design choices such as these allow Mojo to be used to build operating systems and device drivers where close interaction with hardware and high performance is necessary.


## 22.2 What is MLIR?
MLIR is an intermediate representation of a program, resembling an assembly language, in which a sequential set of instructions operate on in-memory values.

More importantly, MLIR is modular and extensible. MLIR is composed of an ever-growing number of *dialects*. Each dialect defines operations and optimizations: for example, the ['math' dialect](https://mlir.llvm.org/docs/Dialects/MathOps/) provides mathematical operations such as sine and cosine, the ['amdgpu' dialect](https://mlir.llvm.org/docs/Dialects/AMDGPU/) provides operations specific to AMD processors, and so on.  
Each of MLIR's dialects can interoperate with the others. This is why MLIR is said to unlock heterogeneous compute: as newer, faster processors and architectures are developed, new MLIR dialects are implemented to generate optimal code for those environments. Any new MLIR dialect can be translated seamlessly into other dialects, so as more get added, all existing MLIR becomes more powerful.  

The extensibility of MLIR revolves around the ability to define custom dialects and operations within it. Dialects can be thought of as a namespace for a set of operations representing a particular aspect of a program. Operations represent a computation or a level of abstraction. Operations take operands (think of them as arguments) and produces results. Operations also take attributes, which are compile-time values such as constants. Attributes, operands and results have types associated with them. There is much more to MLIR than described here, but it is out of scope of this book.

Though MLIR comes with its own textual representation that is used by the MLIR compiler infrastructure, Mojo exposes MLIR elements through its own syntax.

This means that our own custom types, such as the `OurBool` type we'll create below, can be used to provide programmers with a high-level, Python-like interface. But under the covers, Mojo and MLIR will optimize our convenient, high-level types for each new processor that appears in the future.

Mojo’s MLIR elements start with __mlir. There are three different elements: 
__mlir_attr  
__mlir_type  
__mlir_op

### 22.2.1 __mlir_attr
As the name suggests, __mlir_attr provides the ability to define a MLIR attribute (similar to a compile-time constant) along with its data type.
```
alias _0 = __mlir_attr.`0:i1`
```
Here we are declaring an alias with an MLIR constant value 0 of MLIR type i1, which is 1 bit. If we do not provide i1, it will be assumed to be i64.

### 22.2.2 __mlir_type
The __mlir_type provides ability to refer to a given MLIR type.
```
var value: List[__mlir_type.i1]
```
Here we are declaring a list with contents of type i1.

### 22.2.3 __mlir_op
The __mlir_op provides ability to refer to a MLIR operation.
```
s += String(Int(__mlir_op.`index.castu`[_type=__mlir_type.index](i[])))
```
Here we are executing a casting operation from i1 to index type. Since Mojo’s Int type has a constructor that takes in MLIR index type, we are able to instantiate an Int value. Note that MLIR operation has the form <dialect>.<op>:
Here it is `index.castu`, specifying the castu operation from the index dialect.

Since MOJO does not allow its identifiers to have . in the name, we have to use backticks `` to be able to use a non-standard identifier.

## 22.3 Defining a bool type with MLIR
(Bool example: extract verbatim from notebook BoolMLIR.ipynb)

See `mlir_bool.mojo`:
```py
alias OurTrue = OurBool(__mlir_attr.`true`)
alias OurFalse: OurBool = __mlir_attr.`false`


@register_passable("trivial")
struct OurBool:
    var value: __mlir_type.i1  # 1

    # fn __init__(inout self):
    #     self.value = __mlir_op.`index.bool.constant`[value=__mlir_attr.`false`,]()

    # fn __init__() -> Self:
    #     return Self {
    #         value: __mlir_op.`index.bool.constant`[
    #             value= __mlir_attr.`false`,
    #         ]()
    #     }

    # Simplification:
    fn __init__() -> Self:
        return OurFalse

    fn __init__(value: __mlir_type.i1) -> Self:
        return Self {value: value}

    # fn __copyinit__(inout self, rhs: Self):
    #         self.value = rhs.value

    # Our new method converts `OurBool` to `Bool`:
    # fn __bool__(self) -> Bool:
    #     return Bool(self.value)

    # Our new method converts `OurBool` to `i1`:
    fn __mlir_i1__(self) -> __mlir_type.i1:
        return self.value

    fn __eq__(self, rhs: OurBool) -> Self:
       varlhsIndex = __mlir_op.`index.casts`[_type = __mlir_type.index](
            self.value
        )
       varrhsIndex = __mlir_op.`index.casts`[_type = __mlir_type.index](
            rhs.value
        )
        return Self(
            __mlir_op.`index.cmp`[
                pred = __mlir_attr.`#index<cmp_predicate eq>`
            ](lhsIndex, rhsIndex)
        )

    fn __invert__(self) -> Self:
        return OurFalse if self == OurTrue else OurTrue


fn main():
    #vara: OurBool                # 2
   vara = OurBool()  # 3  - this needs an __init__ method !
   varb = a  # 4 error: 'OurBool' does not implement the '__copyinit__' method

   vare = OurTrue
   varf = OurFalse

   varg = OurTrue
    if g:
        print("It's true!")  # 5  - __bool__ is needed here => It's true!

    # After defining the  __mlir_i1__, the __bool__ method is no longer needed
   varh = OurTrue
    if h:
        print("No more Bool conversion!")

   vari = OurFalse
    if ~i: print("It's false!")   # 6 => It's false!
```

A boolean can represent 0 or 1, \"true\" or \"false.\ To store this information, we define a struct `OurBool` in line 1, with a single member, called `value`. Its type is represented *directly in MLIR*, using the MLIR builtin type [`i1`](https://mlir.llvm.org/docs/Dialects/Builtin/#integertype). **This is a struct with a size of only one bit!**
In fact, you can use any MLIR type in Mojo, by prefixing the type name with `__mlir_type`.  

When Mojo evaluates a conditional expression, it actually attempts to convert it to an MLIR `i1` value, by searching for the special interface method `__mlir_i1__`. (The automatic conversion to `Bool` occurs because `Bool` is known to implement the `__mlir_i1__` method.)

Defining additional methods:  __eq__, __invert__ (used in line §),

As we'll see below, representing our boolean value with `i1` will allow us to utilize all of the MLIR operations and optimizations that interface with the `i1` type -- and there are many of them!
In line 2, we declare a variable of that type.
To instantiate it (line 3), we need an __init__ method. As in Python, `__init__` is a [special method](https://docs.python.org/3/reference/datamodel.html#specialnames) that can be defined to customize the behavior of a type. We can implement an `__init__` method that takes no arguments, and returns an `OurBool` with a \"false\" value.  

To initialize the underlying `i1` value, we use an MLIR operation from its ['index' dialect](https://mlir.llvm.org/docs/Dialects/IndexOps/), called [`index.bool.constant`](https://mlir.llvm.org/docs/Dialects/IndexOps/#indexboolconstant-mlirindexboolconstantop).  
MLIR's 'index' dialect provides us with operations for manipulating builtin MLIR types, such as the `i1` we use to store the value of `OurBool`. The `index.bool.constant` operation takes a `true` or `false` compile-time constant as input, and produces a runtime output of type `i1` with the given value.  
So, as shown above, in addition to any MLIR type, Mojo also provides direct access to any MLIR operation via the `__mlir_op` prefix, and to any attribute via the `__mlir_attr` prefix. MLIR attributes are used to represent compile-time constants.  

Mojo uses \"value semantics\" by default, meaning that it expects to create a copy of `a` when assigning to `b`. However, Mojo doesn't make any assumptions about *how* to copy `OurBool`, or its underlying `i1` value. The error indicates that we should implement a `__copyinit__` method, which would implement the copying logic.

In our case, however, `OurBool` is a very simple type, with only one \"trivially copyable\" member. We can use a decorator `@register_passable("trivial")` to tell the Mojo compiler that, saving us the trouble of defining our own `__copyinit__` boilerplate. Trivially copyable types must implement an `__init__` method that returns an instance of themselves, so we must also rewrite our initializer slightly.

Of course, the reason booleans are ubiquitous in programming is because they can be used for program control flow. However, if we attempt to use `OurBool` in this way, we get an error: error: 'OurBool' does not implement the '__bool__' method (see line 5).  


## 22.4 Copying data with raw pointers
Example usage 2:  (see ray_tracing.mojo)
Raw pointers are used here to efficiently copy the pixels to the numpy array:
       
```py
varout_pointer = Pointer(
            __mlir_op.`pop.index_to_pointer`[
                _type = __mlir_type[`!kgen.pointer<scalar<f32>>`]
            ](
                SIMD[DType.index, 1](
                    np_image.__array_interface__["data"][0].__index__()
                ).value
            )
        )

varin_pointer = Pointer(
            __mlir_op.`pop.index_to_pointer`[
                _type = __mlir_type[`!kgen.pointer<scalar<f32>>`]
            ](SIMD[DType.index, 1](self.pixels.__as_index()).value)
        )
```

## 22.5 Calling gmtime from C through MLIR
This uses the MLIR operation `pop.external_call`.

See `call_gmtime_mlir.mojo`:
```py
alias int = Int32


@value
@register_passable("trivial")
struct C_tm:
    var tm_sec: int
    var tm_min: int
    var tm_hour: int
    var tm_mday: int
    var tm_mon: int
    var tm_year: int
    var tm_wday: int
    var tm_yday: int
    var tm_isdst: int

    fn __init__() -> Self:
        return Self {
            tm_sec: 0,
            tm_min: 0,
            tm_hour: 0,
            tm_mday: 0,
            tm_mon: 0,
            tm_year: 0,
            tm_wday: 0,
            tm_yday: 0,
            tm_isdst: 0,
        }


fn main():
    var rawTime: Int = 0
    var rawTimePtr = Pointer[Int].address_of(rawTime)
    __mlir_op.`pop.external_call`[
        func = "time".value,
        _type = None,
    ](rawTimePtr.address)

    var tm = __mlir_op.`pop.external_call`[
         func = "gmtime".value,
        _type = Pointer[C_tm],
    ](rawTimePtr).load()

    print(tm.tm_hour, ":", tm.tm_min, ":", tm.tm_sec)  # => 17 : 41 : 6
```

## 22.6 Custom bitwidth integers
See `custom_bitwidth_integers.mojo`:
```py
@register_passable("trivial")
struct U24[N: Int]:
    var value: __mlir_type.ui24

    alias MAX: Int = 2**24 - 1
    alias ZERO: Int = 0

    alias greater_than_16777215_err_msg: StringLiteral = "Unable to parameterize a value of type `U24` with an integer value greater than 16777215"
    alias lesser_than_0_err_msg: StringLiteral = "Unable to parameterize a value of type `U24` with a negative integer value"

    @always_inline("nodebug")
    fn __init__() -> Self:
        constrained[N <= Self.MAX, Self.greater_than_16777215_err_msg]()
        constrained[N >= Self.ZERO, Self.lesser_than_0_err_msg]()
        return Self {
            value: __mlir_op.`index.castu`[_type = __mlir_type.ui24](N.__mlir_index__())
        }

    @always_inline("nodebug")
    fn __add__[M: Int](self: Self, other: U24[M]) -> U24[Self.N + M]:
        return U24[Self.N + M]()


fn main() raises:
    print("Size of `sizeof[U24]`: ", sizeof[U24[0]]())  # => Size of `sizeof[U24]`:  3
    alias c = U24[600]()
    # print("c = ", c.__into_int__())  # Should print "c = 600"
    # print(c)

   varplus = U24[600]() + U24[650]()
```

## 22.7 Constructing a bitlist with MLIR
See `mlir_bitlist.mojo`:
```py
alias _0 = __mlir_attr.`0:i1`
alias _1 = __mlir_attr.`1:i1`

struct BitList(Stringable):

    var value: List[__mlir_type.i1]

    fn __init__(inout self, *values: __mlir_type.i1):
        self.value = List[__mlir_type.i1]()
        for i in values:
            self.value.append(i)
    
    fn __str__(self) -> String:
        var s = String("0b")
        for i in self.value:
            s += String(Int(__mlir_op.`index.castu`[_type=__mlir_type.index](i[])))
        return s

fn main():
    print(BitList(_0, _1, _0, _1)) # => 0b0101
```

