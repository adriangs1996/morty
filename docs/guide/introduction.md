# Introduction

Mortymer is a modern Ruby gem designed to enhance API development with features
present in most modern API-first frameworks, like FastAPI and bringing some goodies
to the ruby ecosystem. It brings type safety, automatic documentation,
and dependency injection to your APIs, while beign web framework agnostic and
mantaining a good balance between explicitness and development experience.
It provides a seamless integration with Ruby on Rails, but it could be used along side
other frameworks like Sinatra or Grape.

## Features

- **Type-Safe APIs**: Define input and output types for your endpoints
- **Automatic Documentation**: OpenAPI/Swagger documentation generation from your defined input and outputs.
- **DI**: Dependency injection and clear separation of concerns through a simple DI Engine.
- **Rails Integration**: Seamless integration with Ruby on Rails

## Why Mortymer?

Mortymer brings the best practices of modern API development to the Ruby ecosystem. Topics
like API documentation is really painful, at least from my experience, in the Ruby world. There
are a lot of alternatives, from general ones like Rswag to Grape's approach, but none of them
feels intuitive or comfortable to use for me. In Rails' I personally hate the strong parameters
features, I strongly believe that if you are able to define the shape of your enpoint, i.e, your contract,
you should be able to use a fully Parsed object from your params, much like FastAPI's approach.
Im tire of beign jelous of FastAPI and want to use Ruby in a similar way, that's when Mortymer was born.

The name Mortymer comes from the popular series Rick and Morty, where Morty is like an assistant, a
faithful companion (Mortymer itself is the pet of a heroe of Dota2). And that is what this gem aims to be, not a replacement for any existent framework,
but a companion that allows the real heroes (Rails, Sinatra, Grape, etc) shine with their cool features,
and not get bored with the API handling stuff.
