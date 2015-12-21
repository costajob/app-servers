## Table of Contents
* [Scope](#scope)
* [Vagrant](#vagrant)
* [Languages](#languages)
  * [Ruby](#ruby)
  * [Elixir](#elixir)
  * [Node.js](#nodejs)
  * [GO](#go)

## Scope
This repository serves as the main development environment of mine.  
It is based on a [vagrant](https://www.vagrantup.com/) box and provisioned by shell scripting.

## Vagrant
The vagrant box uses Ubuntu Trusty 64 bit. The configuration uses 3 CPUs (i have
four on my MacBook Pro) and 6GB of RAM.

## Languages
I opted to provision the box by installing the following languages/runtimes:

### Ruby
[Ruby](https://www.ruby-lang.org/en/) 2.2 is installed by adding the
[brightbox](https://www.brightbox.com/docs/guides/cli/installation-debian/) repository.  
Ruby is the language i have more experience with.  
I find it an enjoyable language, but recently i feel the urge to master an alternative language that better supports parallelism on the multi CPUs era.  

### Elixir
[Elixir](http://elixir-lang.org/) last version is installed by adding the
[erlang-solutions](https://www.erlang-solutions.com/about/erlang-other-technologies.html) repository.  
I studied Elixir last year, surfing the wave of Dave Thomas enthusiasm, finding its rubyesque resemblance pretty easy to grasp.  
It also support parallelism quite nicely, being one of the fastest app server
i tested (although i suspect most of the credit goes to [cowboy](http://ninenines.eu)).  
What i dislike more is the lack of state that a pure functional language implies: while i invested too much time into OO techniques, i am not convinced pure immutability is required to get parallelism right.

### Node.js
[Node.js](https://nodejs.org/en/) stable version (4.x) is installed by adding nodesource repository.  
I once used to program in JavaScript much more that these days. I left it behind in
favor or more "backend" languages. I know it's a shame, since (among others) V8 implementation of JS is quite fast, and the rise of Node.js has proven JS is much more than an in-browser tool.

### GO
[Go](https://golang.org/) language is installed by source, since installation is straightforward.  
Go is the favorite of mine between the "modern" languages: is simple, elegant and
fast. It compilies to native OS code and have CSP built in to favor parallelism.  
I am still exploring GO, but as far as i've gone i am pretty happy with it.
