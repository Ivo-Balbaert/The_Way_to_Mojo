# 1B – General info about Roc
Roc is a new open-source language licensed under the [Universal Permissive License (UPL) v1.0](https://github.com/roc-lang/roc/blob/main/LICENSE), and designed and developed by Richard Feldman and his growing team of contributors.

Roc’s year of genesis was 2018, when its design was started.  
The GitHub repo got its initial commit in Jan 2019, and the repo was private until Sep 2022.
The current version is a nightly build (pre-release).

## 1B.1 Some info about the name.
The name of the language is **Roc**, named after a [mythical bird](https://en.wikipedia.org/wiki/Roc_(mythology)).
That’s why the ![logo](https://github.com/Ivo-Balbaert/The_Book_Of_Roc/blob/master/images/official_logo.png) is also a bird, specifically an origami, as an homage to Elm’s tangram logo.  
Roc is a direct descendant of the Elm programming language. The languages are similar, but not the same.
Origami likewise has similarities to tangrams, although they are not the same. Both involve making a surprising variety of things from simple primitives. Folds are also common in functional programming.  
The logo was made by tracing triangles onto a photo of a physical origami bird. It’s made of triangles, because triangles are a foundational primitive in computer graphics.  

The name was chosen because it makes for a three-letter file extension. It means something fantastical, and it has incredible potential for puns. 
Roc’s source files have the extension *.roc*.

To search on internet for info on Roc, use the search terms "roclang" or "Roc programming language". 

## 1B.2 The Roc BDFL and core team.
*Richard Feldman* is the BDFN (instead of BDFL): "Beneficial Dictator for Now". He is well-known as a speaker and author (he wrote the book: "Elm in Action" for Manning), and also as an Elm developer and contributor.
He previously worked at NoRedInk on Elm, Haskell and Roc, and currently works at [Vendr](https://www.linkedin.com/company/vendr-co/). He lives in Philadelphia, Pennsylvania (United States).  

Here are some ways to connect to him:  
* [Email](roc@rtfeldman.com) or oss@rtfeldman.com
* [GitHub](https://github.com/rtfeldman/)
* [Twitter](https://twitter.com/rtfeldman) as @rtfeldman
* [Linked-in](https://www.linkedin.com/in/rtfeldman/)
* [Podcast on Programming](software_unscripted.com)

Roc has more than 150 contributors, but here are the members of the core team, with their main area of expertise listed:
- Folkert de Vries @folkertdev <folkert@folkertdev.nl>: optimizations, Windows support
- Chad Stearns     @chadtech   <chadtech0@gmail.com>: standard library
- Anton-4                      <17049058+Anton-4@users.noreply.github.com>: Roc editor, general project management
- Ayaz Hafiz                   <ayaz.hafiz.1@gmail.com>
- Brian Carroll: Web Assembly integration     
- Brendan Hansknecht: surgical linker    <Brendan.Hansknecht@gmail.com>


## 1B.3 Motivation behind Roc's creation
Richard Feldman wanted to bring a functional language into the mainstream.  
It also had to be as delightful to develop in as **Elm**. But it must be usable on all kinds of platforms, not just the frontend web, which is Elm's focus.
Furthermore, it should compile fast, and have excellent performance.  
Summarized: A **F(ast), F(riendly) and F(unctional)** language.

In section 2 we explore what kind of language Roc is, and its main features.

## 1B.4 Website, community and communication channels
Here is the Roc [portal - website](https://www.roc-lang.org/).  
The source code of the language (GitHub repo) is [here](https://github.com/roc-lang/roc). The parent website also contains some auxiliary websites.
(Currently there is no Wikipedia page yet.) 

The [examples site](https://github.com/roc-lang/examples) contains a number of ready-to-run examples.
There is an [online REPL](https://www.roc-lang.org/repl) to try out the language without local installation.

Other communication channels are:
* [GitHub issues](https://github.com/rtfeldman/roc/issues)
* [Roc Zulip channel](https://roc.zulipchat.com)
* [Reddit channel](https://www.reddit.com/r/roc_lang/), R Feldman is u/rtfeldman.
* [Twitter channel](https://twitter.com/roc_lang)
* [Google Meetups](https://drive.google.com/drive/folders/1OrgVPE6qGx34MT8oP2aNsop1oAs3_EVl?usp=share_link)


## 1B.5 A brief history, status and roadmap 
* 2018 - work on design started
* 2019 - Jan: first commit / new team-members
* 2020 - first application: Hello World / QuickSort
* 2021 Sep - some useful applications (I/O) - compiling works end to end (with known bugs): cli, web-server applications, WASM 
   back-end works in browser, standard library is partially complete

* 2022 Apr - R. Feldman develops Roc at NoRedInk as a full-time job.
* 2022 - Roc for CLI applications becomes useful, first Roc service in production in NoRedInk.
* 2022 Dec 31 - A ton of progress in Roc happened in 2022. Here is a small sampling:
- 1590 pull requests were closed (4 a day) and 950 issues were created (!)
- The Roc language repo went public
- Many participated in using Roc for advent of code
**Examples**
- An elm-like architecture (TEA) example in Roc was shown off
- A GUI breakout game example was added, and shown off in a talk
- Roctris, a Roc implementation of Tetris was published
- Roc’s WASM backend was shown to be as performant, if not more so, relative to other functional languages (?? Roc not mentioned in the article, nly Roc version in repo) (https://github.com/bhansconnect/functional-mos6502-web-performance)
- A PoC Roc Async platform was demonstrated (https://github.com/bhansconnect/roc-async)
- A parser combinator example was demonstrated, serving as a launchpad for many derivatives
- PoC CSV and JSON parsers were demonstrated
- The Roc basic-cli platform continued to mature, gaining support for HTTP, paths, environment variables, files, CLI argument parsing, amongst other things
- A static-site generator was built
- A virtual DOM platform was built (modulo compiler bugs, coming soon TM)
- Examples of Roc inter-operating with Swift, Ruby, Crystal, and other languages were shown
- A raytracer was built (https://github.com/shritesh/raytrace.roc)
Onboarding
- The Roc tutorial and website were revamped
- Getting started with Roc became easier. Nightly releases for more platforms have been made available, packaging via nix has been improved, documentation has improved.
- Builtins moved to being defined in Roc themselves, easing the barrier for writing new builtins, and improving existing ones. And, many builtins were added.

**Language features:**
- Single quote literals (like 'a') were added
- Support for checking number literal bounds, and character literal bounds, was added, making it so that you can e.g. use ‘a’ as a U8, and never use -257 as an I8.
- Opaque types were added
- Support for Boxes, which allow you to explicitly heap-allocate large values, was added
- Abilities were added (then again.. then again.. and soon again..) with the builtin abilities Encode, Decode, Hash, and Eq, and auto-deriving of ability implementations for many builtin and opaque types
- Set/Dict were implemented, then re-implemented to be more performant using the Hash and Eq abilities
- Required indentation of when expressions, backpacking, and other constructs became more intuitive
- Tests via expect were added
- A print-line debugging mechanism dbg was added
- Pattern matching for lists and strings was added
- A simpler mental model for tag union types was added
- `crash` was added
- Initial support for packages was added

**Language tools**
- roc glue made platform development easier by automating type interoperability definitions
- roc dev added a single command to type-check, then compile in sequence with fast-fail
- Roc gained a web repl via the WASM backend, deployed on the Roc website
- The Roc REPL received an overhaul, making it more interactive
- Packages/platforms can now be specified and downloaded via URLs

**Compilation targets**
- The WASM backend reached feature parity with the LLVM backend
- Roc gained feature parity support for Aarch64 Macs via the LLVM backend
- Support for Windows landed

**Runtime performance improvements**
- Roc gained better support for handling lazy effects via Effect.after
- Roc got even better at eliminating unnecessary reference count operations, and got better at in-place mutation
- Closures got even smaller and faster to call
- Roc is able to prune certain conditional branches that can never be reached at runtime
- The runtime sizes of Roc tags became smaller in some cases

The Roc compiler became faster by default in many ways, including through caching of builtins, changing exhaustiveness-checking to make roc check faster for everyone, and eliminating performance bottlenecks that led to ridiculously-exponential speedups in some cases.

* 2023 Apr - Command-line interfaces have support beyond the proof-of-concept stage; the other use cases will mature over time (see § 2.4)
   The standard library is perhaps 80 percent complete in terms of functionality, but a lot of operations do not yet have documentation.
   The Editor is not yet usable as daily driver. 
   The code formatter is nearly feature complete.
   The test runner currently has first-class support for running standard non-effectful tests.
   Not yet started: packages, certain language features

Goals / Roadmap:
- 2023 - work on server use-case; 
       - glue becomes mature
       - compiler stability
- 2024 - useful, extensible editor, for daily editing
       - rbt (Roc build tool)
       - 0.1 release

## 1B.6 Popularity

|  Date        | GH watch | stars | forks | issues | open pull reqs | Contributors | Zulip | Reddit | Twitter |
|--------------|----------|-------|-------|--------|----------------|--------------|-------|--------|---------|
| 2021 Nov 29  | 69       | 104   |  18   |  357   |  19            |   58         |  100  |        |         |
| 2023 Apr 13  | 121      | 1958  |  112  |  798   |  38            |   150        |  1068 |        |         |
| 2023 Jun 8   | 126      | 2154  |  132  |  845   |  43            |   159        |  1137 |   99   |  1796   |

GH = GitHub

2022 Feb: 12660 commits  
![Contributions Jul 2019 - Feb 2022](https://github.com/Ivo-Balbaert/The_Book_Of_Roc/blob/master/images/contributions.png) 

## 1B.7 Business and support model
A [Roc Programming Language Foundation](https://foundation.roc-lang.org/) has been established, which is a nonprofit charity that pays open-source contributors to develop Roc. 
This organization is partly sponsored on GitHub (which reached 560$ in Jul 2023). 
 
There are also corporate sponsors: 
- [Vendr](https://www.vendr.com/)
- [rwx](https://www.rwx.com/)
- [Tweede golf](https://tweedegolf.nl/en)

In Apr 2023, Feldman moved to Vendr (an Saas buying platform), where he will introduce Roc and use it for in-house applications. Once Roc is stable enough for production, it will probably be used at Vendr.

## 1B.8 Some one-liners
"Roc: a language to help anyone create delightful software."  
"Roc: a hybrid language for applications and platforms."  
"Roc is built for speed and ergonomics."  
"Roc is Haskell, but geared towards practicality."  
"If Elm and Haxe had a baby, it would be this language."   
"Roc 'n roll"  
