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
  * [Swift](#swift)
  * [Nim](#nim)
  * [Crystal](#crystal)
  * [GO](#go)
  * [Rust](#rust)
  * [D](#d-lang)
* [Tools](#tools)
  * [Wrk](#wrk)
  * [Platforms](#platforms)
  * [RAM and CPU](#ram-and-cpu)
* [Benchmarks](#benchmarks)
  * [Results](#results)
  * [Rack with Passenger](#rack-with-passenger)
  * [Gunicorn with Meinheld](#gunicorn-with-meinheld)
  * [Node Cluster](#node-cluster)
  * [Dart HttpServer](#dart-http-server)
  * [Plug with Cowboy](#plug-with-cowboy)
  * [Servlet3 with Jetty](#servlet3-with-jetty)
  * [Ring with Jetty](#ring-with-jetty)
  * [Colossus](#colossus)
  * [Kestrel](#kestrel)
  * [Kitura](#kitura)
  * [Asynchttpserver](#asynchttpserver)
  * [Crystal HTTP](#crystal-http)
  * [GO ServeMux](#go-servemux)
  * [Tokio minihttp](#tokio-minihttp)
* [Conclusions](#conclusions)
  * [Raw data](#raw-data)
  * [Different philosophies](#different-philosophies)
  * [Concurrency VS parallelism](#concurrency-vs-parallelism)
  * [A matter of taste](#a-matter-of-taste)

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
[Ruby](https://www.ruby-lang.org/en/) 2.4.1 is installed via [rbenv](https://github.com/rbenv/rbenv).  
Ruby is a scripting language focused on simplicity and productivity, inspired by Lisp, with elements of Perl & Smalltalk.  
I tested Ruby MRI implementation, offering concurrency via threads and parallelism via pre-forking.

### Python
[Python](https://www.python.org/) 3.6 is installed by official OSX package.  
Python is a widely used high-level, general-purpose, interpreted, dynamic programming language.  
It supports several programming paradigms and can count on a broad standard library.

### JavaScript
[Node.js](https://nodejs.org/en/) version 8.4 is installed by official OSX package.  
Node.js is based on the V8 engine, optimized by Google and supporting most of the new ES6 features.   
Node.js leverages on the JavaScript built-in event loop to grant concurrency. Parallelism is supported via pre-forking.

### Dart
[Dart](https://www.dartlang.org/) version 1.24.2 is installed via homebrew.  
Dart is an object-oriented, class defined, single inheritance language using a C-style syntax that transcompiles optionally into JavaScript.  
It supports interfaces, mixins, abstract classes, generics, optional typing, and concurrency though asynchronous execution and actor-based model.

### Elixir
[Elixir](http://elixir-lang.org/) 1.5.1 is installed via homebrew.  
Elixir is a purely functional language that runs on the [Erlang](https://www.erlang.org/) VM.  
While preserving Erlang key-features, Elixir is strongly influenced by Ruby syntax and supports compile-time metaprogramming with macros and polymorphism.

### Java
[Java](https://www.java.com/en/) 8 comes pre-installed on Apple Xcode. 
Java is the most used programming language worldwide, thanks to its JVM that kept the promise "write once, run anywhere".  
Java is a strongly-typed, compiled, object oriented language and was a pioneer taking parallelism as first-class via multi-threading.

### Clojure
[Clojure](http://clojure.org/) 1.8.0 is installed via homebrew.  
Clojure is a dynamic, general-purpose programming language, strongly inspired by Lisp, running on the JVM.  
Clojure is a compiled language, yet remains completely dynamic: every feature supported by Clojure is supported at runtime.

### Scala
[Scala](https://www.scala-lang.org/) 2.12 and [SBT](http://www.scala-sbt.org/) 0.13 are installed via homebrew.  
Scala is a general-purpose programming language that runs on the JVM. It has full support for  functional, object oriented programming and a strong static type system.  
Designed to be concise, many of Scala's design decisions were inspired by criticism of Java's shortcomings.

### C-Sharp
[C-Sharp](https://en.wikipedia.org/wiki/C_Sharp_(programming_language)) (C#) 7.0 language is installed as a companion of the [.NET Core](https://www.microsoft.com/net/core) 2.0 framework, by following the [official guideline](https://www.microsoft.com/net/core#macos).  
.NET Core is an open-source framework for running .NET applications cross platform.  
C# is a simple, powerful, type-safe, object-oriented language. It inherited many features from Java, but recently added some desirable paradigms such as futures, pattern matching and deconstructions.  

### Swift
[Swift](https://developer.apple.com/swift/) 3.1 comes pre-installed with Xcode 8.3.  
Swift is a general-purpose programming language built using a modern approach to safety, performance, and software design patterns.  
Swift supports parallelism courtesy of its asynchronous design approach, that relies on multi-threading.

### Nim
[Nim](http://nim-lang.org/) 0.17.2 is installed viw homebrew.  
Nim is an efficient, Python inspired, strong typed language that comes with a pretty flexible compliler able to produce code in C (default), C++, JavaScript or ObjectiveC.  
Nim supports metaprogramming, functional, message passing, procedural, and object-oriented coding style.

### Crystal
[Crystal](http://crystal-lang.org/) 0.23.1 is installed via homebrew.  
Crystal has a syntax very close to Ruby, but brings some desirable features such as strong typing (hidden by a pretty smart type inference algorithm) and ahead of time (AOT) compilation.  
For concurrency Crystal adopts the CSP model and evented/IO (via [libevent](http://libevent.org/)) to avoid blocking calls, but parallelism is not yet supported.

### GO
[GO](https://golang.org/) language version 1.9.1 is installed by official OSX package.  
GO focuses on simplicity by intentionally lacking features considered redundant (an approach i am a fan of). It tries to address verbosity by using type inference, duck typing and a dry syntax.  
At the same time GO takes a straight approach to parallelism, coming with built in [CSP](https://en.wikipedia.org/wiki/Communicating_sequential_processes) and green threads (goroutines).  

### Rust
[Rust](https://www.rust-lang.org/) language version 1.20 is installed by official package.  
According to the official site Rust is a systems programming language that runs blazingly fast, prevents segfaults, and guarantees thread safety.  
Rust grants parallelism by running safely on multiple threads courtesy of its pretty unique ownership model.

### D
[D](https://dlang.org/) language LDC compiler 1.4.0 is installed by homebrew.  
D is a general-purpose programming language with static typing, systems-level access, and C-like syntax.  
It combines efficiency, control and modeling power with safety and programmer productivity.

## Tools

### Wrk
I used [wrk](https://github.com/wg/wrk) as the loading tool.  
I measured each application server six times, picking the best lap (but for VM based languages demanding longer warm-up).  
```shell
wrk -t 4 -c 100 -d30s --timeout 2000 http://<client-ip>:9292
```

### Platforms
These benchmarks are recorded on a MacBook PRO 15 mid 2015 having these specs:
* OSX El Captain
* 2.2 GHz Intel Core i7 (4 cores)
* 16 GB 1600 MHz DDR3

### RAM and CPU
I measured RAM and CPU consumption by using [Apple XCode Instruments](https://developer.apple.com/library/content/documentation/DeveloperTools/Conceptual/InstrumentsUserGuide/index.html) and recording max consumption peak.  
For the languages relying on pre-forking i reported the average consumption by taking a snapshot during the stress period.

## Benchmarks

### Results
| Language                  | App Server                                        | Req./sec (local)  | RAM (MB)  | CPU (%)  |
| :------------------------ | :------------------------------------------------ | ----------------: |---------: |--------: |
| [Swift](#swift)           | [Kitura](#kitura)                                 |         32181.76  |    14.11  |   553.5  |
| [Elixir](#elixir)         | [Plug with Cowboy](#plug-with-cowboy)             |         43355.01  |    46.57  |   479.3  |
| [Dart](#dart)             | [Dart HttpServer](#dart-http-server)              |         49059.38  |   118.33  |   438.1  |
| [Ruby](#ruby)             | [Rack with Puma](#rack-with-puma)                 |         49528.83  |    > 180  |   > 390  |
| [Nim](#nim)               | [Asynchttpserver](#asynchttpserver)               |         64317.22  |     6.78  |    99.8  |
| [JavaScript](#javascript) | [Node Cluster](#node-cluster)                     |         72731.74  |    > 390  |   > 530  |
| [Clojure](#clojure)       | [Ring with Jetty](#ring-with-jetty)               |         75627.14  |   317.33  |   549.5  |
| [Java](#java)             | [Servlet3 with Jetty](#servlet3-with-jetty)       |         80850.10  |   164.96  |   416.4  |
| [Python](#python)         | [Gunicorn with Meinheld](#gunicorn-with-meinheld) |         81211.66  |     > 70  |   > 340  |
| [GO](#go)                 | [GO ServeMux](#go-servemux)                       |         81488.31  |    10.13  |   395.7  |
| [C-Sharp](#c-sharp)       | [Kestrel](#kestrel)                               |         83977.00  |  1050.08  |   409.8  |
| [Scala](#scala)           | [Colossus](#colossus)                             |         87025.70  |   599.89  |   286.4  |
| [Crystal](#crystal)       | [Crystal HTTP](#crystal-http)                     |        103109.33  |    10.24  |   110.4  |
| [Rust](#rust)             | [Tokio minihttp](#tokio-minihttp)                 |        104810.94  |     4.41  |    99.5  |
                                                                                                   
### Rack with Puma                                                                                 
I tested Ruby by using a plain [Rack](http://rack.github.io/) application with the [Puma](http://puhe [Puma](http://puma.io) application server.

#### Bootstrap
```shell
cd servers/rack_server && \
bundle exec puma -w 8 --preload -e production app.ru
```

#### Memory
Memory consumption is divided by: 
* 8 child process, each consuming about 16MB
* 1 parent process consuming about 11MB
* 3 additional processes monitor the balancer, consuming about 8MB

#### CPU
Puma uses all the available cores via pre-forking.

### Gunicorn with Meinheld
I started a plain WSGI application on the [Gunicorn](http://gunicorn.org/) application server wrapping [Meinheld](http://meinheld.org/) workers. 

#### Bootstrap
```shell
cd servers/ && \
gunicorn -w 8 gunicorn_server:app -b :9292 -k meinheld.gmeinheld.MeinheldWorker
```

#### Memory
Memory consumption is divided by:
* 8 child process, each consuming about 7MB
* 1 parent process consuming about 20MB

#### CPU
Gunicorn relies on pre-forking for parallelism.

### Node Cluster
I used the cluster library included into Node's standard library.

#### Bootstrap
```shell
node servers/node_server.js
```

#### Memory
Memory consumption is divided by:
* 8 child process, each consuming about 37MB
* 1 parent process consuming about 26MB

#### CPU
Node parallelizes multiple processes via pre-forking.

### Dart HttpServer
A plain HTTP server is embedded into the Dart standard library.

#### Bootstrap
```shell
dart servers/dart_server.dart
```

#### Memory
Memory consumption is average, considering just one process is spawned.

#### CPU
Dart server supports parallelism courtesy of the Isolate library, which abstracts multi-threading in server environment.

### Plug with Cowboy
I tested Elixir by using [Plug](https://github.com/elixir-lang/plug) library that provides a [Cowboy](https://github.com/ninenines/cowboy) adapter.

#### Bootstrap
```shell
cd servers/plug_server && \
MIX_ENV=prod mix compile && \
MIX_ENV=prod mix run --no-halt
```

#### Memory
Memory consumption is good for a VM language.

#### CPU
BEAM (Erlang VM) distributes loading on all of the available cores.

### Servlet3 with Jetty
To test Java i used [Jetty](http://www.eclipse.org/jetty/): a modern, stable and quite fast servlet container.  

#### Bootstrap
```shell
cd servers/jetty_server && \
javac -cp javax.servlet-3.0.0.v201112011016.jar:jetty-all-9.2.14.v20151106.jar HelloWorld.java && \
java -server -cp .:javax.servlet-3.0.0.v201112011016.jar:jetty-all-9.2.14.v20151106.jar HelloWorld
```

#### Memory
Memory footprint of the JVM is, unsurprisingly, high.

#### CPU
JVM support parallelism via multi-threading.

### Ring with Jetty
I used the default library to interface Clojure with HTTP: the [Ring](https://github.com/ring-clojure/ring) library.

#### Bootstrap
```shell
cd servers/ring_server && \
lein run
```

#### Memory
Memory footprint is worst than Java, probably because of the burden imposed by additional allocations.

#### CPU
Clojure leverages on the JVM to deliver parallelism.

### Colossus
To test Scala i used [Colossus](http://tumblr.github.io/colossus/): a lightweight framework for building high-performance network I/O applications.

#### Bootstrap
```shell
cd servers/colossus_server && \
sbt
> compile
> run
```

#### Memory
Scala memory footprint is the worst among JVM languages, i suspect the burden of Akka being the main cause.

#### CPU
Akka actors-based model allows Scala to support parallelism.

### Kestrel
To test C# i opted for [Kestrel](https://docs.microsoft.com/en-us/aspnet/core/fundamentals/servers/kestrel): a cross-platform web server based on the libuv asynchronous I/O library.

#### Bootstrap
```shell
cd servers/kestrel_server && \
dotnet restore && \
dotnet run
```

#### Memory
Memory consumption is far the worst of the tested languages, proving .NET outside of MS Windows still needs some tweaking.

#### CPU
Kestrel spawns multiple threads to grant parallelism.

### Kitura
[Kitura](http://www.kitura.io/) is a web framework and web server that is created for web services written in Swift.

#### Bootstrap
```shell
cd servers/kitura_server && \
swift build && \
.build/debug/kitura_server
```

#### Memory
Memory consumption is on par with other AOT compiled languages, thus good.

#### CPU
Kitura uses several threads to distribute the loading on all of the available cores.

### Asynchttpserver
I used the asynchttpserver module to implement an asynchronous server with Nim.  

#### Bootstrap
```shell
nim cpp -d:release servers/nim_server.nim && \
./servers/nim_server
```

#### Memory
Memory consumption is excellent.

#### CPU
Asynchttpserver is not parallel by implementation.

### Crystal HTTP
I used Crystal HTTP server standard library.  

#### Bootstrap
```shell
crystal build --release servers/crystal_server.cr && \
./crystal_server
```

#### Memory
Crystal memory usage is good, considering it embeds a garbage collector.

#### CPU
Crystal does not supports parallelism yet.

### GO ServeMux
I opted for the [HTTP ServeMux](https://golang.org/pkg/net/http/) GO standard library.  

#### Bootstrap
```shell
go run servers/go_server.go
```

#### Memory
GO memory consumption is good, considering the embedded runtime.

#### CPU
GO uses one routine per connection to run more than one core.

### Tokio minihttp
Rust standard library does not include a HTTP server, so i relied on a minimal library named [Tokio minihttp](https://github.com/tokio-rs/tokio-minihttp). 

#### Bootstrap
```shell
cd servers/tokio_minihttp && \
cargo clean && \
cargo build --release && \
cargo run --release
```

#### Memory
Memory footprint is outstanding.

#### CPU
Tokio minihttp server does not support parallelism.

## Conclusions

### Raw data
The benchmarks proved the throughput is not so different between pre-forked, VM-based and AOT languages, albeit not on a 4 core (8 hyper-threads) workstation.  
When looking at memory footprint the gap is much more clear: AOT languages leave pre-forked and VM-based ones in the dust.

### Different philosophies
These tests highlight the different philosophies behind each language: at one end there is GO's "battery-included" approach, at the other side there is Rust minimalism to require everything as an external dependency.  

### Concurrency VS parallelism
I am surprised that some of the fastest implementation does not relies on parallelism at all.  
The numbers will probably be different on a 32 cores rack, but considering the minimal `hosting-slice` has just 1 vCPU and 512MB RAM, you'd better ponder your options.

### A matter of taste
All that said, which language you'll pick is just a matter of personal taste.  
Just keep in mind there is no silver bullet: while you can do more or less everything with each of the tested languages, each of them excel on few specific use cases and struggle when used against their "true nature".
