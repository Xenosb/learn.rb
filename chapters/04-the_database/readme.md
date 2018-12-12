# Working with databases, or how to remember stuff

## Chapters

1. [Introduction](#introduction)
2. [The model](#the-model)
    * [Representing state](#representing-state)
    * [Types](#types)
    * [Attributes](#attributes)
    * [Validation](#validation)
    * [Creating](#creating)
    * [Updating](#updating)
    * [Deleting](#deleting)
3. [Migrations](#migrations)
    * [A history of changes](#a-history-of-changes)

## Introduction

When working with web applications, or any other application for that matter,
we will need a way to store and retrieve data. Looking back at our first
example, the Employee-o-matic 4000, all our applications lost all the data
we entered into them upon restart. This happened because we stored that data
in the memory of the process / application. In simple words, we were using
your computer's RAM to store the data, and as soon as the Ruby process stopped
your computer freed the RAM and thus the data was lost.

There are many ways to store data on the file system, but we are going to focus
only on so-called "relational database systems" - also known as SQL databases.
Of all available SQL databases we will only look at two - SQLite and Postgres.

SQLite is the system we used in the last couple of lectures. It's the simplest
SQL database system there is. It stores everything in a single file. This
simplicity causes many complications, which won't be covered here, that makes
SQLite not suitable for real-world applications. But it's perfect for
testing and development!

## The model

Ruby on Rails implements an architecture known as Model, View, Controller.
In the previous chapters we focused mostly on Views and Controllers, in this
chapter we will focus on Models.

### Representing state

In an MVC (Model View Controller) architecture the Model represents the
application's state. That means it represents all entries for all kinds of data
there is, or at least that's persisted.

Relational database systems (RDB for short) store data in tables. Tables are
very much alike tables from your favorite office suite. They have rows, columns
and headers. By convention, columns represent individual fields of each record
we want to store, while rows represent a single record. This might be confusing
at first, so let me give a visual example.

```text
                    People
+------------+-----------+----------------------+
| First name | Last name |         Email        |
+------------+-----------+----------------------+
| Alice      | Cage      | alice.cage@gmail.com |
| Bob        | Ross      | bob.ross@ymail.com   |
| Clemens    | Smith     | clemence.smith@yn.ru |
| Dorian     | Gray      | dorian.gray@aol.com  |
+------------+-----------+----------------------+
```

In the table above, we store each person in a separate row while individual
fields associated with each person are stored in columns. E.g. The first row
represents the person Alice Cage with the email alice.cage@gmail.com.

To be able to show all the people we have in our database we need to create a
model for that table. A **instance** of a model represents a single row of the
table, in other words a single person or record. While a model **class**
represents the whole table. This will become important later on.

Models live in the `app/models` directory. If you navigate there now you will
see the author, comment and post models we created in the previous chapters.

If you open any of these models you will notice that the file is nearly empty.
To help us see the fields that our models hold we can use a tool called
`annotate`.

To install it run `gem install annotate`.

```bash
$ gem install annotate
Fetching: annotate-2.7.4.gem (100%)
Successfully installed annotate-2.7.4
1 gem installed
```

To use it, move to the root of your ruby_homework directory and run the
following

```bash
$ annotate
Annotated (9): app/models/author.rb, test/models/author_test.rb,
test/fixtures/authors.yml, app/models/comment.rb, test/models/comment_test.rb,
test/fixtures/comments.yml, app/models/post.rb, test/models/post_test.rb,
test/fixtures/posts.yml
```

If you now open any of your models it should have something similar to the
following at the start of the file.

```ruby
# == Schema Information
#
# Table name: posts
#
#  id         :integer          not null, primary key
#  author_id  :integer
#  content    :text
#  published  :boolean
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Post < ApplicationRecord
end
```

Annotate is a tool that copies information form the database over to the model
so that we can see it instead of having to remember it. The structure
is displayed as a comment at the beginning of the file starting with the
table name and followed by the table's columns. The column's data is grouped
into three columns - name, type, attributes. For now pay attention only to the
name and type, we will cover attributes later.

### Types

The most glaring thing here is the types column. In Ruby we don't have to think
about types. But a RDB isn't Ruby. When it comes to storing data, types are
advantageous! We as humans created types as an analogy to what we do in nature.
Take yourself as an example. Every time you clean or tidy your room you put
things of the same type together - socks go with socks, pants with pants,
papers with papers, ... You don't have to do that, but you do because it
makes your life easer later as you can quickly find something you are looking
for, and it would be confusing to find toothpaste between a few sheets of paper.
For all the same reasons, except the toothpaste part, most RDB systems use
types.

Most RDBs differentiate at least the following types - string (aka. varchar),
integer (whole number), float (decimal number), boolean (true / false value) and
text (very long string). Postgres additionally has
jsonb (indexable JSON fields), point (2D point), array (a list of values),
and many more, as well as the ability to create custom types.

Types enable us to convey meaning to the field. E.g. a if a field is named
"default" and its type is boolean we know it indicates if the record is the
default record, while in ruby we would have to name the field "default_record"
or "is_defualt" to convey the same meaning.

In most RDBs every field can only be it's specified tye or `NULL`. `NULL` is a
special value that represents the absence of data. It has all the same use-cases
as `nil` does in Ruby and it behaves much like `nil` in the sense that `NULL` is
basically the same as `false` in most cases.

### Attributes

Now let's cover attributes! In this course we will only use three attributes -
`not null`, `default` and `primary key`.

A `primary key` is the field by which
the whole row can be uniquely identified. In the people table from before the
primary key would be the `Email` field, as there can be multiple people sharing
the same first name or last name or both, but each person has an unique email
address which differentiates them from all others sharing the same name. In
Rails the default primary key is a column named `id` which is an integer that
starts at `1` and automatically (and only) increments with each record.

The `default` attribute set's the default column value if no value is set by the
user. E.g. if you create a model to represent your user you would need a way to
differentiate if the user is an admin or not. To do that you would add an
`admin` field/column to the user model and set it's default value to `false` so
that, if not otherwise specified, no user would accidentally become an admin.
Or, if you are a psychopath, you could set the default value for the first_name
column to "Garry" so that everybody that doesn't enter their name would become
"Garry".

Finally there is `not null` and it does exaclty what you think it does. It
prohibits a column to have the value `NULL` this is useful for storing
obligatory fields such as `email` because the database would refuse to store
a person without their email.

### Validation

When we specify that a column in the database is `not null` that validation is
handled by the database itself. The problem with this approach is that our
application will raise an exception if the user leaves a `non null` field empty.

Take for example the comments field we worked on in the previous chapter.
We don't want to allow users to post empty comments. To accomplish this we
need to add the `not null` attribute to it. The process to do this will be
covered later on, for argument's sake let's assume that we did that. If a user
posts an empty comment we wouldn't want to display them with an error screen,
it would be better to redirect them back to the form, mark the comment field
red and print the error under the field. To accomplish this we need to track
the errors the database returns. Rails can do that for us using the
`validates` method!

For our comments, it would be good not only to validate if some text is present
(because the user could submit an empty string), but also to validate the
length of the text the user entered. Let's say that a comment has to have at
least two letters. To accomplish this we can write the following.

```ruby
# == Schema Information
#
# Table name: comments
#
#  id         :integer          not null, primary key
#  post_id    :integer
#  author_id  :integer
#  content    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Comment < ApplicationRecord
  validates :content, presence: true, length: { minimum: 2 }
end
```

Now if we try to create a new comment and leave the content field empty we
should see the following.

![Validation error](./images/validation_error.png)

We get this kind of error handling for free by using simple form. Also, notice
that the content field got an astrix `*` next to it indicate the field is
mandatory.

The `validates` method expects the name of the column as the first argument
and as many validation conditions as you need. The full list of all
validations is available on
[guides.rubyonrails.org](https://guides.rubyonrails.org/active_record_validations.html#validation-helpers).

### Creating

Remember that earlier on we mentioned that there is a difference between an
instance of a model and the class of a model in respects to what they represent.
The instance represents a single row in a database table, while the class
represents the whole table.

Given the people table from before.

```text
                    People
+------------+-----------+----------------------+
| First name | Last name |         Email        |
+------------+-----------+----------------------+
| Alice      | Cage      | alice.cage@gmail.com |
| Bob        | Ross      | bob.ross@ymail.com   |
| Clemens    | Smith     | clemence.smith@yn.ru |
| Dorian     | Gray      | dorian.gray@aol.com  |
+------------+-----------+----------------------+
```

It would map to a model named `Person`. This is the convention in Ruby on Rails.
A model has the singular name of the table it represents, and in SQL databases
it's convention to always name tables in plural form. E.g. a table who's row
represents a person would be named `people`, and the corresponding model would
be named `person`. If you follow this convention Rails will handle everything
automatically for you. It's possible to stray away from this convention but then
many things have to be dialed in manually.

Let's say that we are given an empty `people` table.

```text
                    People
+------------+-----------+----------------------+
| First name | Last name |         Email        |
+------------+-----------+----------------------+
+------------+-----------+----------------------+
```

How are we supposed to create a new person? There are two ways to do this. The
more Ruby-like way is to simply create a new instance of the model using the
`new` method. So let's try that.

```ruby
person = Person.new
person.first_name = 'Alice'
person.last_name = 'Cage'
person.email = 'alice.cage@gmail.com'
```

If we would now look into our database we would see the following.

```text
                    People
+------------+-----------+----------------------+
| First name | Last name |         Email        |
+------------+-----------+----------------------+
+------------+-----------+----------------------+
```

What now!? But we create a new instance and gave it data! And we said that this
should work! Well, this is a kink of how RDBs work. RDBs handle data changes in
increments called transactions. Transactions which insert or update data are
really intensive on the database and therefore we want to have as few of them
as possible. Therefore Rails has the `save` method, which will save our
instance to the database. Let's try it.

```ruby
person = Person.new
person.first_name = 'Alice'
person.last_name = 'Cage'
person.email = 'alice.cage@gmail.com'
person.save # => true
```

And now our database looks like

```text
                    People
+------------+-----------+----------------------+
| First name | Last name |         Email        |
+------------+-----------+----------------------+
| Alice      | Cage      | alice.cage@gmail.com |
+------------+-----------+----------------------+
```

The `save` method can return either `true` or `false` depending on if the
transaction failed or not. A common reason for a transaction to fail would be
validations. If the `save` method would return `false` and we had a validation
that required all users to be named `Garry` (you psychopath) then our
`person` object's `error` attribute would have a value like the following

```
person.save # => false
person.errors # => #<ActiveModel::Errors:0x007fa35f4c72a0 @base=#<Person id: nil, first_name: 'Alice', last_name: 'Cage', email: 'alice.cage@gmail.com', created_at: nil, updated_at: nil>, @messages={:name=>["must be 'Garry'"]}, @details={:first_name=>[{:error=>:equal}]}>
```

It's good to note that there also exists a `valid?` method which returns `true`
or `false` depending on wether or not the record is valid. And it also sets the
`errors` attribute.

The other way of creating records is using the `create` method on the model.
This is the RDB way of doing things. Most RDBs use a language called SQL to
interact with them, and in it an insert is done by referencing the table where
you are inserting in the following manner.

```SQL
INSERT INTO people (first_name, last_name, email) VALUES ('Alice', 'Cage', 'alice.cage@gmail.com');
```

The important part here is the `INSERT INTO people`. To mimic this Rails
implements the `create` method as follows.

```ruby
Person.create(
  first_name: 'Alice',
  last_name: 'Cage',
  email: 'alice.cage@gmail.com'
)
```

To get the same error handling functionality we had with the `save` method the
`create` method returns an instance of the model. E.g.

```ruby
person = Person.create(
  first_name: 'Alice',
  last_name: 'Cage',
  email: 'alice.cage@gmail.com'
) # => #<Person id: nil, first_name: 'Alice', last_name: 'Cage', email: 'alice.cage@gmail.com', created_at: nil, inserted_at: nil>

person.errors # => #<ActiveModel::Errors:0x007fa35f4c72a0 @base=#<Person id: nil, first_name: 'Alice', last_name: 'Cage', email: 'alice.cage@gmail.com', created_at: nil, updated_at: nil>, @messages={:name=>["must be 'Garry'"]}, @details={:first_name=>[{:error=>:equal}]}>
```

The best part is that the `create` and `save` methods aren't exclusive! You
can mix and match them however you like.

```ruby
person = Person.create(
  first_name: 'Alice',
  last_name: 'Cage',
  email: 'alice.cage@gmail.com'
) # => #<Person id: nil, first_name: 'Alice', last_name: 'Cage', email: 'alice.cage@gmail.com', created_at: nil, inserted_at: nil>

person.errors # => #<ActiveModel::Errors:0x007fa35f4c72a0 @base=#<Person id: nil, first_name: 'Alice', last_name: 'Cage', email: 'alice.cage@gmail.com', created_at: nil, updated_at: nil>, @messages={:name=>["must be 'Garry'"]}, @details={:first_name=>[{:error=>:equal}]}>

person.first_name = 'Garry' # => #<Person id: nil, first_name: 'Garry', last_name: 'Cage', email: 'alice.cage@gmail.com', created_at: nil, inserted_at: nil>

person.save # => true
```

### Updating

Alice just called and invited us to her wedding! She is getting married to
someone surnamed Dent, we'll need to update our record in the database to
avoid embarrassing emails.

In Rails, updating a record can be done in two ways. Either by changing the
value of an attribute and calling `save` (as shown in the previous example) or
by calling the `update` method on the instance.

Since we are familiar with the first aproach let's take a look at the second.

```ruby
person = Person.create(
  first_name: 'Alice',
  last_name: 'Cage',
  email: 'alice.cage@gmail.com'
) # => #<Person id: nil, first_name: 'Alice', last_name: 'Cage', email: 'alice.cage@gmail.com', created_at: nil, inserted_at: nil>

person.errors # => #<ActiveModel::Errors:0x007fa35f4c72a0 @base=#<Person id: nil, first_name: 'Alice', last_name: 'Cage', email: 'alice.cage@gmail.com', created_at: nil, updated_at: nil>, @messages={:name=>["must be 'Garry'"]}, @details={:first_name=>[{:error=>:equal}]}>

person.update(first_name: 'Garry') # => true
```

The `update` method works quite similar to the `save` method, but it accepts
a hash with the desired attribute changes in it. When working with web
applications the `update` method is fare more practical as we can pass it the
params we received from the user, instead of having to iterate through all the
values and assign them to attributes individually.

### Deleting

Finally (pun intended) we need to cover deletion. In Rails, deletion is done
using the `destroy` method. Yes, a bit confusing - everybody expects delete, but
it's destroy. I expect that there is an interesting reason for this, but I'm not
aware of any rationale behind this decision.

The `destroy` method, much like the `save` and `update` method before it,
returns only true or false. And can be used in the following way.

```ruby
person.destroy # => true
```

## Migrations

### A history of changes
