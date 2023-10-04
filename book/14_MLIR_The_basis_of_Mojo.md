# 14 MLIR - The basis of Mojo
(ext verbatim from nnotebook BoolMLIR.ipynb)

MLIR = Multi-Level (Machine Learning) Intermediate Representation
Mojo lowers to MLIR and LLVM.

See:
- https://en.wikipedia.org/wiki/MLIR_(software)
- https://mlir.llvm.org/
- MLIR_primer.pdf
- https://github.com/TeamPuzel/mojo-std/blob/master/std/primitive.mojo

*Direct access to MLIR*
Mojo provides the programmer access to all of the low-level primitives that you need to write powerful -- yet zero-cost -- abstractions. These primitives are implemented in [MLIR](https://mlir.llvm.org), an extensible intermediate representation (IR) format for compiler design. Many different programming languages and compilers translate their source programs into MLIR, and because Mojo provides direct access to MLIR features, this means Mojo programs can enjoy the benefits of each of these tools.

Mojo provides full access to the MLIR dialects and ecosystem. Please take a look at the Low level IR in Mojo notebook how to use the __mlir_type, __mlir_op, and __mlir_type constructs. All of the built-in and standard library APIs are implemented by just calling the underlying MLIR constructs, and in doing so, Mojo effectively serves as syntax sugar on top of MLIR.

Most Mojo programmers will not need to access MLIR directly, and for the few that do, this \"ugly\" syntax gives them superpowers: they can define high-level types that are easy to use, but that internally plug into MLIR and its powerful system of dialects.

Mojo programs can take full advantage of *anything* that interfaces with MLIR. While this isn't something normal Mojo programmers may ever need to do, it's an extremely powerful capability when extending a system to interface with a new datatype, or an esoteric new accelerator feature.

## 14.1 What is MLIR?

MLIR is an intermediate representation of a program, not unlike an assembly language, in which a sequential set of instructions operate on in-memory values.

More importantly, MLIR is modular and extensible. MLIR is composed of an ever-growing number of *dialects.* Each dialect defines operations and optimizations: for example, the ['math' dialect](https://mlir.llvm.org/docs/Dialects/MathOps/) provides mathematical operations such as sine and cosine, the ['amdgpu' dialect](https://mlir.llvm.org/docs/Dialects/AMDGPU/) provides operations specific to AMD processors, and so on.  
Each of MLIR's dialects can interoperate with the others. This is why MLIR is said to unlock heterogeneous compute: as newer, faster processors and architectures are developed, new MLIR dialects are implemented to generate optimal code for those environments. Any new MLIR dialect can be translated seamlessly into other dialects, so as more get added, all existing MLIR becomes more powerful.  

This means that our own custom types, such as the `OurBool` type we'll create below, can be used to provide programmers with a high-level, Python-like interface. But under the covers, Mojo and MLIR will optimize our convenient, high-level types for each new processor that appears in the future.

## 14.2 Defining a bool type with MLIR

See `mlir_bool.mojo`:
```mojo
alias OurTrue = OurBool(__mlir_attr.`true`)
alias OurFalse: OurBool = __mlir_attr.`false`


@register_passable("trivial")
struct OurBool:
    var value: __mlir_type.i1  # 1

    # fn __init__(inout self):
    #     self.value = __mlir_op.`index.bool.constant`[value : __mlir_attr.`false`,]()

    # fn __init__() -> Self:
    #     return Self {
    #         value: __mlir_op.`index.bool.constant`[
    #             value : __mlir_attr.`false`,
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
        let lhsIndex = __mlir_op.`index.casts`[_type : __mlir_type.index](
            self.value
        )
        let rhsIndex = __mlir_op.`index.casts`[_type : __mlir_type.index](
            rhs.value
        )
        return Self(
            __mlir_op.`index.cmp`[
                pred : __mlir_attr.`#index<cmp_predicate eq>`
            ](lhsIndex, rhsIndex)
        )

    fn __invert__(self) -> Self:
        return OurFalse if self == OurTrue else OurTrue


fn main():
    # let a: OurBool                # 2
    let a = OurBool()  # 3  - this needs an __init__ method !
    let b = a  # 4 error: 'OurBool' does not implement the '__copyinit__' method

    let e = OurTrue
    let f = OurFalse

    let g = OurTrue
    if g:
        print("It's true!")  # 5  - __bool__ is needed here => It's true!

    # After defining the  __mlir_i1__, the __bool__ method is no longer needed
    let h = OurTrue
    if h:
        print("No more Bool conversion!")

    let i = OurFalse
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


## 14.3 Defining an integer with MLIR

See `mlir_int.mojo`:
```mojo
@register_passable("trivial")
struct UInt8:
    alias Data = __mlir_type.ui8

    var value: Self.Data

    @always_inline
    fn __init__(value: Int) -> Self:
        return Self {
            value: __mlir_op.`index.castu`[_type : Self.Data](value.__mlir_index__())
        }

    @always_inline
    fn __add__(self, rhs: Self) -> Self:
        return Self(
            __mlir_op.`index.add`[_type : __mlir_type.index](
                __mlir_op.`index.castu`[_type : __mlir_type.index](self.value),
                __mlir_op.`index.castu`[_type : __mlir_type.index](rhs.value),
            )
        )

    @always_inline
    fn __sub__(self, rhs: Self) -> Self:
        return Self(
            __mlir_op.`index.sub`[_type : __mlir_type.index](
                __mlir_op.`index.castu`[_type : __mlir_type.index](self.value),
                __mlir_op.`index.castu`[_type : __mlir_type.index](rhs.value),
            )
        )

    @always_inline
    fn to_int(self) -> Int:
        return Int(__mlir_op.`index.castu`[_type : __mlir_type.index](self.value))

    fn print(self):
        print(self.to_int())


fn main():
    let i: UInt8 = 42
    i.print()   # => 42
```

## 14.4 Copying data with raw pointers
Example usage 2:  (see ray_tracing.mojo)
Raw pointers are used here to efficiently copy the pixels to the numpy array:
       
```mojo
 let out_pointer = Pointer(
            __mlir_op.`pop.index_to_pointer`[
                _type : __mlir_type[`!kgen.pointer<scalar<f32>>`]
            ](
                SIMD[DType.index, 1](
                    np_image.__array_interface__["data"][0].__index__()
                ).value
            )
        )

 let in_pointer = Pointer(
            __mlir_op.`pop.index_to_pointer`[
                _type : __mlir_type[`!kgen.pointer<scalar<f32>>`]
            ](SIMD[DType.index, 1](self.pixels.__as_index()).value)
        )
```