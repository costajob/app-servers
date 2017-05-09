# Table of Contents

* [Scope](#scope)
  * [Hello World](#hello-world)
* [Languages](#languages)
  * [Ruby](#ruby)
  * [Python](#python)
  * [Node.js](#nodejs)
  * [Elixir](#elixir)
  * [Java](#java)
  * [Clojure](#clojure)
  * [Scala](#scala)
  * [C-Sharp](#c-sharp)
  * [Nim](#nim)
  * [Crystal](#crystal)
  * [Rust](#rust)
  * [GO](#go)
* [Benchmarks](#benchmarks)
  * [Platform](#platform)
  * [Wrk](#wrk)
  * [Results](#results)
  * [Plug with Cowboy](#plug-with-cowboy)
  * [Rack with Puma](#rack-with-puma)
  * [Nim asynchttpserver](#nim-asynchttpserver)
  * [Node Cluster](#node-cluster)
  * [Ring with Jetty](#ring-with-jetty)
  * [Rust Hyper](#rust-hyper)
  * [Gunicorn with Meinheld](#gunicorn-with-meinheld)
  * [Servlet3 with Jetty](#servlet3-with-jetty)
  * [GO ServeMux](#go-servemux)
  * [Kestrel](#kestrel)
  * [Colossus](#colossus)
  * [Crystal HTTP](#crystal-http)

## Scope
The idea behind this repository is to test how HTTP libraries for different languages behave under heavy loading.   

### Hello World
The "application" I tested is barely minimal: it is the HTTP version of the "Hello World" example.
The Content-Type header for each applications was set as "text/plain".

## Languages
I chose to test the following languages/runtime:

### Ruby
[Ruby](https://www.ruby-lang.org/en/) 2.4 is installed via homebrew.  
Ruby is a scripting language focused on simplicity and productivity, inspired by SmallTalk.  
Ruby is a purely object oriented language but it also supports functional and imperative paradigms. I tested Ruby MRI implementation, offering concurrency via threads and parallelism via pre-forking.

### Python
[Python](https://www.python.org/) 3.6 is installed by official OSX package.  
Python is a widely used high-level, general-purpose, interpreted, dynamic programming language.  
It supports several programming paradigms and can count on a broad standard library.

### Node.js
[Node.js](https://nodejs.org/en/) version 7.10 is installed by official OSX package.  
Node.js is based on the V8 engine, optimized by Google and supporting most of the new ES6 features.   
Node.js leverages on the JavaScript built-in event loop to grant concurrency. Parallelism is supported via pre-forking.

### Elixir
[Elixir](http://elixir-lang.org/) 1.4.2 is installed via homebrew.  
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
[C-Sharp](https://en.wikipedia.org/wiki/C_Sharp_(programming_language)) (C#) 7.0 language is installed as a companion of the [.NET Core](https://www.microsoft.com/net/core) 1.1 framework, by following the [official guideline](https://www.microsoft.com/net/core#macos).  
.NET Core is an open-source framework for running .NET applications cross platform.  
C# is a simple, powerful, type-safe, object-oriented language. It inherited many features from Java, but recently added some desirable paradigms such as futures, pattern matching and deconstructions.  

### Nim
[Nim](http://nim-lang.org/) 0.16.0 is installed from source.  
Nim is an efficient, Python inspired, strong typed language that comes with a pretty flexible compliler able to produce code in C (default), C++, JavaScript or ObjectiveC.  
Nim supports metaprogramming, functional, message passing, procedural, and object-oriented coding style.

### Crystal
[Crystal](http://crystal-lang.org/) 0.22.0 is installed via homebrew.  
Crystal has a syntax very close to Ruby, but brings some desirable features such as strong typing (hidden by a pretty smart type inference algorithm) and ahead of time compilation.  
For concurrency Crystal adopts the CSP model (like GO) and evented/IO to avoid blocking calls, but parallelism is not yet supported (fibers runs within a single threads).

### Rust
[Rust](https://www.rust-lang.org/) language version 1.17 is installed by official OSX package.  
According to the official site Rust is a systems programming language that runs blazingly fast, prevents segfaults, and guarantees thread safety.  
Rust grants parallelism by running safely on multiple threads courtesy of its pretty unique ownership model.

### GO
[GO](https://golang.org/) language version 1.8.1 is installed by official OSX package.  
GO focuses on simplicity by intentionally lacking features considered redundant (an approach i am a fan of). It tries to address verbosity by using type inference, duck typing and a dry syntax.  
At the same time GO takes a straight approach to parallelism, coming with built in [CSP](https://en.wikipedia.org/wiki/Communicating_sequential_processes) and green threads (goroutines).  

## Benchmarks
I decided to test each language by using the standard/built-in HTTP library, relying on external dependencies only when the language does not include one.

### Platform
I registered these benchmarks with a MacBook PRO 15 mid 2015 having these specs:
* OSX El Captain
* 2,2 GHz Intel Core i7 (4 cores)
* 16 GB 1600 MHz DDR3

### RAM and CPU
I measured RAM and CPU consumption by using the Apple XCode's Instruments and recording max consumption peak.  
For the languages relying on pre-forking i reported the total sum of RAM consumption and CPU usage per process.

### Wrk
I used [wrk](https://github.com/wg/wrk) as the loading tool.
I measured each application server six times, picking the best lap (but for VM based languages demanding longer warm-up).  
Here is the common script i used:

```shell
wrk -t 4 -c 100 -d30s --timeout 2000 http://127.0.0.1:9292
```

### Results
Here are the benchmarks results ordered by increasing throughput.

| App Server                                        | Requests/sec       | Avg. response size (B)  | Latency in ms (avg/stdev/max) | Memory (MB) |       %CPU | Threads nbr. |
| :------------------------------------------------ | -----------------: | ----------------------: | ----------------------------: | ----------: | ---------: | -----------: |
| [Plug with Cowboy](#plug-with-cowboy)             |          43686.45  |                    147  |           12.44/22.22/253.07  |      51.56  |     415.9  |          22  |
| [Rack with Puma](#rack-with-puma)                 |          52253.58  |                     71  |               0.25/0.53/7.10  |       ~230  |      ~420  |          80  |
| [Nim asynchttpserver](#nim-asynchttpserver)       |          66368.34  |                     47  |              1.50/0.25/25.86  |       7.15  |      99.9  |           1  |
| [Node Cluster](#node-cluster)                     |          75769.52  |                    147  |              1.54/1.92/66.08  |       ~316  |      ~551  |          48  |
| [Ring with Jetty](#ring-with-jetty)               |          78913.27  |                    157  |              1.44/2.82/84.67  |     127.30  |     558.7  |          73  |
| [Hyper.rs](#hyperrs)                              |          83310.50  |                     83  |               1.20/0.24/5.96  |      27.71  |     350.4  |           9  |
| [Servlet3 with Jetty](#servlet3-with-jetty)       |          83482.16  |                    150  |               1.18/0.12/8.48  |     247.90  |     405.5  |          46  |
| [Gunicorn with Meinheld](#gunicorn-with-meinheld) |          84679.61  |                    153  |               1.18/0.23/4.64  |        ~72  |      ~349  |           9  |
| [GO ServeMux](#go-servemux)                       |          85756.24  |                    122  |              1.16/0.26/16.99  |       9.06  |     410.1  |          17  |
| [Colossus](#colossus)                             |          89121.37  |                     72  |               1.12/0.16/9.95  |     693.18  |     294.2  |          39  |
| [Kestrel](#kestrel)                               |          90238.77  |                    116  |             1.70/8.72/192.61  |    1014.14  |     442.1  |          40  |
| [Crystal HTTP](#crystal-http)                     |         115670.14  |                     95  |               0.86/0.13/6.22  |       9.59  |     112.7  |           8  |

### Plug with Cowboy
I tested Elixir by using [Plug](https://github.com/elixir-lang/plug) library that provides a [Cowboy](https://github.com/ninenines/cowboy) adapter.

##### Bootstrap
```shell
MIX_ENV=prod mix compile
MIX_ENV=prod mix run --no-halt
```

##### Considerations
Elixir performance are not stellar. To be fair the BEAM VM is not famous to be fast, but to grant reliability and resilience over a distributed system.  
Cowboy includes several headers in the response, including cache-control, date and server, but surprisingly not the Content-Type one.  

##### Memory
Memory consumption is good, thanks to the fact that only one process is created.

##### Concurrency and parallelism
Elixir VM distributes the workloads on all of the available cores, thus supporting parallelism quite nicely.  

### Rack with Puma
I tested Ruby by using a plain [Rack](http://rack.github.io/) application with the [Puma](http://puma.io/) application server.  

##### Bootstrap
```shell
bundle exec puma -w 7 -t 0:2 app.ru
```

##### Considerations
Ruby delivers solid performance, with good latency. 
Average response size is small, meaning Puma discard some headers along the way (the date one).  

##### Memory
Memory consumption is pretty high (~30MB per process).  

##### Concurrency and parallelism
Because of MRI's GIL, Puma relies on the pre-forking model for parallelism: 8 processes are forked (one as supervisor), each spawning multiple threads (which i limited to get better throughput).

### Nim asynchttpserver
I used the Nim asynchttpserver module to implement a high performance asynchronous server.  
Nim's asyncdispatch library is hard to use with threads, so the server runs on a single core only.  

##### Bootstrap
```shell
nim cpp -d:release nim_server.nim
./nim_server
```

##### Considerations
Nim proved to keep its promises, being a fast and concise language.  
Nim HTTP library discards all of the response headers, but for the Content-Length one.

##### Memory
Memory consumption is very good: unsurprisingly, considering Nim executes on a single thread only.

##### Concurrency and parallelism
As expected Nim asynchttpserver is not parallel by implementation.

### Node Cluster
I used Node cluster library to spawn multiple processes, thus granting parallelism.

##### Bootstrap
```shell
node node_server.js
```

##### Considerations
JavaScript V8 on Node.js proved to be pretty fast, getting close to compiled languages.  
Node includes several response headers, including Connection type and Transfer-Encoding.  

##### Memory
Node.js is the most memory-hungry of pre-forked languages (~40MB per process).  

##### Concurrency and parallelism
Node relies on the reactor pattern to grant non-blocking calls and uses the pre-forking model to get parallelism.

### Ring with Jetty
I used the default library to interface Clojure with HTTP: the [Ring](https://github.com/ring-clojure/ring) library.

##### Bootstrap
```shell
lein run
```

##### Considerations
Ring runs on the Jetty server, thus there is no surprise it is quite close to Java throughput but for some additional burden imposed by additional allocations.  
Jetty satisfies the principal response headers.  

##### Memory
Memory footprint is a bit worst than Java+Jetty.

##### Concurrency and parallelism
Clojure leverages on the JVM to deliver parallelism.

### Hyper.rs
Rust does not include (yet) an HTTP server into its standard library, so i picked one of the more mature micro-framework available: [Hyper.rs](http://hyper.rs/). 

##### Bootstrap
```shell
export OPENSSL_INCLUDE_DIR=<path-to-openssl-includes>
cargo clean
cargo build --release
cargo run --release
```

##### Considerations
As expected Rust proved to be a fast language, but not faster than, say, GO.
Hyper just responds with Content-Length and Date headers.

##### Memory
Memory footprint is higher than other binary-compiling langugages.

##### Concurrency and parallelism
As expected Rust makes use of every available cores. 

### Servlet3 with Jetty
To test Java i used [Jetty](http://www.eclipse.org/jetty/): a modern, stable and quite fast servlet container.  

##### Bootstrap
```shell
javac -cp javax.servlet-3.0.0.v201112011016.jar:jetty-all-9.2.14.v20151106.jar HelloWorld.java
java -server -cp .:javax.servlet-3.0.0.v201112011016.jar:jetty-all-9.2.14.v20151106.jar HelloWorld
```

##### Considerations
I know Java is pretty fast nowadays: thousands of optimizations have been done to the JVM during the last two decades.  
Again Jetty is consistent treating response headers.  

##### Memory
Memory footprint of the JVM is unsurprisingly high.

##### Concurrency and parallelism
JVM allows Java to use all of the available cores.  

### Gunicorn with Meinheld
I started a plain WSGI application on the [Gunicorn](http://gunicorn.org/) application server wrapping [Meinheld](http://meinheld.org/) workers. 

##### Bootstrap
```shell
gunicorn -w 7 gunicorn_server:app -b :9292 -k meinheld.gmeinheld.MeinheldWorker
```

##### Considerations
Gunicorn and Meinheld combination is blazing fast, surpassing even some compiled languages.  
Mainheld responds with all of the principal HTTP headers.  

##### Memory
Memory footprint is good, considering Gunicorn pre-forks eight processes (~7MB per process). 

##### Concurrency and parallelism
Gunicorn relies on the pre-forking model to grant parallelism.

### GO ServeMux
I opted for the [HTTP ServeMux](https://golang.org/pkg/net/http/) GO standard library.  

##### Bootstrap
```shell
go build go_server.go
./go_server
```

##### Considerations
GO is a pretty fast language and allows using all of the cores with no particular configuration since version 1.5.  
ServerMux honors both contents headers.  

##### Memory
Memory consumption and resiliency are really good.

##### Concurrency and parallelism
GO uses one routine per connection to distribute the load on all of the cores.

### Colossus
To test Scala i used [Colossus](http://tumblr.github.io/colossus/): a lightweight framework for building high-performance network I/O applications.

##### Bootstrap
```shell
sbt
> compile
> run
```

##### Considerations
Scala in combination with [Akka](http://akka.io/) (the toolkit on which Colossus is build) proves to be performant.  
Colossus gets better throughput than other JVM languages, but just returns content headers.

##### Memory
Scala memory footprint is on the deeper waters of the river.

##### Concurrency and parallelism
JVM allows Scala to use all of the available cores.  

### Kestrel
To test C# i opted for [Kestrel](https://docs.microsoft.com/en-us/aspnet/core/fundamentals/servers/kestrel): a cross-platform web server based on the libuv asynchronous I/O library and included by default in the .NET Core template.

##### Bootstrap
```shell
dotnet restore
dotnet run
```

##### Considerations
Kestrel throughput is very good, althrough its consistency is just fair.  
Kestrel discards content headers, preserving just Date, Server and Transfer-Encoding ones.  

##### Memory
Memory consumption is the worst of the package, proving .NET outside of MS Windows still needs some tweaking.

##### Concurrency and parallelism
Kestrel spawns multiple threads by default to grant parallelism.

### Crystal HTTP
I used Crystal HTTP server standard library.  
Crystal uses green threads, called "fibers", spawned inside an event loop via the [libevent](http://libevent.org/) library.

##### Bootstrap
```shell
crystal build --release ./server/crystal_server.cr
./crystal_server
```

##### Considerations
Crystal language recorded the best lap of the pack, outstanding considering it does not rely on parallelism at all. 
Crystal HTTP library honors the main content headers.

##### Memory
Memory consumption and resiliency are very good.  

##### Concurrency and parallelism
As expected Crystal does not supports parallelism yet.
