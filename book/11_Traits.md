# 8 Traits

?? Better explanation why traits are useful

A lot of structs in a project and among projects share the same characteristics (fields or methods). Characteristics that are common could be collected in a so-called `trait`, even without code. Structs could then be said to conform to this trait when they provide code (implement) all of its characteristics.

Trait exist in many languages (Rust, ...) and are sometimes called interfaces (in Java and C# for instance).

## 8.1 What are traits?
" A trait is like a template of characteristics for a struct. If you want to create a struct with the characteristics defined in a trait, you must implement each characteristic (for example: each method). Each characteristic in a trait is a "requirement" for the struct, and when your struct implements each requirement, it's said to "conform" to the trait. "

This makes it possible to write generic functions, which can take traits as arguments, so accept all struct types that implement these traits! Traits also bring more structure to the type-hierarchy (??).

>Note: Currently (May 2024) traits can contain only method signatures 

See for example: (?? other example)
`traits1.mojo`:
```py
trait SomeTrait:
    fn required_method(self, n: Int): ...

@value
struct SomeStruct(SomeTrait):
    fn required_method(self, n: Int):
        print("hello traits", n)   # => hello traits 42

fn fun_with_traits[T: SomeTrait](x: T):  # 2
    x.required_method(42)

fn main():
    var thing = SomeStruct()
    fun_with_traits(thing)  # 1
```

Notice that in line 1 we pass a struct instance to the function, but the function in line 2 accepts this as a generic trait type T, which is defined as a parameter. The function works for all structs that implement the trait.

" The function can accept any type for x as long as it conforms to SomeTrait. Thus, fun_with_traits() is known as a *generic function* because it accepts a generalized type instead of a specific type.

## 8.2 Common traits
### 8.2.1 Stringable
This trait confirms that a type that can be converted to a string,  
using String(value) or str(value).
Nearly all of the standard library types are Stringable.

### 8.2.2 Boolable
A type implements Boolable if it has a boolean representation.  
Strings evaluate as True if they have a non-zero length.
Collections evaluate as True if they contain any elements.
