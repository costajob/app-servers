## Table of Contents

* [Scope](#scope)
  * [Hello World](#hello-world)
  * [Platform](#platform)
  * [Wrk](#wrk)
* [Languages](#languages)
  * [Ruby](#ruby)
  * [JRuby](#jruby)
  * [Elixir](#elixir)
  * [Node.js](#nodejs)
  * [GO](#go)
  * [Java](#java)
  * [Crystal](#crystal)
* [Benchmarks](#benchmarks)
  * [Results](#results)
  * [Rack](#rack)
  * [Plug](#plug)
  * [Node Cluster](#node-cluster)
  * [ServeMux](#servemux)
  * [Jetty](#jetty)
  * [Crystal HTTP](#crystal-http)

## Scope
The idea behind this repository is to test how HTTP libraries for different languages behave under heavy loading.   

### Hello World
The "application" i tested is barely minimal: it is the HTTP version of the "Hello World" example.

### Platform
I registered these benchmarks with a MacBook PRO 15 late 2011 having these specs:
* OSX El Captain
* 2,2 GHz Intel Core i7 (4 cores)
* 8 GB 1333 MHz DDR3

### Wrk
I used [wrk](https://github.com/wg/wrk) as the loading tool.
I measured each application server three times, picking the best lap.  
Here is the common script i used:

```
wrk -t 4 -c 150 -d30s --timeout 2000 http://127.0.0.1:<port>
```

## Languages
I chose to test the following languages/runtime:

### Ruby
[Ruby](https://www.ruby-lang.org/en/) 2.3 is installed via homebrew.  
Ruby is the language i have more experience with.  
I find it an enjoyable language to code with, with a plethora of good libraries and a lovely community.

### JRuby
[JRuby](http://jruby.org/) 9.1.2.0 is installed via official distribution.  
JRuby is the Ruby implementation on the JVM: it supports multi-threading and cope with Ruby MRI pretty closely.

### Elixir
[Elixir](http://elixir-lang.org/) 1.2.5 version is installed via homebrew.  
I studied Elixir in 2015, surfing the wave of [Prag-Dave](https://pragdave.me/) enthusiasm and finding its *rubyesque* resemblance inviting.  
Being based on [Erlang](https://www.erlang.org/) it supports parallelism out of the box by spawning small (2Kb) processes.

### Node.js
[Node.js](https://nodejs.org/en/) stable version (4.x) is installed by official OSX package.  
I once used to code in JavaScript much more than today. I left it behind in favor or more "backend" languages: it is a shame, since V8 is pretty fast, ES6 has filled many language lacks and the rise of Node.js has proven JavaScript is much more than an in-browser tool.

### GO
[GO](https://golang.org/) language version 1.6.2 is installed by official OSX package.  
GO focuses on simplicity by intentionally lacking features considered redundant (an approach i am a fan of). It tries to address verbosity by using type inference, duck typing and a dry syntax.  
At the same time GO takes a straight approach to parallelism, coming with built in [CSP](https://en.wikipedia.org/wiki/Communicating_sequential_processes) and green threads (goroutines).  

### Java
[Java](https://www.java.com/en/) 8 comes pre-installed on Xcode 7.31.  
I get two Sun certifications back in 2006 and realized the more i delved into Java the less i liked it.
Ignoring Java on this comparison is not an option anyway: Java is the most used programming language in the world (2016) and some smart folks have invested on it since the 90ies.

### Crystal
[Crystal](http://crystal-lang.org/) 0.18.2 is installed via homebrew.  
Crystal has a syntax very close to Ruby, but brings some fresh features such as type checking and compilation to highly optimized native code.  
In order to mimic dynamic languages Crystal relies on a global type inference algorithm.   
Crystal adopts the CSP model (like GO) and evented/IO to grant concurrency and avoid blocking calls, but does not support parallelism out of the box.

## Benchmarks
I decided to test each language by using the standard/built-in HTTP library.

### Results
Here are the benchmarks results ordered by increasing throughput.

| App Server                             | Throughput (req/s) | Latency in ms (avg/stdev/max) |
| :------------------------------------- | -----------------: | ----------------------------: |
| [Rack](#rack)                          |          29208.81  |             3.13/0.348/13.28  |
| [JRuby-Rack](#jruby-results)           |          32331.47  |             0.99/0.598/44.34  |
| [Plug](#plug)                          |          33583.07  |             3.35/7.62/145.87  |
| [Node Cluster](#node-cluster)          |          47576.68  |             2.51/3.40/120.02  |
| [Jetty](#jetty)                        |          52398.88  |             1.90/0.432/22.45  |
| [ServeMux](#servemux)                  |          58359.97  |             1.70/0.315/18.63  |
| [Crystal HTTP](#crystal-http)          |          75159.45  |              1.33/0.270/6.02  |

### Rack
I tested ruby by using a plain [Rack](http://rack.github.io/) application.  
Rack is the Ruby standard HTTP server interface implemented by Puma (and other HTTP server).

##### Bootstrap
```
bundle exec puma -w 8 --preload -t 16:32 app.ru
jruby -S bundle exec puma -t 16:32 app.ru
```

##### Considerations
Rack proves to be a pretty fast HTTP server. It's modular, easy to extend and battle tested.  

##### JRuby results
JRuby constantly performs slightly better than MRI: Puma leverage on native threads for parallelism, instead of pre-forking a pool of processes.  
Said that JVM need to warm up to do its best and consume much memory than MRI.

### Plug
I tested Elixir by using [Plug](https://github.com/elixir-lang/plug) library that provides a [Cowboy](https://github.com/ninenines/cowboy) adapter.

##### Bootstrap
I started elixir by using iex interactive console as described on Plug read-me.

##### Considerations
Elixir performance are pretty solid but not stellar.  
To be fair Erlang, and by reflection Elixir, benefits most by using the bulky OTP library to grant reliability and resilience over a distributed system.  
Being an immutable language, Elixir also consumes less memory when serving more articulated views.

### Node Cluster
I used Node cluster library to spawn one process per CPU.

##### Bootstrap
```
node node_server.js
```

##### Considerations
While it is true that Node.js suffers JavaScript single threaded nature, it delivered very solid performance.  
By using cluster library to spawn multiple processes per CPU, Node speed is on par
with faster compiled languages.

### ServeMux
I opted for the [HTTP ServeMux](https://golang.org/pkg/net/http/) GO standard library.

##### Bootstrap
```
go build go_server.go
./go_server
```

##### Considerations
GO is a pretty fast language and allows using all of the cores with no particular configuration.  
The results delivered by GO is consistent, with a standard deviation always under control.  

### Jetty
To test Java i used [Jetty](http://www.eclipse.org/jetty/): a modern, stable and quite fast servlet container.  

##### Bootstrap
I followed the minimal Hello World tutorial by Eclipse.

##### Considerations
I know Java is pretty fast nowadays: thousands of optimizations have been done to the JVM and many corporates have invested too much in Java to leave it behind.  

### Crystal HTTP
I used Crystal HTTP server standard library. Crystal uses green threads called "fibers", that runs on a single process (thus allowing concurrency, but not parallelism).  
According to the core team multi-threads support will be added to the language before reaching production phase.

##### Bootstrap
```
crystal build ./server/crystal_server.cr --release
./crystal_server
```

##### Considerations
Crystal language recorded the best lap of the pack, outperforming more mature languages like GO and Java.  
This is even more interesting considering the language executes on a single thread only and let ponder how fast the platform could be once multi-threading will be thrown in. 
