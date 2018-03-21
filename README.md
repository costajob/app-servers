# Table of Contents

* [Scope](#scope)
  * [Hello World](#hello-world)
  * [Disclaimer](#disclaimer)
* [Languages](#languages)
  * [Ruby](#ruby)
  * [Python](#python)
  * [JavaScript](#javascript)
  * [Dart](#dart)
  * [Elixir](#elixir)
  * [Java](#java)
  * [Clojure](#clojure)
  * [Scala](#scala)
  * [C-Sharp](#c-sharp)
  * [Crystal](#crystal)
  * [D](#d)
  * [GO](#go)
  * [Nim](#nim)
  * [Rust](#rust)
* [Tools](#tools)
  * [Wrk](#wrk)
  * [Platform](#platform)
  * [RAM and CPU](#ram-and-cpu)
* [Benchmarks](#benchmarks)
  * [Results](#results)
  * [Rack with Passenger](#rack-with-passenger)
  * [Gunicorn with Meinheld](#gunicorn-with-meinheld)
  * [Node Cluster](#node-cluster)
  * [Dart HttpServer](#dart-httpserver)
  * [Plug with Cowboy](#plug-with-cowboy)
  * [Servlet3 with Jetty](#servlet3-with-jetty)
  * [Ring with Jetty](#ring-with-jetty)
  * [Colossus](#colossus)
  * [Kestrel](#kestrel)
  * [Crystal HTTP](#crystal-http)
  * [Vibe](#vibe)
  * [GO ServeMux](#go-servemux)
  * [Asynchttpserver](#asynchttpserver)
  * [Tokio minihttp](#tokio-minihttp)

## Scope
The idea behind this repository is to benchmark different languages implementation of HTTP server by relying on their standard library (when possible).

### Hello World
The *application* i tested is minimal: the HTTP version of the *Hello World* example.  
This approach allows including languages i barely know, since it is pretty easy to find such implementation online.  
If you're looking for more complex examples, you will have better luck with the [TechEmpower benchmarks](https://www.techempower.com/benchmarks/).

### Disclaimer
Please do take the following numbers with a grain of salt.  
It is not my intention to promote one language over another basing on micro-benchmarks.  
Indeed you should never pick a language just basing on its presumed performance.

## Languages
I chose to test the following languages:

### Ruby
[Ruby](https://www.ruby-lang.org/en/) 2.5.0 is installed via [rbenv](https://github.com/rbenv/rbenv).  
Ruby is a scripting language focused on simplicity and productivity, inspired by Lisp, with elements of Perl & Smalltalk.  
I tested Ruby MRI implementation, offering concurrency via threads and parallelism via pre-forking.

### Python
[Python](https://www.python.org/) 3.6.4 is installed by official OSX package.  
Python is a widely used high-level, general-purpose, interpreted, dynamic programming language.  
It supports several programming paradigms and can count on a broad standard library.

### JavaScript
[Node.js](https://nodejs.org/en/) version 8.9.4 is installed by official OSX package.  
Node.js is based on the V8 engine, optimized by Google and supporting most of the new ES6 features.   
Node.js leverages on the JavaScript built-in event loop to grant concurrency. Parallelism is supported via pre-forking.

### Dart
[Dart](https://www.dartlang.org/) version 1.24.3 is installed via homebrew.  
Dart is an object-oriented, class defined, single inheritance language using a C-style syntax that transcompiles optionally into JavaScript.  
It supports interfaces, mixins, abstract classes, generics, optional typing, and concurrency though asynchronous execution and actor-based model.

### Elixir
[Elixir](http://elixir-lang.org/) 1.6.4 is installed via homebrew.  
Elixir is a purely functional language that runs on the [Erlang](https://www.erlang.org/) VM.  
While preserving Erlang key-features, Elixir is strongly influenced by Ruby syntax and supports compile-time metaprogramming with macros and polymorphism.

### Java
[Java](https://www.java.com/en/) 9.0.4 is installed by official OSX package.  
Java is the most used programming language worldwide, thanks to its JVM that kept the promise "write once, run anywhere".  
Java is a strongly-typed, compiled, object oriented language and was a pioneer taking parallelism as first-class via multi-threading.

### Clojure
[Clojure](http://clojure.org/) 1.9.0 is installed via homebrew.  
Clojure is a dynamic, general-purpose programming language, strongly inspired by Lisp, running on the JVM.  
Clojure is a compiled language, yet remains completely dynamic: every feature supported by Clojure is supported at runtime.

### Scala
[Scala](https://www.scala-lang.org/) 2.12.4 and [SBT](http://www.scala-sbt.org/) 1.1.0 are installed via homebrew.  
Scala is a general-purpose programming language that runs on the JVM. It has full support for  functional, object oriented programming and a strong static type system.  
Designed to be concise, many of Scala's design decisions were inspired by criticism of Java's shortcomings.

### C-Sharp
[C-Sharp](https://en.wikipedia.org/wiki/C_Sharp_(programming_language)) (C#) 7.0 language is installed as a companion of the [.NET Core](https://www.microsoft.com/net/core) 2.1.101 framework, by following the [official guideline](https://www.microsoft.com/net/core#macos).  
.NET Core is an open-source framework for running .NET applications cross platform.  
C# is a simple, powerful, type-safe, object-oriented language. It inherited many features from Java, but recently added some desirable paradigms such as futures, pattern matching and deconstructions.  

### Crystal
[Crystal](http://crystal-lang.org/) 0.24.2 is installed via homebrew.  
Crystal has a syntax very close to Ruby, but brings some desirable features such as strong typing (hidden by a pretty smart type inference algorithm) and ahead of time (AOT) compilation.  
For concurrency Crystal adopts the CSP model and evented/IO (via [libevent](http://libevent.org/)) to avoid blocking calls, but parallelism is not yet supported.

### D
[D](https://dlang.org/) language's LDC compiler 1.7.0 is installed via homebrew.  
D is a general-purpose programming language with static typing, systems-level access, and C-like syntax.  
It combines efficiency, control and modeling power with safety and programmer productivity.

### GO
[GO](https://golang.org/) language version 1.10 is installed by official OSX package.  
GO focuses on simplicity by intentionally lacking features considered redundant (an approach i am a fan of). It tries to address verbosity by using type inference, duck typing and a dry syntax.  
At the same time GO takes a straight approach to parallelism, coming with built in [CSP](https://en.wikipedia.org/wiki/Communicating_sequential_processes) and green threads (goroutines).  

### Nim
[Nim](http://nim-lang.org/) 0.18.0 is installed viw homebrew.  
Nim is an efficient, Python inspired, strong typed language that comes with a pretty flexible compliler able to produce code in C (default), C++, JavaScript or ObjectiveC.  
Nim supports metaprogramming, functional, message passing, procedural, and object-oriented coding style.

### Rust
[Rust](https://www.rust-lang.org/) language version 1.24.1 is installed by official package.  
According to the official site Rust is a systems programming language that runs blazingly fast, prevents segfaults, and guarantees thread safety.  
Rust grants parallelism by running safely on multiple threads courtesy of its pretty unique ownership model.

## Tools

### Wrk
I used [wrk](https://github.com/wg/wrk) as the loading tool.  
I measured each application server six times, picking the best lap (but for VM based languages demanding longer warm-up).  
```shell
wrk -t 4 -c 100 -d30s --timeout 2000 http://0.0.0.0:9292
```

### Platform
These benchmarks are recorded on a MacBook PRO 15 mid 2015 having these specs:
* OSX Sierra
* 2.2 GHz Intel Core i7 (4 cores)
* 16 GB 1600 MHz DDR3

### RAM and CPU
I measured RAM and CPU consumption by using [Apple XCode Instruments](https://developer.apple.com/library/content/documentation/DeveloperTools/Conceptual/InstrumentsUserGuide/index.html) and recording max consumption peak.  
For the languages relying on pre-forking i reported the average consumption by taking a snapshot during the stress period.

## Benchmarks

### Results
| Language                  | App Server                                        | Req./sec (local)  | RAM (MB)  | CPU (%)  |
| :------------------------ | :------------------------------------------------ | ----------------: |---------: |--------: |
| [Elixir](#elixir)         | [Plug with Cowboy](#plug-with-cowboy)             |         44021.73  |    52.17  |   497.2  |
| [D](#d)                   | [Vibe](#vibe)                                     |         45663.49  |     8.88  |    99.8  |
| [Dart](#dart)             | [Dart HttpServer](#dart-httpserver)               |         47482.25  |   116.33  |   438.1  |
| [Ruby](#ruby)             | [Rack with Puma](#rack-with-puma)                 |         50198.39  |    > 160  |   > 390  |
| [Clojure](#clojure)       | [Ring with Jetty](#ring-with-jetty)               |         64205.73  |   447.33  |   579.5  |
| [Nim](#nim)               | [Asynchttpserver](#asynchttpserver)               |         63661.79  |     6.78  |    99.8  |
| [JavaScript](#javascript) | [Node Cluster](#node-cluster)                     |         73177.31  |    > 440  |   > 530  |
| [C-Sharp](#c-sharp)       | [Kestrel](#kestrel)                               |         79498.88  |   980.86  |   502.4  |
| [Python](#python)         | [Gunicorn with Meinheld](#gunicorn-with-meinheld) |         84680.10  |     > 80  |   > 340  |
| [Scala](#scala)           | [Colossus](#colossus)                             |         85073.26  |   932.20  |   310.2  |
| [Java](#java)             | [Servlet3 with Jetty](#servlet3-with-jetty)       |         85116.78  |   284.52  |   438.1  |
| [GO](#go)                 | [GO ServeMux](#go-servemux)                       |         85226.46  |    11.92  |   405.1  |
| [Rust](#rust)             | [Tokio minihttp](#tokio-minihttp)                 |         86281.79  |     4.13  |   144.5  |
| [Crystal](#crystal)       | [Crystal HTTP](#crystal-http)                     |        109524.88  |    10.82  |   109.9  |

                                                                                                   
### Rack with Puma                                                                                 
I tested Ruby by using a plain [Rack](http://rack.github.io/) application with the [Puma](http://puma.io) application server.

#### Bootstrap
```shell
cd servers/rack_server
bundle exec puma -w 8 --preload -e production app.ru
```


### Gunicorn with Meinheld
I started a plain WSGI application on the [Gunicorn](http://gunicorn.org/) application server wrapping [Meinheld](http://meinheld.org/) workers. 

#### Bootstrap
```shell
cd servers
gunicorn -w 8 gunicorn_server:app -b :9292 -k meinheld.gmeinheld.MeinheldWorker
```


### Node Cluster
I used the cluster library included into Node's standard library.

#### Bootstrap
```shell
node servers/node_server.js
```


### Dart HttpServer
A plain HTTP server is embedded into the Dart standard library.

#### Bootstrap
```shell
dart servers/dart_server.dart
```


### Plug with Cowboy
I tested Elixir by using [Plug](https://github.com/elixir-lang/plug) library that provides a [Cowboy](https://github.com/ninenines/cowboy) adapter.

#### Bootstrap
```shell
cd servers/plug_server
MIX_ENV=prod mix compile
MIX_ENV=prod mix run --no-halt
```


### Servlet3 with Jetty
To test Java i used [Jetty](http://www.eclipse.org/jetty/): a modern, stable and quite fast servlet container.  

#### Bootstrap
```shell
cd servers/jetty_server
javac -cp jetty-all-uber.jar HelloWorld.java
java -server -cp .:jetty-all-uber.jar HelloWorld
```


### Ring with Jetty
I used the default library to interface Clojure with HTTP: the [Ring](https://github.com/ring-clojure/ring) library.

#### Bootstrap
```shell
cd servers/ring_server
lein run
```


### Colossus
To test Scala i used [Colossus](http://tumblr.github.io/colossus/): a lightweight framework for building high-performance network I/O applications.

#### Bootstrap
```shell
cd servers/colossus_server
sbt
> compile
> run
```


### Kestrel
To test C# i opted for [Kestrel](https://docs.microsoft.com/en-us/aspnet/core/fundamentals/servers/kestrel): a cross-platform web server based on the libuv asynchronous I/O library.

#### Bootstrap
```shell
cd servers/kestrel_server
dotnet restore
dotnet run
```


### Crystal HTTP
I used Crystal HTTP server standard library.  

#### Bootstrap
```shell
crystal build --release servers/crystal_server.cr
./crystal_server
```


### Vibe
D language official documentation suggests using the [Vibe](http://vibed.org/) framework for Web development.

#### Bootstrap
```shell
cd servers/vibe_server
dub build --build=release --force --compiler=ldc2
./vibe_server
```


### GO ServeMux
I opted for the [HTTP ServeMux](https://golang.org/pkg/net/http/) GO standard library.  

#### Bootstrap
```shell
go run servers/go_server.go
```


### Asynchttpserver
I used the asynchttpserver module to implement an asynchronous server with Nim.  

#### Bootstrap
```shell
nim cpp -d:release servers/nim_server.nim
./servers/nim_server
```


### Tokio minihttp
Rust standard library does not include a HTTP server, so i relied on a minimal library named [Tokio minihttp](https://github.com/tokio-rs/tokio-minihttp). 

#### Bootstrap
```shell
cd servers/tokio_minihttp
cargo clean
cargo build --release
cargo run --release
```
