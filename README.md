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
Since i use some different tools i decided to provision the box by installing the
following languages/runtimes:

### Ruby
[Ruby](https://www.ruby-lang.org/en/) 2.2 is installed by adding the
[brightbox](https://www.brightbox.com/docs/guides/cli/installation-debian/) repository.
Ruby is the language i have more experience on, but looking for some more modern
alternative to support parallelism on the multi CPUs era.

### Elixir
[Elixir](http://elixir-lang.org/) last version is installed by adding the
[erlang-solutions](https://www.erlang-solutions.com/about/erlang-other-technologies.html) repository.
I studied Elixir last year, finding its rubyesque resemblance pretty easy to grasp.  
It also support parallelism quite nicely, being one of the fastest app server
tested (although i suspect the credits goes to [cowboy](http://ninenines.eu) here).
What i dislike more is the lack of state that a pure functional language implies:
i am not convinced this is required to get parallelism right, while in many cases
OO grant silver bullets to your arsenal.

### Node.js
[Node.js](https://nodejs.org/en/) stable version (4.x) is installed by adding nodesource repository.
I am not a big fan of JavaScript, although i used it for some years. Google V8
implementation is quite fast anyway, proving the reactor pattern to be good for
not-distributed scenarios. 

### GO
[Go](https://golang.org/) language is installed by source, since installation is straightforward.
Go is the favorite of mine between the "modern" languages: is simple, elegant and
fast. Once i get accomplished to its style i found coding with Go as natural as
Ruby.
