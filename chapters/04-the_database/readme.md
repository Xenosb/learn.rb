# Working with a database, or how to remember stuff

This is the fifth chapter in a series of 10 of the
[learn.rb project](https://github.com/monorkin/learn.rb) whose goal is to teach
people Ruby with a focus on Ruby on Rails.

## Chapters

- [Working with a database, or how to remember stuff](#working-with-a-database-or-how-to-remember-stuff)
  - [Chapters](#chapters)
  - [Introduction](#introduction)
    - [What is a database](#what-is-a-database)
    - [What are data models](#what-are-data-models)
  - [Creating models](#creating-models)
    - [Database schema](#database-schema)
    - [Migrations](#migrations)
    - [Ruby models](#ruby-models)
    - [Validations](#validations)
  - [Connecting the models](#connecting-the-models)
    - [One to one](#one-to-one)
    - [One to many](#one-to-many)
    - [Many to may](#many-to-may)
  - [Accessing the data](#accessing-the-data)
    - [Accessing by id](#accessing-by-id)
    - [Accessing by attribute](#accessing-by-attribute)
    - [Accessing referenced models](#accessing-referenced-models)
  - [Assignment](#assignment)

## Introduction

The goal of this chapter is to teach you how to store and access the data in a
database as it is done in Rails.

In the last chapter we learned how to talk to send data to the server via forms.
In this chapter we will save the received data in an organized manner and also
display it back to the user.

### What is a database

- Shortly describe database as a computer program.
- Short explanation of ER principles
- Explain the pipeline: view -> controller -> model -> database

### What are data models

- Description of data model purpose and usage

## Creating models

### Database schema

- Inspect current database schema
- List primitive types and their usage

### Migrations

- Rollback old migrations
- Modify migrations to include timestamps
- Migrate anew

### Ruby models

- Inspect current models
- Add printer method which displays alias - email 

### Validations

- Add validations

## Connecting the models

### One to one

- Explain the relation has_one belongs_to
- Rollback migrations, again
- Link author and the post

### One to many

- Explain relation has_many
- Link comments and the post

### Many to may

- Explain has_many through
- Link comments to author

## Accessing the data

### Accessing by id

- Simple access through the id
- Explain with show action in controller

### Accessing by attribute

- Explain where
- Show all comments created before a given date

### Accessing referenced models

- View all posts created by a given user

## Assignment

1. Do all the steps in the chapter by yourself.
2. Display 5 latest posts on landing
3. Display 5 posts with most comments on landing
4. Sort post comments by last edit
