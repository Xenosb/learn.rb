# Ruby, Ruby, Ruby! NaNaaNaNaaNaNaaaa

If you don't get the reference in the title just open
[this link](https://www.youtube.com/watch?v=qObzgUfCl28).

In the last chapters we focused mostly on setting up the environment to work
with Ruby and thought you the basics of Git. With that knowledge we can
work together and teach you Ruby through a practical project.

In this chapter we will teach you the basics of Ruby. We will start with loops
and ourself work up to objects and classes (if you didn't understand any of
these words, don't worry), mentioning important resources along the way.

## Syntax, loops and wizard hats

[Ruby](https://en.wikipedia.org/wiki/Ruby_(programming_language))
was designed back in 1992 by
[Yukihiro Matsumoto](https://en.wikipedia.org/wiki/Yukihiro_Matsumoto). His
primary goal with Ruby was developer happiness. Therefore, you will notice,
that most Ruby code looks like
[pseudo-code](https://en.wikipedia.org/wiki/Pseudocode) (iterative text
describing an algorithm), there are many methods built-in into Ruby that
you won't fund in most other languages and they will have more intuitive names
than in most other languages.

In the last chapter we created a `hello_world.rb` file containing a program that
prints a message of your choosing. Let's run it with `ruby hello_world.rb`
(note that you have to be in your terminal and in your homework directory from
last chapter). You should see your message on screen.

![Output of running hello_world.rb](./images/hello_world_rb.png)

Let's change that program to print put 'Ruby'.

```Ruby
puts 'Ruby'
```

If we run this program we will see the following output:

![Output of running puts Ruby](./images/ruby.png)

Now, let's try and print out the title of this chapter. A program that does that
might looks something like this

```Ruby
puts 'Ruby, Ruby, Ruby! NaNaaNaNaaNaNaaaa'
```

And it would certainly work

![Output of puts title](./images/puts_title.png)

Now, imagine your friend calls you, because they heard about your new program
and they need it for a class assignment, but they need it to print the word
'ruby' exactly 42 times. Can you help them?

With our current knowledge, the only way we can do it is by manually writing
'ruby' 39 more times which is not very helpful as it defeats the purpose of
writing a program. So let put our wizard/witch hats on and solve this issue.

To tackle this problem we will need a loop. Loops, as the name implies make
things run in a loop until we tell them to stop. This is perfect for our
problem!

Ruby supports many different kinds of loops - `while`, `each`, `times` and
`loop` each serving a different purpose. Let's inspect some of them.

A `while` loops until a given condition is met. Let's try to print all numbers
from 0 to 100 using it:

```ruby
i = 0
while i < 100 do
  puts i
  i += 1
end
```

![output of the while loop](./images/while.png)

There is a lot going on here, lets explain the things we haven't seen before.
In this example `i` is a variable, meaning that `i` holds a value we assign to
it. In Ruby you can declare a variable by writing any one word followed by an
equals sign and a value. So `i = 0` is declaring a variable named `i` and
setting it's value to `0`.

The `i += 1` is shorthand notation for `i = i + 1` meaning that `+=` will
increment the variable on the left side by the value on the right side, in this
case by `1`.

Finally there is the `do ... end` - this is called a block. A block is any
piece of code surrounded by `do` and `end`. When used with loops any code inside
the block will be executed on each iteration of the loop. In the above example,
the lock contains a call to the `puts` method and `i += 1`, this code will be
run as long as `i` is less than 100.

Now, lets take a look at `loop`. It loops indefinitely or until the program
stops (you can stop most terminal programs by pressing `Ctrl` and `C`).
There are only a few use-cases for this kind of loop and you will rarely see
it in the wild.

```
loop do
  puts 'Are we there yet?'
end
```

![Output of the loop](./images/loop.png)

A `loop` is the same as `while` with the condition `true`.

```ruby
while true do
  puts 'Are we there yet?'
end
```

The output of the while statement is the same as of the loop statement.

We will cover `each` later, so let's take a look at `times`. It loops exactly
the specified number of times - in that respect it's identical to our
while loop example, but you don't need to use a variable.

Let's see what a program using a loop might look like:

```Ruby
41.times do
  print 'Ruby, '
end
puts 'Ruby! NaNaaNaNaaNaNaaaa'
```

![Printing 42 Rubies](./images/42_rubies.png)

This is exactly the program our friend asked us to deliver! Great! But what is
that `print` method? `print` and `puts` are basically the same, the only
difference being that `print` doesn't move to a new line after it prints the
text while `puts` does.

E.g. three `puts` would do the following:

```ruby
puts 'Ruby'
puts 'Ruby'
puts 'Ruby'
```

![Output of multiple puts](./images/r_r_r.png)

While three `print` statements would do the following:

```ruby
print 'Ruby'
print 'Ruby'
print 'Ruby'
```

![Output of multiple prints](./images/rrr.png)

## Input required

With loops and print statements we can do a lot, but we can't interact with
the user. Inputs are important in programming! With inputs we gather data from
the user and inquiry their wishes, this helps us make more useful programs.

A more useful program would be a game! Let's make a guessing game!
In our game the computer thinks of a number between 0 and 100, and we try to
guess it. If our guess is too high or a too low the computer tells us that, if
we guessed the correct number the computer congratulates us and stops the game.

So, we have to loop until the user inputs the correct number, this is a good
candidate for a `while` loop

```ruby
number = rand(100)
guess = nil

puts 'Welcome to the guessing game!'

while guess != number do
  print 'Enter your guess: '
  guess = gets.to_i

  print "Your guess of #{guess} "

  if guess > number
    print 'is too hight'
  elsif guess < number
    print 'is too low'
  else
    print 'is exactly right! Congratulations!'
  end

  print "\n"
end
```

![Guessing game implemented in a while loop](./images/guess_while.png)

There are quite a few new things here. Let's go through them one-by-one.

Firs there's `number = rand(100)`, we already know that `number` is a variable,
but what is the `rand(100)`? `rand` is a method built-in into Ruby that
returns a random number between `0` and the number you give it. If you don't
give it a number it will return a random decimal number between `0` and `1`.

![Different ways of calling `rand`](./images/rand.png)

Ok, but what's going on here `guess = nil`? Again, we know that `guess` is a
variable, but what is `nil`. `nil`, otherwise known as `null` in other
languages represents the absence of data. `nil` is a powerful concept in
programming (that sometimes backfires, but that's a story for later), being able
to represent an absence of information is a information in its self helping us
to make sense of the user's inputs.

Let's give a tangible example. Let's say you are making a program that inquires
the user about their name and ID number. Some people might feel that giving
out their ID number is an invasion of their privacy and therefore it isn't
mandatory. Without `nil` we would have to find some number that represents
that no ID number exists, this might work for a while but would become
problematic over time. Let's say we chose `000000000` as our non-existent ID
number. Well, if you didn't know, Ramesses II (the ancient Egyptian pharaoh)
has a passport with the ID number `000000000` (this is a long, but true, story
you can research for your self). So even though Ramesses entered an ID number
our program would think he didn't, this is a problem. Therefore `nil` was
introduced to unambiguously represent no data.

Let's inspect our game further. What is `guess = gets.to_it`, again we know
that `guess` is a variable. That means that we are assigning `guess` the value
of `gets.to_i`, but what is that? `gets.to_i` are actually two methods!
In Ruby most method calls are done by putting a dot (`.`) between a value and
a method. So let's look at these two methods `gets` and `to_i`.

If we open the
[Ruby documentation about `gets`](https://ruby-doc.org/core-2.2.3/Kernel.html#method-i-gets)
we can see that all `gets` does is it returns a value the user enters into the
terminal (note that the user has to hit enter before the value is registered).

[The official Ruby documentation] (https://ruby-doc.org/) is a great resource
for learning and/or looking up unknown methods. You should reference it often
as it will teach you more than any other resource about how Ruby works and
what exists.

So `gets` returns the user's input, but what does `to_i` do? `to_i` converts the
user's input to a number. By default a user's input is a string of letters, or a
string for short. While strings can be compared for equality e.g.
`'ruby' == 'ruby'` is true and `'ruby' == 'Ruby'` is false, numbers represented
as strings can't be compared with real numbers. So we wouldn't be able to
compare `guess` with `number` because `guess` would be a string and `number` is
a number. Therefore we convert `guess` to a number using `to_i`. The name `to_i`
comes from the name 'integer', `to_i` converts a string to a whole number.

An analogous method for decimal number would be `to_f` which would convert a
string to a decimal number. Why is it `to_f` and not `to_d`? This has a
historical reason, in computer science a decimal is a so called 'fixed point'
number and has to be specified with two numbers e.g. decimal(8,2) - meaning that
such a decimal can store 8 digits before the decimal point and two digits
after the decimal point (so `3.14` would work, but `3.148` would become `3.15`
in such a decimal). The opposite of a fixed point number is a floating point
number. Floating point numbers can store any number of digits after the
decimal point but at the cost of precision. Decimal numbers store the exact
value entered, while floating point number approximate the stored number.
E.g. the number `3.1415926535897932384626433` would become
`3.141592653589793` when represented as a floating point number while it would
stay the same when represented with a decimal(1,25). Why do we use floating
point numbers then? Computers are much faster when working with floating point
numbers then with decimal numbers. A decimal number can be up to 20 times slower
to calculate than a floating point one, and most of the time we don't need
high precision. Basically, floating point numbers are good enough for most
use-cases.

Oh! I nearly missed the condition of the `while` loop `number != guess`!
What is the `!=`? `!=` is the opposite of `==` which means equals, so
`!=` means different from. We use `==` for equals because we said earlier that
`=` declares a variable, so we need a new equals symbol - `==`. In most
programming languages putting a bang `!` before any operator inverts it's
function, so `!=` is different and `!true` is `false`, etc.

Now, what is the `#{guess}` in the `print` statement
`print "Your guess of #{guess} "`? In Ruby, `#{}` is used to interpolate a
variable into a string. Basically instead of `#{guess}` the value of `guess`
gets printed into the string. But what if I want to write `#{guess}` and not
have it interpolated? Roby has you covered there, it differentiates two kinds
of strings. Strings quoted with `'` don't get interpolated and are taken "as is"
while strings quoted with `"` get interpolated. But what if you want to have
bot interpolated and non-interpolated values in the same string? You can
state that you don't want interpolation to happen by "escaping" the hashtag `#`
with a slash ` \ ` before it. E.g.

```
number = rand(42)
guess = gets.to_i

puts 'number: #{number} | guess: #{guess}'
puts "number: #{number} | guess: #{guess}"
puts "number: #{number} | guess: \#{guess}"
```

![Example of interpolated stings](./images/interpolation.png)

Let's look at the `if` statement now.

```ruby
if guess > number
  print 'is too hight'
elsif guess < number
  print 'is too low'
else
  print 'is exactly right! Congratulations!'
end
```

`if` statements enables us to any execute code conditionally. In other words,
"if this is true, do this". This `if` statements has an `elsif` statement in it.
`elsif` is short for `else if` meaning that any code in that block will be
executed only if the `if` statement didn't get executed and the condition
given to it is true. You can have as many `elsif` statements as you like, the
first one that's truthy (truthy means "it evaluates to true") will be executed
an no other. Finally there is `else`. It gets executed only if all previous `if`
and `elsif` statements were falsy.

Here `<` means that the left number is smaller than the right one, while `>`
means that the left number is larger than the right one. There are two
additional versions of these operators: `<=` and `>=` meaning less-or-equal and
greater-or-equal respectively.

It's important to know that to `if` statements `nil` is the same as `false` and
anything else is considered to be the same as `true`.
E.g.:

```ruby
if true
  puts "<3"
end

if 7
  puts "<3"
end

if false
  puts "</3"
end

if nil
  puts "</3"
end
```

This will only print two `<3` and no `</3` as both `nil` and `false` are falsy.
In Ruby only those values are falsy, everything else is truethy.

Ruby also provides a shorthand way to writ in-line `if` statements like this:

```ruby
print 'How much is 3 + 3? '
answer = gets.to_i

puts 'That is correct!' if answer == 6

puts 'Thank you.'
```

There is also a negative version of `if` called `unless` that is often used
to give semantic meaning to the code. E.g. the following

```ruby
puts 'Weolcome to the vote-o-mat 3000!'
print 'What is your age? '
age = gets.to_i

unless age >= 18
  puts 'You have to be at least 18 to cast a vote!'
  exit
end

print 'There are no candidates to vote for at the moment, try again later.'
```

this is the same as

```ruby
puts 'Weolcome to the vote-o-mat 3000!'
print 'What is your age? '
answer = gets.to_i

if answer < 18
  puts 'You have to be at least 18 to cast a vote!'
  exit
end

print 'There are no candidates to vote for at the moment, try again later.'
```
