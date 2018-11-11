# Talking to servers

This is the fourth chapter in a series of 10 of the
[learn.rb project](https://github.com/monorkin/learn.rb) whose goal is to teach
people Ruby with a focus on Ruby on Rails.

## Chapters

- [Talking to servers](#talking-to-servers)
  - [Chapters](#chapters)
  - [Introduction](#introduction)
  - [Inspecting the forms](#inspecting-the-forms)
  - [Solving equations](#solving-equations)
    - [Adding a controller](#adding-a-controller)
    - [Adding the routes](#adding-the-routes)
  - [Adding a view](#adding-a-view)
    - [Catching the data on server](#catching-the-data-on-server)
    - [Showing the result to user](#showing-the-result-to-user)
  - [Rubys' little helpers](#rubys-little-helpers)
    - [Form tag](#form-tag)
    - [Label and input](#label-and-input)
    - [Loops help](#loops-help)
  - [Adding comments to our posts](#adding-comments-to-our-posts)
  - [Making it simpler](#making-it-simpler)
  - [Assignment](#assignment)

## Introduction

The goal of this chapter is to teach you how to send data to the server and
how to turn that data into something useful.

In the last chapter we built a web page with authors, posts and comments. In
this chapter we will focus on creating posts and comments.

## Inspecting the forms

Let's get started! Start your Rails application from last time with `rails s`,
in the navigation, click on posts. You should see a screen like the following.

![Posts index](./images/posts.png)

At the bottom, you should see a button named "New Post", click on it and you
should be greeted with the following.

![New Post](./images/new_post.png)

If you now fill out that form and press "Create Post", the screen will flash and
you will be presented with the information you just entered on another screen,
on another URL.

![Show Post](./images/real_new_post.png)

How did we get that data from our browser to the server? This is the focus of
this chapter. Let's take a look at what our browser is doing. Go back to the
posts screen, and click on "New Post" again. Now fill out the form with
different data, right-click on any field and select "Inspect" or
"Inspect Element" from the drop down menu. You screen should split in half
either horizontally or vertically. This window is called the inspector.

![The inspector](./images/inspector.png)

You should see a couple of tabs at the top of the new window. One should be
"Network", select it. There should be a "Persist Logs" of "Preserve Logs"
check box, if it's unchecked, check it.

Now press "Create Post"!

The following should appear.

![Network tab on new Post](./images/new_post_network.png)

There should be a lot of entries in the network tab now. Scroll up until you
find one that begins with `POST`, click on it and your inspector should split
in half. In the new panel you should see data related to that particular
request. Here we can see exactly what our browser sent to our server when we
clicked "Create Post".

![Our post network request](./images/post_request_network.png)

If we now click on the "Params" tab. We can see which data was sent!

![Our post network request details](./images/post_request_details_network.png)

Here we can see all the data associated with our post. That data is prefixed
with `post` and the attributes name is within square brackets `[]`. There are
three additional fields - `authenticity_token`, `commit` and `utf8`. Of those
three `commit` is something the browser added by its self, while Rails added
`authenticity_token` and `utf8`. Those two fields are used to enhance the
security of our application - they protect us and our users from
malicious actors that try to steal or manipulate data. Let's ignore those
fields for now and focus on the `post[]` fields. This encoding is done by
the form it self.

Forms are used to gather a user's input, like text, numbers or files, and send
them to the server to be stored or processed. They are the most basic way to
talk to servers. In a later chapter we will learn about more ways in which
we can communicate with our server.

## Solving equations

Let's try to create our own form! We will make a form that solves second
degree polynomials.

Before we begin we need to know how to solve those polynomials! All second
degree polynomials follow this form `a * x^2 + b * x + c = d`. You may notice
that we can eliminate the `d` variable by moving it to the other side so that
we get `c - d` - which we can simply call `c` as it's just another variable.
The general solution to those kinds of problems is
`x = (-1 * b +- sqrt(b ^ 2 - 4 * a * c)) / (2 * a)`.

Ok. To solve those polynomials we need a view to gather 4 variables from
our user, we need a controller to process the data and another view to display
the result.

### Adding a controller

We'll start with the controller. Navigate to `app/controllers` and create a new
controller named `polynomials_controller.rb` with the following content.

```ruby
# app/controllers/polynomials_controller.rb

class PolynomialsController < ApplicationController
  def show
  end

  def new
  end

  def create
  end
end
```

This enables the controller to process three types of REST requests:

1. Show - A `GET` request to `/polynomials/4,3,2` that displays the result
2. New - A `GET` request to `/polynomials/new` that requests the user's input
3. Create - A `POST` request to `/polynomials` that submits the user's input to the server

Now, let's move to the `new` method and create it's view - in other words the
form that will gather the user's input. Create two new empty files at
`app/views/polynomials/new.html.erb` and `app/views/polynomials/show.html.erb`.

### Adding the routes

To be able to view what we did so far we need to create routes for our new
controller. Instead of using `resources` as we did in the last chapter, this
time we will create all routes by hand. Open the `config/routes.rb` file.
First, we will create the `show` REST method, for that we need a route that
responds to `GET` on `/polynomials` and ends with a id like `4,3,2` or
something similar.

The Rails router allows us to create routes that correspond to HTTP `GET`
methods by using the `get` method and passing it the name of the route we want
in addition with an indicator to the controller and method we want to call when
a request for this route comes in. Indicator have the following syntax -
`controller_name#method`, so in this case our indicator would be
`polynomials#show`. We also need a dynamic part in our path as we want to use
everything after `polynomials/` as an `id` of the polynomial. The rails router
allows us to specify dynamic parts by prefix the part's desired name with a
colon `:` - e.g. `polynomials/:id`.

To put it all together, our method call would be
`get 'polynomials/:id', to: 'polynomials#show'`

The router supports methods for all HTTP method types - `get`, `post`, `delete`,
`put` and `patch`. Using them we can create the remaining two methods:

* `get 'polynomials/new', to: 'polynomials#new'`
* `post 'polynomials', to: 'polynomials#create'`

Just be sure to define the `polynomials/new` route before the `polynomials/:id`
route as otherwise Rails will think that `new` is an `id` while visiting
`polynomials/new` and would always call the `show` method instead of the
`new` method.

```ruby
Rails.application.routes.draw do
  root 'landing#index'

  resources :comments
  resources :posts
  resources :authors

  get 'polynomials/new', to: 'polynomials#new'   # <-- WE ADDED
  get 'polynomials/:id', to: 'polynomials#show'  # <-- THESE
  post 'polynomials', to: 'polynomials#create'   # <-- LINES
end
```

## Adding a view

Now open the following URL in your browser
`http://localhost:3000/polynomials/new` and you should be greeted with a blank
screen.

![Blank new polynomial screen](./images/new_polynomial_1.png)

Let's change this! Open up `app/views/polynomials/new.html.erb`.

First let's create a large title using the `<h1>` tag. There are many header
tags raging from `h1` to `h7` - 1 is the biggest one and 7 is the smallest.
Our header tag should look like `<h1>Solve a polynomial!</h1>`.

Now we need a form! In the last chapter we saw that Rails provides shorthand
methods for creating forms. We won't use them here as they're mostly useful
when working with models - this will be covered in a later chapter.

To create our form we will use the `form` tag and set it's `action` attribute
to our `create` method's route - `/polynomials`, and set it's `method`
attribute to `POST`.

```html
<h1>Solve a polynomial!</h1>

<form action="/polynomials" method="POST">

</form>
```

But we are missing a way to submit our form. For this we just need to add a
button like the following `<button type="submit">Solve!</button>` into the form.

```html
<h1>Solve a polynomial!</h1>

<form action="/polynomials" method="POST">
  <button type="submit">Solve!</button>
</form>
```

Now we need to create inputs for our variables. We can use the `input` tag for
this! Every input has to have a `name` attribute by which the server can read
the value, and a `type` attribute which tells your browser how to render the
input. So a variable input may look like the following
`<input type="number" name="a" \>`. Since we specified that the value of the
input is a number, the browser will automatically validate that the entered
value is a number and show an appropriate message if it isn't.

```html
<h1>Solve a polynomial!</h1>

<form action="/polynomials">
  <p>a * X^2 + b * X + c = d</p>

  <p>
    <label for="a">a:</label>
    <input type="number" name="a" \>
  </p>
  <p>
    <label for="b">b:</label>
    <input type="number" name="b" \>
  </p>
  <p>
    <label for="c">c:</label>
    <input type="number" name="c" \>
  </p>
  <p>
    <label for="d">d:</label>
    <input type="number" name="d" \>
  </p>

  <button type="submit">Solve!</button>
</form>
```

![Polynomial input field](./images/new_polynomial_3.png)

But if we enter some number and press the submit button we get an error!?

![Polynomial errors on submission](./images/new_polynomial_4.png)

Remember the two additional fields that Rails added to our form? Well, we
are missing the as we created our form by hand. Specifically, this error is
raised because we are missing the `authenticity_token` input. While we could
just add it it wouldn't solve our problem as rails expects it to be set to
a predetermined random value, we simply don't know. But! We can use Rails to
add it to our form auto-magically by calling `<%= form_authenticity_token %>`.
So we can add `<input name="authenticity_token" type="hidden" value="<%= form_authenticity_token %>" \>`
to our form to solve this issue. Here we used the `hidden` field type as we
don't want the user to see it or to interact with it. We used the `value`
attribute to pre-set the input's value to our authenticity token.

```erb
<h1>Solve a polynomial!</h1>

<form action="/polynomials" method="POST">
  <p><b>a</b> * X<sup>2</sup> + <b>b</b> * X + <b>c</b> = <b>d</b></p>

  <p>
    <label for="a">a:</label>
    <input type="number" name="a" \>
  </p>
  <p>
    <label for="b">b:</label>
    <input type="number" name="b" \>
  </p>
  <p>
    <label for="c">c:</label>
    <input type="number" name="c" \>
  </p>
  <p>
    <label for="d">d:</label>
    <input type="number" name="d" \>
  </p>

  <input name="authenticity_token" type="hidden" value="<%= form_authenticity_token %>" \>

  <button type="submit">Solve!</button>
</form>
```

And that's it! We made a form completely from scratch! If you are still
interested as to why we need the `authenticity_token` input and why
it has to be a specific value you can read into it by searching for
Cross Site Request Forgery, or CSRF for short.

### Catching the data on server

Let's now go back to the controller and use the data that we sent via the form.
To access data sent to the server we use the `params` object which is
present in all Rails controllers. It looks and feels much like a regular hash
but has additional features that we will cover in the next chapter. For
now we can think of it and use it just like a hash.

We could implement the solution finding algorithm in the following manner:

```ruby
def create
  a = params[:a].to_i
  b = params[:b].to_i
  c = params[:c].to_i
  d = params[:d].to_i

  solution = solve(a, b, c, d)
  solution = Marshal.dump(solution)
  solution = Base64.encode64(solution)

  redirect_to "/polynomials/#{solution}"
end

def solve(a, b, c, d)
  require 'cmath'

  a = a.to_r
  b = b.to_r
  c = (c - d).to_r

  first = -1 * b
  second = CMath.sqrt(b**2 - 4 * a * c) / (2 * a)

  [first - second, first + second]
end
```

There are a few tricky parts here. First is the `to_r` it converts any number
to a rational number this is important because second degree polynomials have
solutions with imaginary components. Then there is `CMath` it allows us to
find imaginary roots of numbers, the regular `Math` root method throws an
error if the input is negative. Finally there is `redirect_to` which you saw
in the previous chapter. It redirects the user to the show page with the
solution. But our solution is an array of two imaginary numbers! The
browser can't understand that, therefor we use `Marshall` and `Base64`
to convert it to a `String` the browser understands. `Marshall` converts Ruby
objects to a compact binary-format or in layman's terms - to ones and zeroes.
While `Base64` converts the ones and zeroes to letters.

### Showing the result to user

Now we have to do the same, but in reverse, in the show method to get the
solutions out of the id.

```ruby
def show
  @solution = params[:id]
  @solution = Base64.decode64(@solution)
  @solution = Marshal.restore(@solution)
end
```

Notice that we used an instance variable. We learned in the last chapter that,
using them, we can pass values from the controller into the view.

Finally we can do the show view:

```html
<h1>The solutions!</h1>

<h2>1. <%= @solution.first %></h2>
<h2>2. <%= @solution.last %></h2>
```

![Polynomial submission](./images/new_polynomial_5.png)

It only prints out the first and the second solution to the problem. Nothing
to write home about. But with this we have a fully functioning polynomial
solution finder written completely by hand! This was a learning experience, but
we still have open questions! Why did Rails prefix the input's names with `post`
, in our original example all the way at the beginning,
and put the real name in brackets?

Ha! Rails does something very cool here, it builds a sub-hash. A form can
contain many different inputs for many different contexts, not to mix them up
we can put them in sub-hashes. E.g.:

```html
<form action="/buildings" method="POST">
  <p>
    <label for="manager[name]">Manager name:</label>
    <input type="text" name="manager[name]" \>
  </p>
  <p>
    <label for="manager[phone]">Manager phone:</label>
    <input type="text" name="manager[phone]" \>
  </p>
  <p>
    <label for="building[address]">Building address</label>
    <input type="text" name="building[address]" \>
  </p>
  <p>
    <label for="building[name]">Building name</label>
    <input type="text" name="building[name]" \>
  </p>

  <input name="authenticity_token" type="hidden" value="<%= form_authenticity_token %>" \>

  <button type="submit">Save!</button>
</form>
```

Would give us the following `params` object:

```ruby
{
  manager: {
    name: "John Doe",
    phone: "+112345678"
  },
  building: {
    address: "1 Somewhere St., 00000 Somewheresville, Somewhere",
    name: "ACME Corp Headquarters"
  }
}
```

We can also store arrays in a similar manner. By using empty brackets `[]` we
tell Rails that we want duplicates to be handled like members of an `Array`.
Otherwise if multiple fields with the same name are sent to the server only the
last will be used.

```html
<form action="/competitions" method="POST">
  <p>
    <label for="participant[name][]">1st place:</label>
    <input type="text" name="participant[name][]" \>
  </p>
  <p>
    <label for="participant[name][]">2nd place:</label>
    <input type="text" name="participant[name][]" \>
  </p>
  <p>
    <label for="participant[name][]">3rd place:</label>
    <input type="text" name="participant[name][]" \>
  </p>

  <input name="authenticity_token" type="hidden" value="<%= form_authenticity_token %>" \>

  <button type="submit">Save!</button>
</form>
```

Gives us the following `params` object:

```ruby
{
  participant: {
    name: [
      "Alice",
      "Bob",
      "Clay"
    ]
  }
}
```

Arrays in params are most useful when working with multiple images, say in an
application that has a gallery. Instead of forcing the user to upload an image
one-by-one, we can allow the user to select all the images they want and upload
them all at once.

## Rubys' little helpers

But creating forms by hand is tedious, therefore Rails provides helper methods
for them. Let's now rewrite our form using Rails' form helpers.

### Form tag

First, let's create a form. To do that we have to replace our `<form>` tag with
a Rails `<%= form_tag %>`. For our polynomial example the form tag would be
`<%= form_tag "/polynomials", method: :post %>`. This looks quite similar to our
previous solution, but the `form_tag` gets expanded to
`<form accept-charset="UTF-8" action="/polynomials" method="post">`. We could
do our whole form inside that tag. E.g.:

```html
<h1>Solve a polynomial!</h1>

<%= form_tag "/polynomials", method: :post do %>
  <p><b>a</b> * X<sup>2</sup> + <b>b</b> * X + <b>c</b> = <b>d</b></p>

  <p>
    <label for="a">a:</label>
    <input type="number" name="a" \>
  </p>
  <p>
    <label for="b">b:</label>
    <input type="number" name="b" \>
  </p>
  <p>
    <label for="c">c:</label>
    <input type="number" name="c" \>
  </p>
  <p>
    <label for="d">d:</label>
    <input type="number" name="d" \>
  </p>

  <input name="authenticity_token" type="hidden" value="<%= form_authenticity_token %>" \>

  <button type="submit">Solve!</button>
<% end %>
```

### Label and input

But that wouldn't solve any problem or make things easier. Next, we will use the
`label_tag` and `number_field` to replace out HTML `label` and `input` tags.
Here we start to see some usefulness in using Rails helpers as they start to
provide more context and semantic value to what we are doing.

When we use a `form_tag` we don't have to add an `authenticity_token` input
manually, Rails does that for us.

```html
<h1>Solve a polynomial!</h1>

<%= form_tag "/polynomials", method: :post do %>
  <p><b>a</b> * X<sup>2</sup> + <b>b</b> * X + <b>c</b> = <b>d</b></p>

  <p>
    <%= label_tag(:a, 'a:') %>
    <%= number_field :a %>
  </p>
  <p>
    <%= label_tag(:b, 'b:') %>
    <%= number_field :b %>
  </p>
  <p>
    <%= label_tag(:c, 'c:') %>
    <%= number_field :c %>
  </p>
  <p>
    <%= label_tag(:d, 'd:') %>
    <%= number_field :d %>
  </p>

  <button type="submit">Solve!</button>
<% end %>
```

### Loops help

Now we can combine these helpers with our knowledge from previous lectures and
use a loop! That way we don't have to repeat our selfs four times to create this
form.

```html
<h1>Solve a polynomial!</h1>

<%= form_tag "/polynomials", method: :post do %>
  <p><b>a</b> * X<sup>2</sup> + <b>b</b> * X + <b>c</b> = <b>d</b></p>

  <% [:a, :b, :c, :d].each do |param| %>
    <p>
      <%= label_tag(param, "#{param}:") %>
      <%= number_field nil, param %>
    </p>
  <% end %>

  <button type="submit">Solve!</button>
<% end %>
```

This is now much cleaner! and it still works!
But we have ways of creating forms in an even easier manner!

## Adding comments to our posts

Now, let's add the ability to add comments to our posts! We could do use
Rails' form tags and  helpers to accomplish this:

```html
<h1>Post a comment:</h1>

<%= form_tag "/comments", method: :post do %>
  <%= hidden_tag(param, "#{param}:") %>

  <p>
    <%= label_tag(:content, "Comment:") %>
    <%= text_area_tag(:content) %>
  </p>

  <button type="submit">Solve!</button>
<% end %>
```

But there is a better way. When working with models, something that will be
covered in the next chapter, we can use additional helpers which respect the
context of the model. Meaning, if we want a `text_area` for the Comment's
`content` attribute we could just ask the form for a `text_area` and it would
infer that it's for our Comment.

To tap into this we need to change our form a little bit, instead of a
`form_tag` we are going to use `form_for`. Instead of an URL it accepts an
instance of a model and outputs a form builder,
like so `<%= form_for Comment.new do |form_builder| %>`. Now our form is
aware of the `Comment.new` context and all tags created with it will
automatically be in the context of and bear attribute names of the `Comment`.
E.g.:

```html
<%= form_for Comment.new do |f| %>
  <%= f.text_area :content, size: '60x10' %>
  <%= f.submit 'Post' %>
<% end %>
```

If we now add this snippet at the bottom of the Post's show page, we can create
comments from that page.

```html
<p id="notice"><%= notice %></p>

<p>
  <strong>Author:</strong>
  <%= @post.author_id %>
</p>

<p>
  <strong>Content:</strong>
  <%= @post.content %>
</p>

<p>
  <strong>Published:</strong>
  <%= @post.published %>
</p>

<p>
  <strong>Comments:</strong>
</p>

<p>
  <br />
  <strong>Post a comment:</strong>
  <%= form_for Comment.new do |f| %>
    <%= f.text_area :content, size: '60x10' %>
    <%= f.submit 'Post' %>
  <% end %>
</p>

<%= link_to 'Edit', edit_post_path(@post) %> |
<%= link_to 'Back', posts_path %>
```

![Comment input with form_for](./images/comment_1.png)

This is petty neat! If you click on post it will really create a comment
and show it to you. Now we have the ability to create arbitrary inputs for our
data types. But, as said, more on that in the next chapter.

![Created Comment](./images/comment_2.png)

## Making it simpler

Before we go on, we need to cover an even simpler method of creating forms for
models - through the help of a Gem called `simple_form`. You've installed this
gem in the previous chapter and therefore don't have to do it now.

With simple form we get the best of both worlds. We can use form builders to
be aware of the Model's context while still being able to just create HTML-like
inputs and not care about the attribute type. In other words we can just use
one tag `input` and it will infer the attribute type and input type form the
model we passed to it. E.g. the above example can be written like this using
simple_form:

```html
<%= simple_form_for Comment.new do |f| %>
  <%= f.input :content %>
  <%= f.button :submit %>
<% end %>
```

![Comment input with simple_form](./images/comment_3.png)

Notice that we didn't specify any type at all, yet if we render this view we
will see that not only did we get a text area but everything looks much nicer
than the previous solution. Simple form integrates with many CSS frameworks,
such as Bootstrap, which we installed in the last chapter. From that it
automatically applies everything necessary for our form to seamlessly integrate
with Bootstrap.

## Assignment

1. Do all the steps in the chapter by yourself.
2. In the comments creation form, on the posts show page, add a captcha.
  - The captcha should consist of a simple equation with the form
    `x + y - z = n`, where n is randomly chosen between 100 and 999.
  - All fields of the captcha should be sent to the server as a sub-hash named
    `captcha`
  - The server chooses the value of `n` and stores it in a hidden field in the
    form
  - All parameters should be positive integers different from zero
  - If the `x + y - z` aren't equal to `n` or if any parameter doesn't
    conform to the specified rules, redirect the user back, using
    `redirect_to :back` and display a validation error using a
    [flash notice](https://api.rubyonrails.org/classes/ActionDispatch/Flash.html)
  - If you don't know what a captcha is or why it's useful check out
    the [Wikipedia article](https://en.wikipedia.org/wiki/CAPTCHA)
