# Working with databases, or how to remember stuff

## Chapters

- [Working with databases, or how to remember stuff](#working-with-databases-or-how-to-remember-stuff)
  - [Chapters](#chapters)
  - [Introduction](#introduction)
  - [The model](#the-model)
    - [Representing state](#representing-state)
    - [Types](#types)
    - [Attributes](#attributes)
    - [Validation](#validation)
    - [Creating](#creating)
    - [Updating](#updating)
    - [Deleting](#deleting)
  - [Migrations](#migrations)
    - [A history of changes](#a-history-of-changes)
    - [Create](#create)
    - [Update](#update)
    - [Destroy](#destroy)
    - [Reversibility](#reversibility)
  - [Associations](#associations)
    - [One to one](#one-to-one)
      - [belongs_to](#belongsto)
      - [references](#references)
      - [has_one](#hasone)
    - [One to many](#one-to-many)
    - [Many to may](#many-to-may)
  - [Querying](#querying)
    - [Find & find_by](#find--findby)
    - [All & where](#all--where)
    - [Join](#join)
    - [Order](#order)
  - [Indices](#indices)
  - [Assignment](#assignment)

## Introduction

In the last chapter we learned how to talk to send data to the server via forms.
In this chapter we will save the received data in an organized manner and
display it back to the user.

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
SQL database system there is. It stores everything in a single file. If you are
curious, the data you entered during your last homework is stored in
`db/development.sqlite3`. Feel free to take a look. This simplicity causes many
complications, which won't be covered here, that make SQLite not suitable for
real-world applications. But it's perfect for testing and development!

The database is a computer program which takes care of storing data for you. It
usually runs in the background and listens to incoming requests,
same as your Rails server. This kind of program is called a service.

To access, store, update or delete data from the database, we send a query to
it and wait for a response. Queries are
written in a language called Structured Query Language (SQL) which can vary
slightly from one database to another.

SQL is intended to be semantically similar to human languages. In the following
example we ask the database to return the first name for an author with the last
name "Huxley".

```sql
SELECT first_name
FROM authors
WHERE last_name = 'Huxley'
```

But we don't need to know SQL to work with Rails as it provides other ways for
us to access the data in our database - through pure Ruby. But always be aware
that underneath all that we are going to learn today there is SQL and all
Rails does is provide a prettier way for us to interact with the database.

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

We covered how to Create, Update and Destroy records in our database tables
through the use of models. But how do we create tables in our database? In Rails
we create, modify and destroy tables through migrations.

The word migration is an odd choice for something that manipulates your
database. The creators of Rails thought of the database in term of it's schema.
A database schema is much like a blueprint that contains all the plans for how
your tables should look like. A schema is not a physical thing, it doesn't
exist per se, but it's a concept or idea of how to describe your database. So
a migration moves the old concept of your database to the new one.

By now you have created a few migrations just by following the last
chapters. You can view all your migrations by navigating to `app/db/migrate` you
should have three files in this directory.

All migration files follow this naming scheme:

```text
20181028160427_create_authors.rb
```

Basically it's a bunch of numbers followed by a human readable name. The numbers
represent the time the file was created. If you look carefully you will notice
that the format of the numbers is `YYYYMMDDHHmmSS` where `Y` is the current
year, `M` is the current month, `D` is the current day, `H` the hour, `m` the
minute and `S` the second. And the human readable part is just something
descriptive about what the migration does to your database. While confusing,
this naming convention is quite helpful when working with others.

You can apply all your migrations to the database by running

```bash
rails db:migrate
```

This will go through your migrations, find any that haven't yet been applied
yo your database and apply them.

### A history of changes

Unlike any other code, we will never change or delete migration files. We will
only ever create new ones.

Your migration files represent the history of your database, or at least the
changes it went through. And, as with any good time-travel movie, history should
never change for it could cause unforeseen consequences.

If we ever want to change something we already migrated, we would create a new
migration that applies our desired change. This might not always be easy, but
it will always be consistent.

### Create

We can create a new migration by executing one of the following commands
in our shell.

```bash
rails g migration create_sub_reddit
```

This kind of migration creation is mostly used for updating the schema, so it
will be covered in the next chapter.

The other way to create a migration is through creating a model. As we stated
before, a model represents a table in our database. So by creating one, Rails
will create a migration that creates the table.

```bash
rails g model sub_reddit title:string description:text private:boolean owner_id:integer
```

The first argument is the name of the model, it can either be in singular or
in plural, all other arguments are names of the columns the table should have
separated from their type by a colon `:`.

This command will do quite a lot. It will create a migration, a model, and a few
other files we will cover later.

Let's take a look at the generated migration.

```ruby
class CreateSubReddit < ActiveRecord::Migration[5.2]
  def change
    create_table :sub_reddits do |t|
      t.integer :owner_id
      t.text :description
      t.text :title
      t.boolean :private

      t.timestamps
    end
  end
end
```

It generated a file containing a single class with the method `change` in it.
Inside the `change` method, the `create_table` method is called with a
symbol `:posts` and a block of code. The symbol is the name of the table we
want to create, while the block of code defines the table's columns.

We can change the block of code to add any attributes we would like. Let's
make the default `private` value `false` and prohibit it from being `null`.
As it makes sense for that field to be unambiguous, it should be
either `true` or `false` and it should be `false` be default as we want engage
people to create public sub reddits.

```ruby
class CreateSubReddit < ActiveRecord::Migration[5.2]
  def change
    create_table :sub_reddits do |t|
      t.integer :owner_id
      t.text :description
      t.text :title
      t.boolean :private, null: false, default: false

      t.timestamps
    end
  end
end
```

We could also prohibit that the `owner_id` column is nullable as well as the
`description` and `title` columns. Those two fields should always be entered as
it doesn't make sense to have a sub reddit without a title, description or
owner.

```ruby
class CreateSubReddit < ActiveRecord::Migration[5.2]
  def change
    create_table :sub_reddits do |t|
      t.integer :owner_id, null: false
      t.text :description, null: false
      t.text :title, null: false
      t.boolean :private, null: false, default: false

      t.timestamps
    end
  end
end
```

Now you can run `rails db:migrate` to apply these changes to your databse
and enjoy your new SubReddit model.

### Update

Now that we have sub reddits we must update our `Post` model to belong to a
sub reddit.

As stated before, for updates (and destroys) we use the following style of
migrations.

```bash
rails g migration change_posts
```

Running this will create a new migration with the given description, though
it's change method would be completely empty.

```ruby
class ChangePosts < ActiveRecord::Migration[5.2]
  def change
  end
end
```

This is often times useful for big changes, but for small changes Rails
provides magic that can make this even easer.

So, we want to add a `sub_reddit_id` column to our `posts` tabel. If we name
our migration `add_sub_reddit_id_to_posts` and pass it `sub_reddit_id:integer`,
we would get the following migration.

```ruby
class AddSubRedditIdToPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :sub_reddit_id, :integer
  end
end
```

This is handy when you just want to add a couple of columns to a table.
The magic quickly goes away when you learn that Rails is only checking if the
migration description ends with `to_<table_name>` and starts with `add` to
do this. But hey! It still works!

There are many methods for manipulating your schema through migrations,
a full list can be found
[here](https://edgeguides.rubyonrails.org/active_record_migrations.html#writing-a-migration).

We will mostly use `add_column` to add columns, `change_column` to add or remove
attributes, and `rename_column` to rename them.

While on the topic. We can also add a title to our posts

```bash
rails g migration add_title_to_posts title:string
```

it has to be different from `nil`

```ruby
class AddTitleToPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :title, :string, null: false, default: ''
  end
end
```

### Destroy

We can also destroy tables as well as columns in the same way we update them.

We won't really need the `Author` model of this course any more, so let's
destroy it.

First, we need to delete the model file in `app/models/author.rb`.
Then we must create a migration to destroy the `authors` table in the database.

Before we continue, there is an oddity that we have to clear up. When working
with the database destructive actions are often called `DROP`. E.g. instead
"I'm going to delete the authors table" you would say "I'm going to drop the
authors table". This stems from the keyword for deleting tables and column in
SQL which is `DROP`. E.g. a pure SQL delete table would be
`DROP TABLE authors;`. Why is it called drop and not delete? At the time of
creation of the SQL standard it made sense, and the `DELETE` keyword is used
to delete rows so perhaps a difference wanted to be made - so that you don't
accidentally delete your table instead of a single row.

Anyway, back to our migration

```bash
rails g migration drop_authors
```

produces

```ruby
class DropAuthors < ActiveRecord::Migration[5.2]
  def change
  end
end
```

But it's empty! Sadly, Rails can't do all the work for us here. To drop a
table we need to use the `drop_table` method. Oddly enough to drop a column
we would use the `remove_column` method.

```ruby
class DropAuthors < ActiveRecord::Migration[5.2]
  def change
    drop_table :authors
  end
end
```

We are going to create a new user model in it's place

```bash
rails g model user email:string username:string
```

```ruby
class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :username, null: false

      t.timestamps
    end
  end
end
```

### Reversibility

If you ever screw something up in the latest migration you did you can most of
the times undo it with `rake db:rollback`.

A rollback simply undoes what was done in the previous migration. Though it might
not always be able to do so. Most often `drop_table` and `change_column`
migrations aren't revisable as there is no way for the program to know what
the table looked like before the applied change. It's able to reverse
create and rename actions because the inverse of a create is destroy so nothing
is left, and a rename contains both the old and the new name in it's arguments.
But destroy and change contain only the new state of the table.

To avoid irreversible migrations we can define two methods instead of a
single `change` method in our migration. Those methods are `up` and `down`.

`up` will be called when the migration is being applied. So it contains all the
changes you would like to apply to your database.

While `down` will be called when the migration is rolled back. It contains all
the changes needed to undo the change from the `up` method.

In the case of our `drop_authors` migration we would need to recreate the whole
authors table. Else we would get the following error while trying to rollback
the last migration.

```text
$ rake db:rollback
== 20181217081752 DropAuthors: reverting ======================================
rake aborted!
StandardError: An error has occurred, this and all later migrations canceled:



To avoid mistakes, drop_table is only reversible if given options or a block (can be empty).

/Users/stanko/Documents/learn.rb/chapters/04-the_database/solutions/ruby_homework/db/migrate/20181217081752_drop_authors.rb:3:in `change'

Caused by:
ActiveRecord::IrreversibleMigration:

To avoid mistakes, drop_table is only reversible if given options or a block (can be empty).

/Users/stanko/Documents/learn.rb/chapters/04-the_database/solutions/ruby_homework/db/migrate/20181217081752_drop_authors.rb:3:in `change'
Tasks: TOP => db:rollback
(See full trace by running task with --trace)
```

But if we rename the `change` method to `up` and add the following `down` method

```ruby
class DropAuthors < ActiveRecord::Migration[5.2]
  def up
    drop_table :authors
  end

  def down
    create_table :authors do |t|
      t.string :email
      t.string :alias
      t.datetime :date_of_birth

      t.timestamps
    end
  end
end
```

Then everything works as expected. Though note that everything isn't exactly
the same. The table may have the same schema, but it doesn't have the same
data. In other words, the rows of the authors table are lost. This is also
one reason why destructive actions aren't reversible.

It's incredibly important to have reversible migrations. If anything goes wrong
they enable you to simply roll back the changes you did, as if nothing happened.

## Associations

In Rails, associations are connections between two (or more) models.
They allow us to link records and access data more easily.

For example if a comment would have a reference to the post it was created for,
we could show the post's title through the comment with something like
`comment.post.title`.

This is a big quality of life improvement as otherwise we would need to fetch
the post manually somehow, while this way the comment can access it's post.

### One to one

The simplest association is a one-to-one association. This means that one record
points to __only__ one other record.

For instance, a post can have only one author. In other words this post belongs
to that author, therefore this kind of relation is commonly referred to as a
__belongs to__ relation.

#### belongs_to

To create such a relation we need to have a column on the first record
(e.g. comment) that will store the id of the record it belongs to (e.g. a post).

When we first created our Comment model it had a field `post_id` of type
integer. From the database's standpoint this is same as `belongs_to`, we can
store the posts's id in this column and we can tell the database to retrieve
the comment's post. But Rails still thinks that the `post_id` column is just an
integer, need to explain to it that the `post_id` column is actually an
association that points to a record in the posts table.

For this to happen we need to update our `Comment` model! We need to tell it
that it __belongs to__ a post. And, in Rails, this is quite intuitive - we
can simply add the following line `belongs_to :post`

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
  belongs_to :post # <--- This line here

  validates :content, presence: true, length: { minimum: 2 }
end
```

By the way, __if you haven't noticed we broke the website with all the
changes we made__. But don't worry __you can still check if things work through
the console__.

The following command has to be run from the root of your application, and it
will open an interactive console to your application. That means you can write
plain ruby and interact with your models and any other code we wrote.

```bash
rails c
```

Let's now create a Post and a Comment for it, then try to access the comment's
post and it's title.

```ruby
post = Post.create(title: "Foo Bar", content: "Test")
#<Post id: 1, author_id: nil, content: "Test", published: nil, created_at: "2018-12-19 10:02:13", updated_at: "2018-12-19 10:02:13", sub_reddit_id: nil, title: "Foo Bar">

comment = Comment.create(post: post, content: "Bla bla")
#<Comment id: 1, post_id: 1, author_id: nil, content: "Bla bla", created_at: "2018-12-19 10:03:09", updated_at: "2018-12-19 10:03:09">

comment.post
#<Post id: 1, author_id: nil, content: "Test", published: nil, created_at: "2018-12-19 10:02:13", updated_at: "2018-12-19 10:02:13", sub_reddit_id: nil, title: "Foo Bar">

comment.post.title
# "Foo Bar"
```

Note that this wouldn't work if we tried to do the same with the comment's
author.

```ruby
post = Post.create(title: "Foo Bar", content: "Test")
#<Post id: 1, author_id: nil, content: "Test", published: nil, created_at: "2018-12-19 10:02:13", updated_at: "2018-12-19 10:02:13", sub_reddit_id: nil, title: "Foo Bar">

author = User.create(email: "foo@bar.com", username: "me")
#<User id: 1, email: "foo@bar.com", username: "me", created_at: "2018-12-19 10:48:18", updated_at: "2018-12-19 10:48:18">

comment = Comment.create(author: author, post: post, content: "Bla bla")
# Traceback (most recent call last):
#         1: from (irb):3
# NameError (uninitialized constant Comment::Author)
```

This happens because Rails expects that each relation has a model with the
corresponding name. E.g. our Comment has a `belongs_to :post` so Rails looks
for the associated record in the posts table and tries to create a Post model
from it.

But the Author model doesn't exist any more! What now? We can instruct Rails
to use another model, by passing the `class_name: 'User'` argument to the
`belongs_to` method.

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
  belongs_to :post
  belongs_to :author, class_name: 'User' # <-- This

  validates :content, presence: true, length: { minimum: 2 }
end
```

That way Rails knows that we want to work with the User model and infers the
correct table and class from that. Just watch out that `class_name` __has to
be a string__!

#### References

But there is a downside to using simple integers for associations. If we would
delete the post, the comment would stay, that's not exactly what we want. This
leaves our database in an inconsistent state.

```ruby
post = Post.create(title: "Foo Bar", content: "Test")
#<Post id: 1, author_id: nil, content: "Test", published: nil, created_at: "2018-12-19 10:02:13", updated_at: "2018-12-19 10:02:13", sub_reddit_id: nil, title: "Foo Bar">

comment = Comment.create(post: post, content: "Bla bla")
#<Comment id: 1, post_id: 1, author_id: nil, content: "Bla bla", created_at: "2018-12-19 10:03:09", updated_at: "2018-12-19 10:03:09">

post.destroy
# true

comment.post
# nil
```

To solve this we have to migrate the post_id to be a type of reference.
In the underlying SQL a Rails reference is actually a foreign key. Each table
we have created so far has a primary key which is it's ID. If we want to tell
the database that it has to keep track of associations for us - that is prevent
deletion, or set the association's column value to `NULL` or delete the
associated rows - we need to mark that column as a foreign key. A foreign key is
a primary key of another table. In our app, a Comment's `post_id` is a
foreign key of the posts table.

Let's convert our Comment `_id` fields to references.

```bash
rails g migration convert_comment_association_fields_to_references
```

in the migration we will drop the old columns and create new 'reference' columns

```ruby
class ConvertCommentAssociationFieldsToReferences < ActiveRecord::Migration[5.2]
  def change
    remove_column :comments, :post_id
    add_reference :comments, :post,
                  foreign_key: { on_delete: :cascade }
    remove_column :comments, :author_id
    add_reference :comments, :author,
                  foreign_key: { to_table: :users, on_delete: :cascade }
  end
end
```

notice that for the author reference we had to specify the table for the
foreign key. Also notice the `on_delete` argument, it specifies what should
happen if the parent is deleted. There are a few options here, `:cascade` means
that is should the record should delete itself and all it's children. While
`:restrict` prohibits the deletion of the parent while there are any children
referencing it.


#### has_one

A different kind of one-to-one association is a one-to-one association. It
achieves the same as a belongs to association, but the instead of the model
with the ID of the parent having the association, the parent has it, allowing it
(only in Rails) to have only a single child.

This kind of association is hard to enforce through the database and is
therefore generally avoided. But it's important that you know it exists as it
is used to improve the performance of your application when things get too slow.

An example where this kind of association is useful would be in an accounting
application. There each payment can have only one receipt, and each receipt can
have only one payment. So not to confuse people with two belongs_to
associations that go in a circle (e.g. a receipt belongs to a payment and a
payment belongs to a receipt, ...) we would create a belongs to association
on either the payment or the receipt and create a has one on the other.

### One to many

A one-to-many association is required when one record can have many "child"
records.

In our application, a single post can have many comments. Intuitively Rails
uses the `has_many` method to describe these kinds of associations.

The best part of a has_many association is that we basically don't have to do
any modification to our database if the child uses the `belongs_to` method.

Let's update our post so that it can list it's comments.

```ruby
# == Schema Information
#
# Table name: posts
#
#  id            :integer          not null, primary key
#  author_id     :integer
#  content       :text
#  published     :boolean
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  sub_reddit_id :integer
#  title         :string           default(""), not null
#

class Post < ApplicationRecord
  has_many :comments
end
```

now if we again create an Author, a Post and a Comment

```ruby
post = Post.create(title: "Foo Bar", content: "Test")
author = User.create(email: "foo@bar.comh", username: "meh")
comment = Comment.create(author: author, post: post, content: "Bla bla")

post.comments
#<ActiveRecord::Associations::CollectionProxy [#<Comment id: 6, content: "Bla bla", created_at: "2018-12-19 11:38:46", updated_at: "2018-12-19 11:38:46", post_id: 7, author_id: 5>]>

post.comments.first.content
# "Bla bla"

post.comments.first.author.username
# "meh"
```

But, again, the same wouldn't work for the User model. If we added to it
`has_many :comments` it would error. This happens because, again, Rails
assumes that the child has a column named `<model name>_id`, and our comments
don't have a column named `user_id` - but they have a column named `author_id`.
Therefore we must instruct Rails to use that column. We do that with the
`foreign_key` option, like so `has_many :comments, foreign_key: 'author_id'`

```ruby
# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  email      :string           not null
#  username   :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class User < ApplicationRecord
  has_many :comments, foreign_key: 'author_id'

  validates :email, uniqueness: true, presence: true
  validates :username, uniqueness: true, presence: true
end
```

and now we can access the user's comments like normal

```ruby
author.comments
#<ActiveRecord::Associations::CollectionProxy [#<Comment id: 6, content: "Bla bla", created_at: "2018-12-19 11:38:46", updated_at: "2018-12-19 11:38:46", post_id: 7, author_id: 5>, #<Comment id: 7, content: "Bla bla", created_at: "2018-12-19 11:43:53", updated_at: "2018-12-19 11:43:53", post_id: 7, author_id: 5>]>
```

### Many to may

Finally there is the many-to-many association. They are easily explained through
real-world ownership. You own all the stuff in your house, but so do your
parents/guardians, but you siblings don't own your stuff.
That means that each object in your house has many owners
and those owners own many objects. These kinds of situations are best modeled
through a many-to-many associations.

Rails provides a few ways to model many-to-many associations, but we will focus
only on one - `has_many , through:`. You can research the other methods on your
own, but be warned that all of them have subtle problems that are hard to solve,
therefore in most real world applications you will only see
`has_many , through:`

How does it work? If we go back to the example of ownership and break it down
to database terms. We would have at least two tables - objects and people. Since
a single column can only store a single value we would ether need to add as many
columns as there are possible combinations of the to to each table or think of
a better solution. And here the better solution would be to introduce a third
table - ownerships. The ownerships table has only two columns - `person_id` and
`object_id` - and it represents the ownership of an object by a person.

To recap, a Person has many Ownerships. An Object has many ownerships. An
Ownership belongs to a Person and to an Object.

Now we can say that a Person has many Objects through Ownerships. Bingo!
And we would do that in Rails in the exact same manner

```ruby
class Person < ApplicationRecord
  has_many :ownerships
  has_many :objects, through: :ownerships
end

class Object < ApplicationRecord
  has_many :ownerships
  has_many :people, through: :ownerships
end

class Ownership < ApplicationRecord
  belongs_to :person
  belongs_to :object
end
```

then we could do the following

```ruby
person = Person.create
object = Object.create

Ownership.create(person: person, object: object)

person.objects.count
# 1
```

## Querying

By now we have covered how to create, update and destroy records/rows, but
how do we find a record?

We will cover the methods we will use the most. The full list of all
available methods can be found
[here](https://guides.rubyonrails.org/active_record_querying.html#or-conditions).

### Find & find_by

If you haven't noticed by now, each record in our database has an ID that's
unique for it's table. You can see it in the URL of the record.

![Record URL](./images/record_url.png)

You can get the model instance of this record by calling `find` with it's ID
on it's model. So if we want to get the post with ID `1` we would do the
following

```ruby
Post.find(1)
```

Which returns the following

```text
  Post Load (0.6ms)  SELECT  "posts".* FROM "posts" WHERE "posts"."id" = ? LIMIT ?  [["id", 1], ["LIMIT", 1]]
=> #<Post id: 1, author_id: 3, content: "Bla", published: true, created_at: "2018-10-28 17:32:25", updated_at: "2018-10-28 17:32:25", sub_reddit_id: nil>
```

In reality, more often than not we won't know the ID of the record we are
looking for, we will look for a record with a certain value in a field/column.
For this kinds of situation there is the `find_by` method. It works much the
same as `find` but it accepts a hash, instead of an ID, that describes what
value should be in which column and returns the first record that satisfies the
search criteria.

Say we want to find a SubReddit with the title "Bunnies"

```ruby
SubReddit.find_by(title: 'Bunnies')
```

If there is such a record in the database it's returned, if there are multiple
a random one is returned. If there are none `nil` is returned.

### All & where

Sometimes we want to find all records that match a criteria. The `find` and
`find_by` methods can't help us here as they return only a single record.

For situations like these there are the `all` and `where` methods.

`all` literally returns all existing records from the table.

```ruby
Post.all
```

returns

```text
[#<Post:0x007faf01badf30
  id: 1,
  author_id: 3,
  content: "Bla",
  published: true,
  created_at: Sun, 28 Oct 2018 17:32:25 UTC +00:00,
  updated_at: Sun, 28 Oct 2018 17:32:25 UTC +00:00,
  sub_reddit_id: nil>,
 #<Post:0x007faf01baddf0
  id: 2,
  author_id: 1,
  content: "Foo Bar",
  published: true,
  created_at: Sun, 28 Oct 2018 17:32:44 UTC +00:00,
  updated_at: Sun, 28 Oct 2018 17:32:44 UTC +00:00,
  sub_reddit_id: nil>,
 #<Post:0x007faf01badcb0
  id: 3,
  author_id: 2,
  content: "FUU BAAAAR",
  published: false,
  created_at: Sun, 28 Oct 2018 18:05:32 UTC +00:00,
  updated_at: Sun, 28 Oct 2018 18:05:32 UTC +00:00,
  sub_reddit_id: nil>]
```

While the `where` method functions much like the `find_by` method, but it
returns all the records that match. Usually a `where` method follows an `all`
method as we want to filter through all our records.

```ruby
Post.all.where(published: true)
```

returns

```text
[#<Post:0x007faf01badf30
  id: 1,
  author_id: 3,
  content: "Bla",
  published: true,
  created_at: Sun, 28 Oct 2018 17:32:25 UTC +00:00,
  updated_at: Sun, 28 Oct 2018 17:32:25 UTC +00:00,
  sub_reddit_id: nil>,
 #<Post:0x007faf01baddf0
  id: 2,
  author_id: 1,
  content: "Foo Bar",
  published: true,
  created_at: Sun, 28 Oct 2018 17:32:44 UTC +00:00,
  updated_at: Sun, 28 Oct 2018 17:32:44 UTC +00:00,
  sub_reddit_id: nil>]
```

Where can accept multiple arguments by which it should filter.

```ruby
Post.all.where(published: true, author_id: 3)

# [#<Post:0x007faf01badf30
#   id: 1,
#   author_id: 3,
#   content: "Bla",
#   published: true,
#   created_at: Sun, 28 Oct 2018 17:32:25 UTC +00:00,
#   updated_at: Sun, 28 Oct 2018 17:32:25 UTC +00:00,
#   sub_reddit_id: nil>]
```

Multiple wheres can be chained together to narrow down search results. E.g.
the previous where (`where(published: true, author_id: 3)`) can be
written like the following, and it returns the exact same result.

```ruby
Post.all.where(published: true).where(author_id: 3)

# [#<Post:0x007faf01badf30
#   id: 1,
#   author_id: 3,
#   content: "Bla",
#   published: true,
#   created_at: Sun, 28 Oct 2018 17:32:25 UTC +00:00,
#   updated_at: Sun, 28 Oct 2018 17:32:25 UTC +00:00,
#   sub_reddit_id: nil>]
```

We can also form conditional searches by using the `or` method.
E.g. let's search for posts that aren't published *or* the author has the
ID `3`.

```ruby
Post.all.where(published: false).or(Post.where(author_id: 3))

# [#<Post:0x007faf01badf30
#   id: 1,
#   author_id: 3,
#   content: "Bla",
#   published: true,
#   created_at: Sun, 28 Oct 2018 17:32:25 UTC +00:00,
#   updated_at: Sun, 28 Oct 2018 17:32:25 UTC +00:00,
#   sub_reddit_id: nil>,
#  #<Post:0x007faf01badcb0
#   id: 3,
#   author_id: 2,
#   content: "FUU BAAAAR",
#   published: false,
#   created_at: Sun, 28 Oct 2018 18:05:32 UTC +00:00,
#   updated_at: Sun, 28 Oct 2018 18:05:32 UTC +00:00,
#   sub_reddit_id: nil>]
```

We can also search for opposite conditions using the `not` method. E.g. let's
do the previous query but using `not` for the `published: false` condition.

```ruby
Post.all.where.not(published: true).or(Post.where(author_id: 3))

# [#<Post:0x007faf01badf30
#   id: 1,
#   author_id: 3,
#   content: "Bla",
#   published: true,
#   created_at: Sun, 28 Oct 2018 17:32:25 UTC +00:00,
#   updated_at: Sun, 28 Oct 2018 17:32:25 UTC +00:00,
#   sub_reddit_id: nil>,
#  #<Post:0x007faf01badcb0
#   id: 3,
#   author_id: 2,
#   content: "FUU BAAAAR",
#   published: false,
#   created_at: Sun, 28 Oct 2018 18:05:32 UTC +00:00,
#   updated_at: Sun, 28 Oct 2018 18:05:32 UTC +00:00,
#   sub_reddit_id: nil>]
```

`not` can be useful when the inverse condition is hard to figure out or write
down. Say the following query `where(author_id: 3, published: false)`, it's
inverse would be `where(author_id: [1, 2]).or(Post.where(published: false))`
which assumes we only have authors with IDs `1`, `2` and `3` in our system so
we specify that the author ID should be contained in the array we pass. This
won't work in applications that can have arbitrary numbers of authors. But
with `not` is much easier - `where.not(author_id: 3, published: false)`.

### Join

If we want to work with associations. Say return only records that have an
associated record, or return records who's associated record fields have
certain values - for that we can use `joins` and `left_joins`.

Those two methods are mostly the same, the main difference being that `joins`
removes all rows that don't have an associated row, while `left_joins` keeps
them.

If we wanted to find all posts which are published by an author with the
email `foo@bar.com` we would use `joins` as the requirement is that a post has
to have an author and it's email must be `foo@bar.com`.

```ruby
Post.all.joins(:author).where(published: true, author: {email: 'foo@bar.com'})
```

But, if we wanted to find all unpublished posts or posts that are published and
are by the author with the email `foo@bar.com` then we would use `left_joins`.
If we used `joins` for this we wouldn't get posts with no author.

```ruby
Post
  .all
  .where(published: true)
  .or(Post.left_joins(:author).where(author: {email: 'foo@bar.com'}))
```

When working with `joins` you'll often see a query ending with the method
`distinct`. The `distinct` method ensures that each record will be returned
exactly once.

This might seem odd. Why would the database return the same row multiple times?
This is a quirk of how joins work in SQL. When you join two tables together,
say this table

```text
                    Books
+---------------------------------+----------------+
|               Title             | Author surname |
+---------------------------------+----------------+
| Brave New World                 | Huxley         |
| Evolution: The Modern Synthesis | Huxley         |
+---------------------------------+----------------+
```

In SQL we can join two table by any column we like, say we are going to join
this `books` table with the `authors` table by the `Author surname` column on
one and the `Surname` column on the other. We would get the following.

```text
+---------------------------------+----------------+------------+---------+
|               Title             | Author surname | First name | Surname |
+---------------------------------+----------------+------------+---------+
| Brave New World                 | Huxley         |   Julian   |  Huxley |
| Brave New World                 | Huxley         |   Thomas   |  Huxley |
| Evolution: The Modern Synthesis | Huxley         |   Julian   |  Huxley |
| Evolution: The Modern Synthesis | Huxley         |   Thomas   |  Huxley |
+---------------------------------+----------------+------------+---------+
```

This is odd, but correct. The database has no way of knowing which Huxley is
the correct one for the given book, so it returns all books combined with all
Huxleys.

To avoid this, we can finish a query with `distinct`. Then we would get this

```text
+---------------------------------+----------------+------------+---------+
|               Title             | Author surname | First name | Surname |
+---------------------------------+----------------+------------+---------+
| Brave New World                 | Huxley         |   Julian   |  Huxley |
| Evolution: The Modern Synthesis | Huxley         |   Julian   |  Huxley |
+---------------------------------+----------------+------------+---------+
```

This isn't what we wanted, but we got exactly one result for each book, which
is the point of adding the `distinct`.

### Order

We can also specify in which order we would want our records to be returned
using the `order` method. It works much like the `where` method, but instead
of passing a value for a key, we pass the sort direction.

The sort direction can be ascending `:asc`, meaning that each record
would have a greater value than the previous one. E.g. 5,2,4,3,1 would become
1,2,3,4,5. It can also be descending `:desc`, meaning that each record would
have a lower value than the previous one. E.g. 5,2,4,3,1 would become
5,4,3,2,1.

Say we want to sort our posts by the time they were created, newest first,
oldest last.

```ruby
Post.all.order(created_at: :desc)
```

Multiple sort conditions can be combined.

```ruby
Post.all.order(title: :desc, created_at: :asc)
```

This would mean that the posts are sorted by title in descending alphabetical
order (starting with `z` and ending with `a`) and if there are two posts with
the same title then they are sorted by the `create_at` column, oldest first.

## Indices

We won't dab too deep into indices (singular `index`), but you have to know that
they exist and what they do.

Indices, in databases, are much the same as the one in books. By creating an
index on a column you tell the database that it should keep track of the values
in it so that they can be found quickly.

If we would transform this way of thinking onto the book example, a book has an
index on it's chapters. If we want to find a chapter we can look it's page up
in the index and go to it. If we didn't have the index we would have to go
through each page of the book looking for a chapter with the name we are
searching for.

Let's create an index on the posts' table title column, as user will be able to
search for a given post by it's title.

```bash
rails g migration add_posts_title_index
```

```ruby
class AddPostsTitleIndex < ActiveRecord::Migration[5.2]
  def change
    add_index :posts, :title
  end
end
```

And that's it.

Indices have one additional function. They can be used to validate uniqueness.
Let's take our User model for example. It would be good if we could prohibit
two users to share an email or username. This can be done with an unique index.

```bash
rails g migration add_users_email_and_username_unique_index
```

```ruby
class AddUsersEmailAndUsernameUniqueIndex < ActiveRecord::Migration[5.2]
  def change
    add_index :users, :email, unique: true
    add_index :users, :username, unique: true
  end
end
```

Don't forget to update your model accordingly.

```ruby
validates :email, uniqueness: true, presence: true
validates :username, uniqueness: true, presence: true
```

Finally, indices allow you to create relatively unique fields. Say that multiple
users can have the same email but must have different usernames.

```
add_index :users, [:email, :usrename], unique: true
```

The appropriate model validation would be

```ruby
validates :email, uniqueness: { scope: :username }, presence: true
```

## Assignment

1. Create a SubReddit model
    * it has a unique title, no matter the capitalization, that can't be `nil`
    * it has an owner, which is a reference to the user, which can't be `nil`
    * it has a description which can't be `nil`
    * create appropriate validations on the model
2. Drop the Author model
3. Create the User model
    * it has an email that's unique and can't be `nil`
    * it has a username that's unique and can't be `nil`
    * create appropriate validations on the model
4. Add a title column to the Post model
    * it has to be unique
    * it can't be `nil`
    * it's default value is `''` (empty string)
    * create appropriate validations on the model
5. Change an `author_id` column on the Post model that's a reference to an User
    * it can't be `nil`
    * create appropriate validations on the model
6. Create an `sub_reddit_id` column on the Post model that's a reference to a
  SubReddit
    * it can't be `nil`
    * create appropriate validations on the model
6. Create an Upvote model
    * it has a `creator` reference to an User, that can't be `nil`
    * it has a `post` reference to a Post, that can't be `nil`
    * each Upvote has to be unique for each post regarding a user
    (e.g. each user can have only one upvote for a post)
    * create appropriate validations on the model
7. Create associations on the User model
    * For Upvotes
    * For Posts
    * For SubReddits
8. Create associations on Post
    * For SubReddit
    * For User
9. Create associations on SubReddit
    * For User
10. Create associations on Upvote
    * For Post
    * For User
11. Migrate all changes
12. Run Annotate
13. Delete the author's views, routes, and controller
14. Create routes, views and a controller for users
15. Update all show actions to show some field of their associated records

Happy hacking!
