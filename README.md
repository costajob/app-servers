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

### Elixir
[Elixir](http://elixir-lang.org/) last version is installed by adding the
[erlang-solutions](https://www.erlang-solutions.com/about/erlang-other-technologies.html) repository.

### Node.js
[Node.js](https://nodejs.org/en/) stable version (4.x) is installed by adding nodesource repository.

### GO
[Go](https://golang.org/) language is installed by source, since installation is straightforward.
