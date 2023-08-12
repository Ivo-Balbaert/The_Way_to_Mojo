# 1 – What is Roc?

## Roc is F(ast), F(riendly) and F(unctional)
Roc is also safe and reliable.

Roc is a new purely functional programming language built for speed and ergonomics.
This means all Roc functions are [pure functions](https://en.wikipedia.org/wiki/Pure_function). A function is not pure if it has an *effect* or *side effect*, that is: if it modifies some state outside its local environment instead of only returning a value. The simplest example of an effect is displaying a value on standard output.

In Roc all effects are [managed effects](https://medium.com/@kaw2k/managed-effects-and-elm-36b7fcd246a9) instead of side effects.
It is a language to help anyone create delightful software, besides being a high performance and general-purpose language.  

## 1.1 The philosophy behind Roc
The next paradigm shift in software development is FP (functional programming).  
This is portrayed in how nearly all popular (OO) languages these days advertise themselves as also being functional.
FP programming and style is all about:  
* composition (not inheritance)
* modules
* first-class functions (not bound to classes)
* records (data-oriented design)
* avoiding mutation and side-effects (like I/O, networking, and so on)

Pure FP and style even don't support mutation and side-effects.  
Instead of side-effects, a great FP language should support **managed effects**:  
- managed effects are a *description* of what the side-effects need to do (building upon the concept of Tasks and pipe-operators |>)
- executing the actual side-effects is the responsibility of a 'runtime' (the 'platform').   
*Roc takes the runtime, and separates it as it were from the language*

Because of first-class immutability and managed effects, the order of definitions does not matter.  
Another important consequence is that reorganizing (refactoring) code is much less error-prone.

A Roc application consists of:  
* a Roc part (which is purely functional), 
* a platform part (which uses a low-level language like C, Rust, Zig or Swift and some Roc glue code).  
The platform part is responsible for executing the side-effects.

## 1.2 Targets/Characteristics of the language - Guiding design goals and priorities

Roc has characteristics of a high-level language:  
- it has automatic memory management (mainly through reference counting, or even transparent arena allocation).
but also characteristics of a low-level language:  
- compiles to machine code
- it avoids using heap memory (also called 'boxing') as much as possible: Roc only boxes things the size of which is unknown at compile-time.

### 1.2.1 A Friendly language
The aim is for Roc to be a user-friendly language with a friendly community of users.

The Roc compiler is user-friendly and helpful. This shows in the following features:
* Understandable help and error messages (aiming to meet the bar set by Elm); the compiler speaks of itself as a person, using I or me.
  It only shows the text of the warnings when there are no errors anymore.
* Let code execute if possible, even if there are still type checking errors.
* Complete type inference, no need for type annotations.
* Written in Rust, the compiler is very fast. Together with the editor (which is also written in Rust), this ensures fast interaction and a quick feedback loop. 
* Automatic serialization and deserialization using schemas determined by type inference.
* (?? not yet achieved 2023 May) Reliable hot code loading that's always enabled and requires no configuration to set up. Accessibility features in the included editor.
* Compiles to a single binary asset: this makes for easy deployment, just copy the executable to the target machine and run it.
* The LLVM compiler toolchain targets a wide diversity of OS platforms, so Roc can run almost everywhere.

Roc is also *safe and reliable* because of: 
* Full statically typed compilation. Prefer compile-time errors to runtime errors, because solving bugs at runtime is so much more painful (as developers in dynamic languages like Python and Ruby know well): this gives developers more confidence in their codebase.
Roc being an FP language: if it compiles, you know your code is going to run, and it’s going to run without errors. So the tests are primarily there to make sure it’s actually solving the problem that was intended. Writing tests is much easier in an FP language, because data and behavior are separate.
* no null / nil / undefined (see https://github.com/roc-lang/roc/blob/main/FAQ.md#why-doesnt-roc-have-a-maybe-or-option-or-optional-type-or-null-or-nil-or-undefined).
* Roc does bounds checking
* side-effects are executed only through the underlying platform. So if the platform is totally safe, the Roc app as a whole is also safe.

The Roc-editor will be an ambitiously boundary-pushing graphical editor, developer-friendly and dedicated:  
1- it ships with the language  
2- dedicated for Roc code only  
3- all interaction feels instant  
4- emphasize package-specific integrations  
5- refactoring should be simple : large code-bases are easy to change  

A language-focused editor can help the developer much more than a general language editor (see for example SmallTalk environments, Dr. Racket, Pharo or the Dark Editor, see Bret Victor demos).
The editor edits an in-memory AST (Abstract Syntax Tree) version of the Roc code.
(Example functionality: { }, record editing, CTRL-SHIFT UP).  
It has a built-in code formatter, which is zero-configuration : Roc code can only be formatted in one way.

Every package should ship with:  
* code   
* documentation  
* custom editor integration  
The editor is coupled with the language itself to allow package authors to include custom editor tooling inside packages.

Roc also ships a single binary (the `roc` tool), that includes not only a compiler, but also a REPL, package manager, test runner, debugger, static analyzer, code formatter, and a full-featured editor, all of which are designed to work seamlessly together.

The friendly aspect also stretches out to Roc's community, which is also very helpful and welcoming.

### 1.2.2 A Fast language
Roc runs fast, comparable to fast imperative systems languages like Rust, Zig, D and C/C++ (benchmark testing showed it is nearly as fast as C++ and faster than Go, see [benchmark](https://github.com/Ivo-Balbaert/The_Book_Of_Roc/blob/master/images/performance2.png), see § 3.7.3.  

Realistically, Roc will be somewhat slower than an unrestricted systems language.  
Then there are the non-systems languages (like Go, Java, JavaScript, C#, Swift and so on), which often use GC, a VM (virtual machine) and/or are JIT-ted (Just-In-Time compiled). Here the goal for Roc is to run faster than any of these languages that see mainstream use in industry today.  

This is achieved because Roc uses:
* *static typing* and an ahead of time (AOT) compiler producing native executables
* a	[monomorphizing compiler](https://en.wikipedia.org/wiki/Monomorphization), that is: the compiler optimizes for speed, not for size, resulting in larger binary assets. The *LLVM compiler* generates polymorphic code with state of the art *LLVM optimizations*.
* using *unboxed (= not allocated on the heap) data structures* (values) and *unboxed closures* 
Tasks (see § 11) in particular are closures in Roc. They contain other closures, and they are all unboxed.
* Roc has *automatic memory management* through *automatic reference counting* (like Rust, Swift, Nim), mostly done at compile-time (static). This memory management technique does cause some runtime overhead, but part of the analysis is static (can be done at compile-time), which reduces this overhead.  
Roc has no GC (garbage collector), so GC-pauses don't occur.
* If reference counting (often done static) points out that the ref count == 1 (uniqueness analysis, like Clean), then Roc does *opportunistic in-place mutation* (also called: static elision and re-use):
Roc semantically uses immutable defs (definitions) and pure functions, but:
```coffee
point = { x: 0, y: 0 }
point2 = { point & x: 5 }   # if point is never used again, it is safe to mutate it in place
point3 = { point2 & y: 10 } # same for point2
```
* Roc has *tail-call optimization* (TCO) to automatically transform a recursive function or loop into an imperative loop, producing the same machine code as the equivalent code in an imperative language.

*Roc is a pure functional language with the speed of an imperative language and no GC pauses*.

### 1.2.3 A Functional language
Roc is a pure functional language because:
- all values are immutable, in particular: there are no global variables as in imperative languages.
- 100% reliable type inference (as typical for the ML family tradition): so type annotations are not needed
  The compiler always interferes the broadest type in the code context. 
  The type system is also sound: if it compiles, you'll never get a type error at run-time.
- all functions are pure
- there are no loop structures (while, for, and so on) as in imperative languages
- all effects are managed effects instead of side effects

It makes Roc (like Elm) a lot more readable, debug-able, and testable.
It also facilitates considerably the tooling aspects around Roc. For example: it makes debugging more reliable and powerful, and tests can be run in parallel.

Roc has *no currying* (see https://en.wikipedia.org/wiki/Currying), contrary to Elm or most other functional programming languages. This simplifies type annotations.

It also has these features:  
- no semi-colons to end a code-line, instead: whitespace and indentation is significant (like in Python).
- it has a interactive shell or REPL

Roc is not an object-oriented language like Java or C++/C#: it has no classes or inheritance.

Implementation goals:
* The web server for the package manager is written in Roc (with an underlying Rust platform for the web server, for example warp).
* The editor plugins are written in Roc (with an underlying Rust platform for the editor itself, for example using gfx-hal).
* The CLI (for building Roc projects on CI platforms) has its user interface written in Roc (with an underlying Rust platform for fast compilation and basic CLI interactions).

## 1.3 Use cases of the language
Roc is a general purpose language, suitable for building high-quality servers, CLI's (command-line applications), graphical native desktop UI's (user interfaces), database extensions, editor plugins, robotics, and so on.
Instead of academic, Roc wants to be production ready for the software industry. 

Today (Apr 2023), only command-line interfaces have support beyond the proof-of-concept stage; the other use cases will mature over time.
Roc is also optimized for lightweight low-level applications, embedded systems, and so on.

Because it implements the shebang-line (#!) convention, Roc programs can execute as scripts. So Roc could be used as a *scripting language* also.

**Interaction and migration strategy**  
Roc functions can be called directly from any language that can call C functions (following the C ABI). That means Roc can be useful as a language for *implementing plugins*. It also gives you a way to incrementally transition a legacy code base from another language to Roc.

## 1.4 Languages that influenced Roc
Roc belongs to the ML languages family (OCaml, F#, Elm). It is a direct descendant of Elm, but differs from it. Roc picks up where Elm stops, helping in use cases that are out of Elm's scope, mostly backend applications. It wants to realize an Elm-like developer experience in other domains than the browser.
You can use Roc as an add-on to Elm (Elm as front-end web app, Roc as back-end) or some other language, but it can also be used stand-alone.   
Roc is similar to Haskell in many respects.
SML, Idris, and Haskell are the languages the overlap the most with Roc. I think one core difference between Roc and those languages is the same difference between PureScript and Elm. PureScript is extremely powerful, very academic, and quite daunting, while Elm is focused on simplicity and giving just enough to do a great job. Roc, being a descendant of Elm, is quite similar.  
*It wants to enable simple, clean, and enjoyable pure functional programming without the complexity that tend to come with these types of languages.*

With Haxe, it shares the goal to be cross-platform.  
It's similar to Deno (safe execution) and Dark (language integrated editor).   
Its syntax resembles Ruby or CoffeeScript, and should be familiar and acceptable to Python developers.
 
It uses LLVM for production code generation, just like Rust, Swift, and so on.  
Like MLton (and also Rust, C++), it has a monomorphizing compiler.
It has the same memory management strategy as Swift (also Lua, Nim ??); it has no GC (garbage collection) and doesn't require a VM (virtual machine).  
With Clean, it has in common opportunistic mutation in-place.  

**Interop with other languages**
Roc can work together with other high-level languages, like Java, JavaScript, Python or Ruby: see https://github.com/roc-lang/roc/tree/main/examples.

**Language comparisons**  
*Elm:*  
Elm is only suited for browser-based apps. Roc brings an Elm-like experience for other domains.
Elm is very agreeable to work with, but is only suited for web applications.
Roc wants to extend the same developer joy to all kinds of applications. 

Differences with Elm:
Roc compiles to native code, Elm to JavaScript.
Roc produces larger compiled assets, while Elm focuses on smaller size optimization (needed in web-apps).

Besides the performance and language features, having the same language for backend/frontend would have some major benefits:
* Not having to write the same functions twice
* Not having to learn two different ecosystems of libraries, tools etc. and having everyone at your company be equally proficient at the frontend and backend language.
* Having shared type definitions that cannot get out of sync
* Better automatic serialization - when the frontend and backend are the same, you don't need to worry about how data is encoded/decoded between the two languages.
* Having web frameworks with much richer features (like Meteor.js) due to them having control of both the backend and frontend.

## 1.5 Summary 
Here are the killer features of Roc:  
1- fast compilation  
2- fast execution (runtime performance)  
3- automatic reference counting and (??) choosing the memory management strategy by picking an underlying platform   
4- language-focused editor (should be better than vim)  
5- live up to Elm's ergonomic standards (like error messages)    