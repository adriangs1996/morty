# Quick Start

This guide will help you get started with Mortymer in just a few minutes.
We'll create a simple API endpoint that demonstrates the core features of Mortymer
by integrating it in a Rails API, let's call it Rails and Mortymer.

## Basic Setup

First, let's create a new Rails application (skip this if you already have one):

```bash
rails new my_api --api
cd my_api
```

## Installation

Add Mortymer to your Gemfile:

```ruby
gem 'mortymer'
```

Then install it:

```bash
bundle install
```

In rails environments, Mortymer can automatically create the routes for you, it is not necessary
that you register them one by one.

```ruby
# config/routes.rb
Rails.application.routes.draw do
  Mortymer::Rails::Routes.new(self).mount_controllers
end
```

## Creating Your First API

Let's build a simple book API to demonstrate Mortymer's key features.

### 1. Define Your Type

Create a Book type that defines the structure of your data:

```ruby
# app/types/book.rb
class Book < Mortymer::Model
  attribute :id, Integer
  attribute :title, String
  attribute :author, String
  attribute :published_year, Integer
end
```

### 2. Create a Service

Create a service to handle business logic:

```ruby
# app/services/book_service.rb
class BookService
  def initialize
    @books = []
  end

  def create_book(title:, author:, published_year:)
    book = Book.new(
      id: next_id,
      title: title,
      author: author,
      published_year: published_year
    )
    @books << book
    book
  end

  def list_books
    @books
  end

  private

  def next_id
    @books.length + 1
  end
end
```

### 3. Create a Controller

Set up your API controller with Mortymer's features:

```ruby
# app/controllers/example_controller.rb
class ExampleController < ApplicationController
    include Mortymer::ApiMetadata
    include Mortymer::DependenciesDsl

    inject BookService, as: :books

    class Empty < Mortymer::Model
    end

    class ListAllBooksOutput < Mortymer::Model
      attribute :books, Array.of(Book)
    end

    class CreateBookInput < Mortymer::Model
      attribute :title, String
      attribute :author, String
      attribute :published_year, Coercible::Integer
    end

    tags :Books

    get input: Empty, output: ListAllBooksOutput, path: "/examples/list_books"
    def list_all_books(_params)
      ListAllBooksOutput.new(books: @books.list_books)
    end

    post input: CreateBookInput, output: Book
    def create_book(params)
      @books.create_book(
        title: params.title,
        author: params.author,
        published_year: params.published_year
      )
    end
end
```

## Testing Your API

Start your Rails server:

```bash
rails server
```

Create a new book:

```bash
curl -X POST http://localhost:3000/api/books \
  -H "Content-Type: application/json" \
  -d '{
    "title": "The Ruby Way",
    "author": "Hal Fulton",
    "published_year": 2015
  }'
```

List all books:

```bash
curl http://localhost:3000/api/books
```

## Key Features Demonstrated

This simple example showcases several of Mortymer's powerful features:

- ✨ **Type System**: Strong typing with `Mortymer::Models` which are powered by `Dry::Struct`
- 🔌 **Dependency Injection**: Clean service injection with `inject :book_service`
- ✅ **Parameter Validation**: Built-in request validation in controllers

## OpenAPI Documentation

Mortymer automatically generates OpenAPI (Swagger) documentation for your API endpoints. After setting up your application, you can access the Swagger UI at `/api-docs`:

![Swagger UI](../assets/swagg.png)

This interactive documentation allows you to:

- Browse all available endpoints
- See request/response schemas
- Test API endpoints directly from the browser
- Download the OpenAPI specification
