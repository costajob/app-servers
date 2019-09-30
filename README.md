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
  * [Hyper](#hyper)

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
[Node.js](https://nodejs.org/en/) version 12.11.0 is installed by official OSX package.  
Node.js is based on the V8 JavaScript engine, optimized by Google and supporting most of the new language's features.   

### Dart
[Dart](https://www.dartlang.org/) version 2.5.1 is installed via homebrew.  
Dart is a VM based, object-oriented, sound typed language using a C-style syntax that transcompiles optionally into JavaScript.

### Elixir
[Elixir](http://elixir-lang.org/) 1.9.1 is installed via homebrew.  
Elixir is a purely functional language that runs on the [Erlang](https://www.erlang.org/) VM and is strongly influenced by the Ruby syntax.

### Java
[Java](https://www.java.com/en/) JDK 12.0.1 is installed by official OSX package.  
Java is a VM based, statically typed, general-purpose language that is thread safe, object-oriented and, from version 8, supports functional paradigms.

### Crystal
[Crystal](http://crystal-lang.org/) 0.31.0 is installed via homebrew.  
Crystal has a syntax very close to Ruby, but brings some desirable features such as statically typing and ahead of time (AOT) compilation.  

### Nim
[Nim](http://nim-lang.org/) 1.0.0 is installed via homebrew.  
Nim is an AOT, Python inspired, statically typed language that comes with an ambitious compiler aimed to produce code in C, C++, JavaScript or ObjectiveC.

### GO
[GO](https://golang.org/) language version 1.13.1 is installed by official OSX package.  
GO is an AOT language that focuses on simplicity and offers a broad standard library with [CSP](https://en.wikipedia.org/wiki/Communicating_sequential_processes) constructs built in.

### Rust
[Rust](https://www.rust-lang.org/) language version 1.38.0 is installed by official package.  
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
| [Elixir](#elixir)         | [Plug with Cowboy](#plug-with-cowboy)             |         42576.07  |     45.3  |   619.0  |
| [Dart](#dart)             | [Dart HttpServer](#dart-httpserver)               |         46801.31  |     37.6  |   539.3  |
| [Ruby](#ruby)             | [Puma](#puma)                                     |         52613.27  |    > 110  |   > 520  |
| [GO](#go)                 | [GO ServeMux](#go-servemux)                       |         83465.51  |      8.4  |   554.3  |
| [JavaScript](#javascript) | [Node Cluster](#node-cluster)                     |         88191.81  |    > 150  |   > 300  |
| [Rust](#rust)             | [Hyper](#hyper)                                   |         92338.90  |      4.5  |   450.0  |
| [Python](#python)         | [Gunicorn with Meinheld](#gunicorn-with-meinheld) |         99332.36  |     > 40  |   > 380  |
| [Java](#java)             | [Jetty NIO](#jetty-nio)                           |        105190.80  |    233.1  |   436.3  |
| [Nim](#nim)               | [httpbeast](#httpbeast)                           |        113488.20  |     24.1  |    99.7  |
| [Crystal](#crystal)       | [Crystal HTTP](#crystal-http)                     |        116210.94  |      8.4  |   282.3  |

                                                                                                   
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
I used the async HTTP server embedded into the Dart standard library and compiled it with AOT runtime.

#### Bootstrap
```shell
dart2aot servers/dart_server.dart ./dart_server.dart.aot
dartaotruntime dart_server.dart.aot
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


### Crystal HTTP
I used Crystal HTTP server standard library, enabling parallelism by using the `preview` flag.  

#### Bootstrap
```shell
crystal build -Dpreview_mt --release servers/crystal_server.cr
./crystal_server
```


### httpbeast
To test Nim i opted for the [httpbeast](https://github.com/dom96/httpbeast) library: an asynchronous server relying on Nim HTTP standard library.

#### Bootstrap
```shell
nim c --threads:on servers/httpbeast_server.nim
./servers/httpbeast_server
```


### GO ServeMux
I used the [HTTP ServeMux](https://golang.org/pkg/net/http/) GO standard library.

#### Bootstrap
```shell
go run servers/servemux_server.go
```


### Hyper
I tested Rust by using the [Hyper](https://hyper.rs/), an HTTP implementation based on Tokio.io.

#### Bootstrap
```shell
cd servers/hyper_server
cargo run --release
```
