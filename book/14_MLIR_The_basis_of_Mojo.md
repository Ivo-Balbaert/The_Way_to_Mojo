# 14 MLIR - The basis of Mojo

Mojo lowers to MLIR and LLVM.

*Direct access to MLIR*
Mojo provides full access to the MLIR dialects and ecosystem. Please take a look at the Low level IR in Mojo notebook how to use the __mlir_type, __mlir_op, and __mlir_type constructs. All of the built-in and standard library APIs are implemented by just calling the underlying MLIR constructs, and in doing so, Mojo effectively serves as syntax sugar on top of MLIR.

## 14.1 

See `use_module.mojo`:
```mojo
```

Example usage:  (see ray_tracing.mojo)
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