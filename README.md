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
  * [Crystal](#crystal)
  * [Nim](#nim)
  * [GO](#go)
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
I have became lazy with years and just adopt languages i can install via `homebrew`, sorry Oracle/MS. This also allows me to benchmark them in a single session, thus trying to use an environment as neutral as possible.
Where possible i just relied on the standard library, but when it is not production-ready (i.e. Ruby, Python).

### Ruby
[Ruby](https://www.ruby-lang.org/en/) 3.0.0 is used. 
Ruby is a general-purpose, interpreted, dynamic programming language, focused on simplicity and productivity. 

### Python
[Python](https://www.python.org/) 3.9.1 is used.
Python is a widely used high-level, general-purpose, interpreted, dynamic programming language.  

### JavaScript
[Node.js](https://nodejs.org/en/) version 15.5.0 is used.
Node.js is based on the V8 JavaScript engine, optimized by Google and supporting most of the new language's features.   

### Dart
[Dart](https://www.dartlang.org/) version 2.10.4 is used.
Dart is a VM based, object-oriented, sound typed language using a C-style syntax that transcompiles optionally into JavaScript.

### Elixir
[Elixir](http://elixir-lang.org/) 1.11.2 is used.
Elixir is a purely functional language that runs on the [Erlang](https://www.erlang.org/) VM and is strongly influenced by the Ruby syntax.

### Crystal
[Crystal](http://crystal-lang.org/) 0.35.1 is used.
Crystal has a syntax very close to Ruby, but brings some desirable features such as statically typing and ahead of time (AOT) compilation.  

### Nim
[Nim](http://nim-lang.org/) 1.4.2 is used.
Nim is an AOT, Python inspired, statically typed language that comes with an ambitious compiler aimed to produce code in C, C++, JavaScript or ObjectiveC.

### GO
[GO](https://golang.org/) 1.15.6 is used.
GO is an AOT language that focuses on simplicity and offers a broad standard library with [CSP](https://en.wikipedia.org/wiki/Communicating_sequential_processes) constructs built in.

## Tools

### Wrk
I used [wrk](https://github.com/wg/wrk) as the loading tool.  
I measured each application server six times, picking the best lap (but for VM based languages demanding longer warm-up).  
```shell
wrk -t 4 -c 100 -d30s --timeout 2000 http://0.0.0.0:9292
```

### Platform
These benchmarks are recorded on a MacBook PRO 13 2019 having these specs:
* macOS Catalina
* 1.4 GHz Quad-Core Intel Core i5
* 8 GB 2133 MHz LPDDR3

### RAM and CPU
I measured RAM and CPU consumption by using macOS Activity Monitor dashboard and recording max consumption peak.  
For the languages relying on pre-forking parallelism i reported the average consumption by taking a snapshot during the stress period.

## Benchmarks

### Results
| Language                  | App Server                                        | Requests/sec      | RAM (MB)  | CPU (%)  |
| :------------------------ | :------------------------------------------------ | ----------------: |---------: |--------: |
| [Ruby+MJIT](#ruby)        | [Puma](#puma)                                     |         36455.88  |    > 100  |   > 580  |
| [Elixir](#elixir)         | [Plug with Cowboy](#plug-with-cowboy)             |         46416.25  |     50.5  |   583.8  |
| [Ruby](#ruby)             | [Puma](#puma)                                     |         47975.36  |    > 100  |   > 580  |
| [Dart](#dart)             | [Dart HttpServer](#dart-httpserver)               |         59335.33  |    193.2  |   429.1  |
| [JavaScript](#javascript) | [Node Cluster](#node-cluster)                     |         87208.47  |    > 200  |   > 240  |
| [GO](#go)                 | [GO ServeMux](#go-servemux)                       |        103847.10  |     10.0  |   429.1  |
| [Python](#python)         | [Gunicorn with Meinheld](#gunicorn-with-meinheld) |        120105.65  |     > 40  |   > 380  |
| [Nim](#nim)               | [httpbeast](#httpbeast)                           |        128257.98  |     11.4  |    99.6  |
| [Crystal](#crystal)       | [Crystal HTTP](#crystal-http)                     |        132699.78  |      8.5  |   246.7  |

                                                                                                   
### Puma
I tested Ruby by using a plain [Rack](http://rack.github.io/) application served by [Puma](http://puma.io).  

#### Bootstrap
```shell
RUBYOPT='--jit' puma -w 8 -t 2 --preload servers/rack_server.ru
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
I used the async HTTP server embedded into the Dart standard library and compiled it with `dart2native` AOT compiler.

#### Bootstrap
```shell
dart2native servers/dart_server.dart -k aot
dartaotruntime servers/dart_server.aot
```


### Plug with Cowboy
I tested Elixir by using [Plug](https://github.com/elixir-lang/plug) library that provides a [Cowboy](https://github.com/ninenines/cowboy) adapter.

#### Bootstrap
```shell
cd servers/plug_server
MIX_ENV=prod mix compile
MIX_ENV=prod mix run --no-halt
```


### Crystal HTTP
I used Crystal HTTP server standard library, enabling parallelism by using the `preview_mt` flag.  

#### Bootstrap
```shell
crystal build -Dpreview_mt --release servers/crystal_server.cr
./crystal_server
```


### httpbeast
To test Nim i opted for the [httpbeast](https://github.com/dom96/httpbeast) library: an asynchronous server relying on Nim HTTP standard library.

#### Bootstrap
```shell
nim c -d:release --threads:on servers/httpbeast_server.nim
./servers/httpbeast_server
```


### GO ServeMux
I used the [HTTP ServeMux](https://golang.org/pkg/net/http/) GO standard library.

#### Bootstrap
```shell
go run servers/servemux_server.go
```
