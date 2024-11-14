# 13 Traits

!! Better explanation why traits are useful

A lot of structs in a project and among projects share the same characteristics (fields or methods). Characteristics that are common could be collected in a so-called `trait`, even without code. Structs could then be said to conform to or implement this trait when they provide code for (implement) all of its characteristics.

Traits exist in many languages (Rust, and so on), but are sometimes called interfaces (in Java and C# for instance), C++ concepts, Swift protocols.

## 13.1 What are traits?
" A trait is like a template of characteristics for a struct. If you want to create a struct with the characteristics defined in a trait, you must implement each characteristic (for example: each method). Each characteristic in a trait is a "requirement" for the struct, and when your struct implements each requirement, it's said to "conform" to the trait. It's like a contract: the type that conforms to a trait guarantees that it implements all of the features of the trait."

This makes it possible to write generic functions, which can take traits as arguments, so these functions accept all struct types that implement these traits! That way we can write one generic function that depends on the trait, rather than a lot of overloads for individual types.

A trait is an abstract type that cannot be instantiated. A concrete type (a struct or class) must implement the method(s) of the trait. 
> Traits are also types!

Traits also bring more structure to the type-hierarchy (!!). With traits you can also write generic types (example !!).

>Note: Currently (May 2024) traits can contain only method signatures 

See for example: 
`traits1.mojo`:
```py
trait SomeTrait:
    fn required_method(self, n: Int): ...

@value
struct SomeStruct(SomeTrait):           # 3
    fn required_method(self, n: Int):
        print("hello traits", n)   

fn fun_with_traits[T: SomeTrait](x: T):  # 2  <-- generic function
    x.required_method(42)

fn main():
    var thing = SomeStruct()
    fun_with_traits(thing)  # 1 => hello traits 42
```

Notice that in line 1 we pass a struct instance to the function, but the function in line 2 accepts this as a generic trait type T, which is defined as a parameter. The function works for all structs that implement the trait SomeTrait.

" The function can accept any type T for x (x : T) as long as T conforms to SomeTrait [T: SomeTrait]. Thus, fun_with_traits() is known as a *generic function* because it accepts a generalized type instead of a specific type.

In line 3, the trait *explicitly* declares that it implements the trait, in the general format:  struct Struct1(Trait1).  
*Implicit* trait conformance is also allowed, Struct1 must implement all methods of the trait, but is declared as struct Struct1.


More concrete (own) example:
See `traits2.mojo`:
```py
trait Polygon:
    fn area(self): ...

struct Rectangle(Polygon):
    var length: Int
    var width: Int

    fn __init__(inout self, length: Int, width: Int):
        self.length = length
        self.width = width

    fn area(self):
        print("The area of the rectangle is:", self.length * self.width)

struct Square(Polygon):
    var side: Int

    fn __init__(inout self, side: Int):
        self.side = side

    fn area(self):
        print("The area of the square is:", self.side ** 2)

# generic function:
fn calc_array[T: Polygon](x: T):  
    x.area()


fn main():
    var r1 = Rectangle(4, 5)
    r1.area() # => The area of the rectangle is: 20
    var s1 = Square(4)
    s1.area() # => The area of the square is: 16

    calc_array(r1) # => The area of the rectangle is: 20
    calc_array(s1) # => The area of the square is: 16
```

!! Making a generic List that can take squares and rectangles?

Traits can require static methods:
See `trait_static.mojo`:
```py
trait Message:
    @staticmethod
    fn default_message():
        ...


struct Hello(Message):
    fn __init__(inout self):
        ...

    @staticmethod
    fn default_message():
        print("Hello World")


struct Bye(Message):
    fn __init__(inout self):
        ...

    @staticmethod
    fn default_message():
        print("Goodbye")


fn main():
    Hello.default_message() # => Hello World
    Bye.default_message()   # => Goodbye
```

Traits can specify required lifecycle methods, including constructors, copy constructors and move constructors.

## 13.2 Trait inheritance
Traits can inherit from other traits, like in the following example where trait Bird inherits the Animal trait.  A trait that inherits from another trait includes all of the requirements declared by the parent trait.

Example:
```py
trait Animal:
    fn make_sound(self):
        ...

# Bird inherits from Animal
trait Bird(Animal):
    fn fly(self):
        ...
```

A trait that inherits from multiple traits is written like:  trait Trait1(PTrait1, PTrait2).
Example:

See `traits_inherit.mojo`:
```py
trait Flyable:
    fn fly(self): ...

trait Walkable:
    fn walk(self): ...

trait WalkandFlyable(Flyable, Walkable): ...

struct Bird(WalkandFlyable):
    fn __init__(inout self): ...
    fn fly(self): print("Fly to the sky")
    fn walk(self): print("Walk on the ground")

fn main():
    Bird().fly()
    Bird().walk()
```


## 13.3 Built-in traits
The following traits are defined in the standard library, and implemented by a number of standard library types. You can also implement these on your own types.

!! Standardize descriptions (table !!)
* why is this trat useful, what does it guarantee?
* required trait(s) or methods to implement
* other info

### 13.3.1 AnyType
This requires the type that implements this trait to have a destructor __del__().
All Mojo traits inherit from AnyType. All structs conform to AnyType.
This way generic collections can be built without leaking memory. 

### 13.3.2 Boolable
A type implements Boolable if it can be converted to a bool, so it must have a __bool__() method. 
Strings evaluate as True if they have a non-zero length. Collections evaluate as True if they contain any elements.

### 13.3.3 CollectionElement
This means that such an item must be Copyable and Movable.

### 13.3.4 Copyable
The type's value can be copied, so it has a copy constructor __copyinit__()

### 13.3.5 EqualityComparable
The type which can be compared for equality with other instances of itself, so it must implement __eq__() and __ne__().

### 13.3.6 Hashable
The type must specify a function __hash__() to hash their data.

### 13.3.7 Intable
A type implements Intable if it can be converted to an int, so it must have an int() or __int__() function.

### 13.3.8 KeyElement
This trait implements all requirements of dictionary keys. It inherits from the following traits:  
`AnyType, CollectionElement, Copyable, EqualityComparable, Hashable, Movable`

### 13.3.9 Movable
This trait requires the type to have a move constructor (__moveinit__()).

### 13.3.10 PathLike
A trait representing file system paths. The type must implement the __fspath__() method.

### 13.3.11 Sized
This describes a type that has an integer length (such as a string or array); it must implement the len() method (__len__()). 

### 13.3.12 Stringable
This trait confirms that a type can be converted to a string, with String(value) or str(value). This also means it can be printed with print(). It must implement the __str__() function.
Nearly all of the standard library types are Stringable.


24.4.0:  Representable, Indexer, Absable, Powable, Roundable, Ceilable, Floorable, Truncable

