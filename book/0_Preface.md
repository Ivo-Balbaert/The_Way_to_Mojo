# Preface - Goals of this Mojo tutorial.

This tutorial is meant to help people to hit the ground running when the Mojo programming language is released as open-source, and later as production ready.  
That's why it is called **"The Way to Mojo"**.  
We'll make sure this text and the accompanying code stays up to date with every new version of the language and its tooling.  

*Chris Lattner* is the creator of the Mojo language, and also an excellent speaker.  
This text is based upon notes taken while watching videos of his talks, and from primers and tutorials that appeared over time.

This tutorial is intended for novice programmers who want to learn this fascinating and promising language. We will try to explain from the ground up how Mojo is elegantly constructed to attain its goals, and how it works internally, with an emphasis on insight and best practices. 

We'll generally use simple code examples. At the same time, parallel guides with more in-depth information will also be provided, but they are not needed to learn basic Mojo programming.

We carefully want to avoid introducing a subject before all concepts needed to understand that subject where discussed. 

To find a specific subject, you could start at the front page of the GitHub repo, which lists all Section links. But there is also a [Table of Contents](https://github.com/Ivo-Balbaert/The_Book_Of_Mojo/blob/master/book/Table_of_Contents.md) document, which lists all subsections, making it easier to find something in particular.  
To find the most detail, use a "Find in Files" tool to search in the .md documents, like the find tool in Visual Studio Code. We also paid a lot of attention to cross-referencing (both forward an backward) in the text.  
(??) Use the appendices to search for a specific keyword, syntax, error message or convention.

(??) The material is divided into numbered sections **1_**, **2_**, and so on; **2B_** , **2C_** is the numbering for the more detailed info belonging to section 2. Each section has an accompanying folder _examples/N_  (where N was the section's number) with working code examples, and subfolders _exercises/N_, containing solutions to questions / exercises in the text. Code examples each contains a complete working program, showing only one discussed item each.
This results in a great number of smaller examples, but simplifies and enhances the learning experience.

Within code listings, important code lines will be indicated with **# 1**, **# 2** and so on, after the code. These numbers are referred to in the text. Any output of a program will be shown in the text as well as in the snippet itself, after a **# =>** in the code line itself or on the following line if needed.
Code examples are always completely shown in the text (unless otherwise stated), so you don't need to switch between the tutorial text and the example. Keep the examples close when you are going through the text, to see the entire context and for quick compiling and testing.

Here are some conventions we'll use in the text:

Code will be shown slightly highlighted (using the ```py Python markdown feature from GitHub). This is because Mojo's and Python's syntax are nearly identical.

It works like this:
```py
fn main():
    var x: Int = 1
    x += 1
    print(x)    # => 2
```

The # marks the beginning of a comment.
We'll use _italics_ for folder names, module names, other packages, and also for the output of running programs.  
We'll use **bold** for important concepts and new keywords.

Sometimes comparisons will be made with other programming languages, to better engage experienced developers.

We'll take great care in introducing every new concept step by step, and we will try to maintain a strict rule of not using anything in code examples which hasn't been discussed yet. This will also result in many examples like: "this thing can also be used in this way, or together with this other thing", but again we believe that this eases the learning curve.
If we absolutely need to mention something which has not been explained yet, we'll add a forward reference to where it is discussed.

Also for those of you who are beginning their programming journey, do speak out code internally when reading a program, explain to yourself all that happens in the code. 
Later on this becomes more automatic, but in the beginning stages it is very helpful to not be overwhelmed by code.

The examples/ folders only contain the Mojo source files. In order to be able to run these examples together with their platforms, they must be run from within the correct folders, as described in the section's text. When the platform is specified as a downloadable package, this will be installed locally the first time the program is compiled, and it will be available globally on the machine.

I want to express my sincere admiration to **Chris Lattner and his team** for creating this superb language. Welcome to the wonderful world of developing in Mojo!


**This book is dedicated to the memory of Jef Inghelbrecht, a close friend who passed away too soon.
He was also a great software developer, adhering to conservative and noble principles of software development.
That's why I am very sure he would have been a big fan of Mojo.**
