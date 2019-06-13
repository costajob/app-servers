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
  * [C-sharp](#c-sharp)
  * [Crystal](#crystal)
  * [Nim](#nim)
  * [GO](#go)
  * [Rust](#rust)
* [Tools](#tools)
  * [Wrk](#wrk)
  * [Platform](#platform)
  * [RAM and CPU](#ram-and-cpu)
* [Benchmarks](#benchmarks)
  * [Results](#results)
  * [Puma](#puma)
  * [Gunicorn with Meinheld](#gunicorn-with-meinheld)
  * [Node Cluster](#node-cluster)
  * [Dart HttpServer](#dart-httpserver)
  * [Plug with Cowboy](#plug-with-cowboy)
  * [Jetty NIO](#jetty-nio)
  * [Kestrel](#kestrel)
  * [Crystal HTTP](#crystal-http)
  * [httpbeast](#httpbeast)
  * [GO ServeMux](#go-servermux)
  * [Actix Web](#actix-web)

## Scope
The idea behind this repository is to benchmark different languages implementation of HTTP server.

### Hello World
The *application* i tested is minimal: the HTTP version of the *Hello World* example.  
This approach allows including languages i barely know, since it is pretty easy to find such implementation online.  
If you're looking for more complex examples, you will have better luck with the [TechEmpower benchmarks](https://www.techempower.com/benchmarks/).

### Disclaimer
Please do take the following numbers with a grain of salt: it is not my intention to promote one language over another basing on micro-benchmarks.  
Indeed you should never pick a language just basing on its presumed performance.

## Languages
I have filtered the languages by single runtime (i.e. Java on JVM): this way i can focus on a specific stack, keeping it updated to the last available version/APIs. 
Where possible i just relied on the standard library, but when it is not production-ready (i.e. Ruby, Python) or where the language footprint is deliberately minimal (i.e. Rust). 

### Ruby
[Ruby](https://www.ruby-lang.org/en/) 2.6.3 is installed via [rbenv](https://github.com/rbenv/rbenv).  
Ruby is a general-purpose, interpreted, dynamic programming language, focused on simplicity and productivity. 

### Python
[Python](https://www.python.org/) 3.7.3 is installed via homebrew.  
Python is a widely used high-level, general-purpose, interpreted, dynamic programming language.  

### JavaScript
[Node.js](https://nodejs.org/en/) version 12.4.0 is installed by official OSX package.  
Node.js is based on the V8 JavaScript engine, optimized by Google and supporting most of the new language's features.   

### Dart
[Dart](https://www.dartlang.org/) version 2.3.2 is installed via homebrew.  
Dart is a VM based, object-oriented, sound typed language using a C-style syntax that transcompiles optionally into JavaScript.

### Elixir
[Elixir](http://elixir-lang.org/) 1.8.2 is installed via homebrew.  
Elixir is a purely functional language that runs on the [Erlang](https://www.erlang.org/) VM and is strongly influenced by the Ruby syntax.

### Java
[Java](https://www.java.com/en/) JDK 12.0.1 is installed by official OSX package.  
Java is a VM based, statically typed, general-purpose language that is thread safe, object-oriented and, from version 8, supports functional paradigms.

### C-sharp
[C-sharp](https://en.wikipedia.org/wiki/C_Sharp_(programming_language)) (C#) 7.0 language is part of the [.NET Core](https://www.microsoft.com/net/core) 2.2.4 framework.  
C# is a VM based, statically typed, thread safe, object-oriented language.

### Crystal
[Crystal](http://crystal-lang.org/) 0.29.0 is installed via homebrew.  
Crystal has a syntax very close to Ruby, but brings some desirable features such as statically typing and ahead of time (AOT) compilation.  

### Nim
[Nim](http://nim-lang.org/) 0.20.0 is installed via homebrew.  
Nim is an AOT, Python inspired, statically typed language that comes with an ambitious compiler aimed to produce code in C, C++, JavaScript or ObjectiveC.

### GO
[GO](https://golang.org/) language version 1.12.6 is installed by official OSX package.  
GO is an AOT language that focuses on simplicity and offers a broad standard library with [CSP](https://en.wikipedia.org/wiki/Communicating_sequential_processes) constructs built in.

### Rust
[Rust](https://www.rust-lang.org/) language version 1.35.0 is installed by official package.  
Rust is an AOT, garbage collector free programming language, preventing segfaults and granting thread safety.

## Tools

### Wrk
I used [wrk](https://github.com/wg/wrk) as the loading tool.  
I measured each application server six times, picking the best lap (but for VM based languages demanding longer warm-up).  
```shell
wrk -t 4 -c 100 -d30s --timeout 2000 http://0.0.0.0:9292
```

### Platform
These benchmarks are recorded on a MacBook PRO 15 mid 2015 having these specs:
* macOS High Sierra
* 2.2 GHz Intel Core i7 (4 cores)
* 16 GB 1600 MHz DDR3

### RAM and CPU
I measured RAM and CPU consumption by using macOS Activity Monitor dashboard and recording max consumption peak.  
For the languages relying on pre-forking parallelism i reported the average consumption by taking a snapshot during the stress period.

## Benchmarks

### Results
| Language                  | App Server                                        | Requests/sec      | RAM (MB)  | CPU (%)  |
| :------------------------ | :------------------------------------------------ | ----------------: |---------: |--------: |
| [Dart](#dart)             | [Dart HttpServer](#dart-httpserver)               |         36582.58  |    171.5  |   539.3  |
| [Elixir](#elixir)         | [Plug with Cowboy](#plug-with-cowboy)             |         42882.01  |     45.3  |   619.0  |
| [Ruby](#ruby)             | [Puma](#puma)                                     |         56407.56  |    > 110  |   > 520  |
| [GO](#go)                 | [GO ServeMux](#go-servemux)                       |         71541.10  |      8.4  |   554.3  |
| [Crystal](#crystal)       | [Crystal HTTP](#crystal-http)                     |         74116.73  |      8.4  |   105.1  |
| [C-Sharp](#c-sharp)       | [Kestrel](#kestrel)                               |         84942.38  |   > 1500  |   516.4  |
| [Rust](#rust)             | [Actix Web](#actix-web)                           |         86608.21  |     19.2  |   345.4  |
| [JavaScript](#javascript) | [Node Cluster](#node-cluster)                     |         88414.08  |    > 200  |   > 300  |
| [Nim](#nim)               | [httpbeast](#httpbeast)                           |         92058.25  |      3.4  |    99.7  |
| [Python](#python)         | [Gunicorn with Meinheld](#gunicorn-with-meinheld) |        100735.84  |     > 40  |   > 380  |
| [Java](#java)             | [Jetty NIO](#jetty-nio)                           |        105333.17  |    233.1  |   436.3  |

                                                                                                   
### Puma
I tested Ruby by using a plain [Rack](http://rack.github.io/) application served by [Puma](http://puma.io).

#### Bootstrap
```shell
puma -w 8 -t 2 --preload servers/rack_server.ru
```


### Gunicorn with Meinheld
I tested Python by using [Gunicorn](http://gunicorn.org/) spawning [Meinheld](http://meinheld.org/) workers with a plain WSGI compliant server.

#### Bootstrap
```shell
cd servers
gunicorn -w 4 -k meinheld.gmeinheld.MeinheldWorker -b :9292 wsgi_server:app
```


### Node Cluster
I used the cluster module included into Node's standard library.

#### Bootstrap
```shell
node servers/node_server.js
```


### Dart HttpServer
I used the async HTTP server embedded into the Dart standard library.

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


### Jetty NIO
I tested Java by using [Jetty](http://www.eclipse.org/jetty/) with the non blocking IO (NIO) APIs.  

#### Bootstrap
```shell
cd servers/jetty_server
javac -cp jetty-all-uber.jar HelloWorld.java
java -server -cp .:jetty-all-uber.jar HelloWorld
```


### Kestrel
To test C# i opted for [Kestrel](https://docs.microsoft.com/en-us/aspnet/core/fundamentals/servers/kestrel): a cross-platform web server based on the libuv asynchronous I/O library.

#### Bootstrap
```shell
cd servers/kestrel_server
dotnet restore
dotnet run --configuration Release
```


### Crystal HTTP
I used Crystal HTTP server standard library, not supporting parallelism yet.  

#### Bootstrap
```shell
crystal build --release servers/crystal_server.cr
./crystal_server
```


### httpbeast
To test Nim i opted for the [httpbeast](https://github.com/dom96/httpbeast) library: an asynchronous server relying on Nim HTTP standard library.

#### Bootstrap
```shell
nim c -d:release servers/httpbeast_server.nim
./servers/httpbeast_server
```


### GO ServeMux
I used the [HTTP ServeMux](https://golang.org/pkg/net/http/) GO standard library.

#### Bootstrap
```shell
go run servers/servemux_server.go
```


### Actix Web
I tested Rust by using the [Actix](https://actix.rs/) actor system, also inclusive of a Web framework.

#### Bootstrap
```shell
cd servers/actix_server
cargo run --release
```
