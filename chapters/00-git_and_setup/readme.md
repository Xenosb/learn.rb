# Git gud

This is the first chapter in a series of 10 of the
[learn.rb project](https://github.com/monorkin/learn.rb) who's goal is to teach
people Ruby with a focus on Ruby on Rails.

The goal of this introduction chapter is to get you up and running with the
tools that we'll need to finish this course.

Please note that this project focuses on *nix operating systems, meaning
that Linux and Mac users will have a much easier time following it than
Windows users. This doesn't mean that examples for Windows users won't be given
just that some examples may not work out-of-the-box and the guide could have
discrepancies regarding software installation.

Now, with the disclaimers out of the way, we can finally begin!

For this course we'll need four basic tools:
1. A terminal emulator
2. A text editor
3. The Ruby runtime
4. The Git version tracker

Let's take each tool and explain why we need it.

## The terminal emulator

Most programmers still to this day honor standards that were set in the 80's and
70's, because of that we to this day still use terminals to interact with all
programs we write.

Back in the 70's and 80's computers didn't have enough processing power to
render a full desktop with icons and run programs at the same time. Therefore
people used terminals to interact with the computer.

A terminal is basically a digital typewriter. You type in commands that the
computer executes and then it prints the result on screen.

![DEC VT52 Video Terminal](http://www.columbia.edu/cu/computinghistory/vt52.jpg)

As computers were extremely expensive back-in-the-day, terminals were built
down to a cost meaning that they had just enough processing power to render
the text on screen, the heavy lifting / computing was done by a mainframe
computer the terminal was attached to.

![Ken Thompson operaiting a terminal infront of a mainframe](http://images.computerhistory.org/fellows/102637052.jpg)

Therefore, most computer scientists and programmers used terminals to program
the mainframes and run programs. As terminals have been standardised and as
they are an operating system agnostic way to run and write programs, and as
they can connect to any computer to run software they are in wide use to this
day.

Every operating system ships with a terminal emulator. A program that emulates
the behaviour of the old-school terminals. So that you can run and interact with
software on your or another computer through it.

On most Linux systems the terminal emulator is called Terminal, as well as on
Mac, while on Windows the terminal emulator is called cmd.exe.

Any built-in terminal will be more than sufficient for this course.

So let's fire it up and do a couple of examples!

![A blank terminal window](./images/terminal.png)

We can ask our computer to print out a message for us using the `echo` command.
For example `echo "Hello World"` will print out the words "Hello World" on
the screen.

![terminal - Hello World](./images/terminal-hello_world.png)

We can see where we are in the file system using the `pwd` (Print Working
Directory) command and list all files in the working directory using the `ls`
command (LiSt).

![terminal - using pwd and ls](./images/terminal-pwd_ls.png)

And we can navigate around using the `cd` (Change Directory) command. The `cd`
command takes a relative or absolute path as an argument, meaning that if we are
in the `/users/User` directory we can just type `cd Documents` to move to the
Documents directory, or we can give the full path to the Documents directory
like so `cd /users/User/Documents`, both commands have the same effect. `cd`
has two shortcuts: `.` and `..`. `cd .` will put you in the same place you were,
it's not really useful for navigating around, but for constructing relative
paths. While `cd ..` moves you one directory up (to the parent directory).

![terminal - navigation using dots](./images/terminal-dots.png)

This are the basics you will need to know to get started. Later we will
introduce a few more concepts, but we'll use the above mentioned commands all
the time.

## Text editor

Programming is the activity of instructing the computer how to solve problems.
While we could certainly write ones and zeroes and give them to the processor,
this would get laborious, therefore people have invented programming languages
over the years.

The idea of a programming language is to provide a more natural way for a
human to give instructions to the computer. In my opinion Ruby masters this,
but you can be the judge of that at the end of this course.

To write programs in any programming language we need a text editor. Its useful
to move, copy, paste and organise the code you are going to write. Please note
that there is a difference between word processors like LibreOffice and MS Word,
and text editors. The output of a text editor is a text file, while the output
of a word processor is a custom file format alike to `.docx`. Text editors have
no notion of alignment or fonts or size, just content.

A good set of text editors for beginners are
[Atom](https://atom.io/),
[Sublime Text](https://www.sublimetext.com/) and
[VisualStudio Code](https://code.visualstudio.com/). All of which have
additional plugins/packages for working with Ruby that are recommended for this
course. If you are more of an IDE person, InteliJ makes an excelent IDE for Ruby
called [Ruby Mine](https://www.jetbrains.com/ruby/).

A text editor is like a religion to a programmer, so depending on why you ask
you will get a different answer which one is best. My suggestion it to pick
one that you are most comfortable with. If you end up not liking it, jsut
switch to another one.

## Ruby runtime

Finally we get to install Ruby!

So what is a runtime and why do we need it to run Ruby programs?
There are many different kinds of programming languages, Ruby falls into the
category of a dynamically typed - interpreted language.

This means that your processor doesn't understand Ruby code directly, and Ruby
code never gets compiled to ones and zeroes. Instead we install a piece of
software called the virtual machine or runtime which reads our program
line-by-line and interprets the instructions we wrote in Ruby for the processor
to execute.

The opposite of this approach is a compiled language (e.g. C or Rust)
where we write our code first, then we give it to a compiler which translates it
into zeroes and ones which the processor understands. The upside of this
approach is speed. A compiled program will always be faster then an interpreted
one. But the downside is portability, meaning a compiled program will only work
on computers with the same processor and has to be recompiled for all other
computers. Interpreted laguages circumvent this issue by compiling only the
runtime for each computer, so that your program doesn't have to.

At the time of writing the newest version of Ruby is 2.5.
Ruby has many versions, to install and manage them we are going to install a
program called `rbenv` which, as the name suggests, is a Ruby environment
manager.

Before we continue, some Linux distributions and all MacOS distributions come
with Ruby pre-installed. You can open up a terminal and type in `ruby -v` to
check if you have it already installed (if it errors, you don't, else you do).
If you do, follow these instructions anyway as working with your system
installation of Ruby may cause subtle issues.

![Result of running ruby -v](./images/terminal-ruby_v.png)

