# 1B – General info about Mojo
Mojo is developed by a company called *Modular*, which was established in Jan 2022.    
The company's goals are based on two pillars:  

1- *MAX* =  Modular Accelerated Xecution, the fastest unified AI execution engine which will be commercialized.   
 An integrated, composable suite of products that simplify your AI infrastructure and give you everything you need to deploy low-latency, high-throughput generative and traditional inference pipelines into production. MAX will be available in a free, non-commercial Developer Edition and a paid, commercial Enterprise Edition in early 2024.
2- *Mojo*, as the next generation AI software development platform. All the kernels that power MAX are written in Mojo.

Mojo is designed and developed by **Chris Lattner** (the creator of the Swift programming language and LLVM Compiler Infrastructure - CEO of Modular) and Tim Davis (MLIR Product Manager at Google - Chief Product Officer of Modular), together with their team at Modular.

Mojo was announced in a [Product launch keynote](https://www.youtube.com/watch?v=-3Kf2ZZU-dg&t=0s) on May 2 2023.
Its design and implementation started on Sep 27, 2022, when the first piece of Mojo was added (a lexer).

Mojo will be open-sourced when the language is more ready for practical usage. (Apache License v2.0 with LLVM Exceptions) 

Mojo's community, supported by the Modular Mojo team, is also very helpful and welcoming.


## 1B.1 Some info about the name and logo.
The name of the language is **Mojo**, meaning "a magical charm" or "magical powers", which are applied to Python. 

Its logo is the [fire emoticon](https://emojipedia.org/fire) (?, werkt niet), the U+1F525 Unicode character. You can find it in the repo as: fire.png, kan emoji niet in file zetten??.

Mojo is also the first language to introduce emojis as file extensions:
Mojo’s source files have the fire emoticon extension like hello.🔥, or alternatively *.mojo*, as in *hello.mojo*.  
Mojo’s packages have an emoticon extension like greetings.📦, or alternatively *.mojopkg*, as in *greetings.mojopkg*.  

Mojo users are called *mojicians 🪄*.
The universe of all things Mojo is called the *Modverse*.

To search on internet for info on Mojo, use the search terms  "Mojo programming language" or "mojolang". 

## 1B.2 Website, community and communication channels
Here is the Mojo [portal - website](https://mojolang.org/) (at the current moment it is only a frontpage).

[GitHub](https://github.com/modularml/mojo) repo for issues, discussion, examples, source standard library

Closed Beta Local SDK:
[Developer portal](https://developer.modular.com)

Much more information can be found at the Modular/Mojo [Website](https://www.modular.com/mojo), particularly in the [Docs section](https://docs.modular.com/mojo/).

[Weekly newsletter:](https://www.modular.com/newsletters/)

[Wikipedia page:](https://en.wikipedia.org/wiki/Mojo_(programming_language))

To come into contact with other Mojo users or the Modular team: 
* [GitHub discussions](https://github.com/modularml/mojo/discussions)
* [GitHub issues](https://github.com/modularml/mojo/issues)

* [Mojo Discord channel](https://discord.com/invite/modular) or https://discord.gg/modular
* [Twitter channel](https://twitter.com/modular_ai)
* [Forum](https://mojo-forum.com/) ?? doesn't exist anymore

A tutorial site:   [mojodojo](https://mojodojo.dev/) created by Jack Clayton (mojodojodev@gmail.com)

An overview of [educational material and links to community projects](https://github.com/mojicians/awesome-mojo)

[Links for examples](https://github.com/modularml/devrel-extras/tree/main/blogs/)

?? wrong link - The [X Modular channel](https://twitter.com/modular_ai) regularly contains Mojo tutorials.


## 1B.3 A brief history, status and roadmap 
* 2022 - work on design started
    Sep 7 : first patch published
* 2023 May 2 - Product Keynote Launch Modular engine/Mojo
    Chris Lattner considers Mojo to be at v 0.1
* 2023 Aug 26: Early release Closed Beta Local SDK: Mojo release v 0.2.0
Currently, the Mojo SDK is for Linux only (Ubuntu 16.04 or higher). Native support for Windows is coming.
* 2023 Sep 7: First Mojo release for local download and execution on Linux - Mojo v 0.2.1 
* 2023 Sep 22: Mojo v 0.3.0
* 2023 Sep 29: Mojo v 0.3.1 (for installation and lsp problems)
* 2023 Oct 5:  Mojo v 0.4.0 (default parameters for structs and functions - file I/O)
* 2023 Oct 19: Mojo v 0.4.0 for Mac (support for Mac (Apple silicon))
* 2023 Nov 2:  Mojo v 0.5.0 and the Modular CLI 💻  v0.2.2
* 2023 Dec 4:  Mojo v 0.6.0 was announced/published during the 1st MODCON conference. Also MAX was introduced, and partnerships with AWS, replit, and NVidia.
* 2024 Jan 25: v0.7.0: (basics) of traits, lifetimes, Dict, Reference, ...
* 2024 Feb 29: v24.1: integration with MAX, debugging, Set, ...
    Modular version 24.1.0-beta1-f7ed1b63-release
    mojo 24.1.0 (55ec12d6) / max 24.1.0-beta1 (f7ed1b63)
* 2024 Mar 29 - open source standard library
    Modular version 24.2.0-c2427bc5-release
    mojo 24.2.0 (c2427bc5) / max 24.2.0 (c2427bc5)

Goals / Roadmap:
* 2024 Jan??: Windows version
* 2023 Jun 17 - A rough estimate mentioned by the team is that the language might be very usable for a lot of things in 18 months, so about 2024 Dec


## 1B.4 Popularity

|  Date        | GH watch | stars | forks | issues | open pull reqs | Contributors | Discord | Twitter | 
|--------------|----------|-------|-------|--------|----------------|--------------|-------  |----------
| 2023 Aug 13  | 175      | 9200  |  188  |  82    |  /             |   4          |  18465  |   10400 | 
| 2023 Sep 15  | 224      | 13895 |  1408 |  199   |  5             |   8          |  20900  |   13100 | 
| 2023 Oct 12  | 238      | 14977 |  2000 |  225   |  2             |   15         |  22100  |   14100 | 
| 2023 Nov 13  | 241      | 15581 |  2000 |  294   |  0             |   15         |  21700  |   15000 | 
| 2024 Apr 17  | 262      | 20887 |  2500 |  583   |  33            |   86         |  21500  |   15000?? | 

GH = GitHub

2023 Aug 24: in the 4 months since the product keynote, the Modular community has grown to more than 120K+ developers, including tens of thousands of enterprises.
2023 Sep: more than 120K+ developers have signed up to the Mojo download and 19K+ developers actively discuss Mojo on Discord and GitHub.
* See image mojo-eco.png

TIOBE-index:
First time registered: Nov 2023: position 184 
                       Dec 2023: 174

[Tiobe-index](https://www.tiobe.com/tiobe-index/)
* 2023 Nov: 1st rating of Mojo, starting at position  .

## 1B.5 Business and support model
The company *Modular* is funded by VC (Venture Capital).  
* June 30, 2022: Modular raised $30M from GV (Google Ventures), Greylock, Factory, SV Angel and notable angels who are backing us.    
* Aug 24, 2023: Modular raised $100 million in new funding, led by General Catalyst and filled by existing investors GV (Google Ventures), SV Angel, Greylock, and Factory.   

* The AI inference engine MAX is the primary product.
2023 Dec 4: ModCon 1 - key announcements:
    * Modular partners with Amazon Web Services (AWS) to bring MAX Enterprise Edition exclusively to AWS services and porting in to the Amazon Graviton processor.
    * Replit AI using MAX
    * Partnership with NVidia: Modular partners with NVIDIA to bring GPUs to the MAX Platform\par

2024 Feb 29: announcing MAX Developer Edition.


## 1B.6 Some one-liners
* Mojo🔥: The Language of AI
* Python++
* Mojo was created to integrate Python’s usability with C’s performance
* Mojo is as simple as Python and as fast as Rust.
* Mojo: a super-charged Python for AI.
* "It's time to get your Mojo 🔥 back!"
* Mojo is to Python like TypeScript is to JavaScript.
* If Mojo can defeat Go in terms of parallelism, Rust in terms of safety, Julia in terms of affinity, it will reach unprecedented popularity among developers.
* Faster than C++, more hackable than Nvidia’s CUDA, and as safe as Rust.
* The best of multiple worlds: the ease of use and clear syntax of Python, with the speed and memory safety of Rust.
* Mojo may become the lingua franca of the programming world.
