## Table of Contents

* [Scope](#scope)
* [Languages](#languages)
  * [Ruby](#ruby)
  * [JRuby](#jruby)
  * [Python](#python)
  * [Haskell](#haskell)
  * [Elixir](#elixir)
  * [Node.js](#nodejs)
  * [GO](#go)
  * [Java](#java)
  * [Crystal](#crystal)
* [Benchmarks](#benchmarks)
  * [Hello World](#hello-world)
  * [Platform](#platform)
  * [Wrk](#wrk)
  * [Rails, Sinatra, Roda and rack](#rails-sinatra-roda-and-rack)
  * [Tornado](#tornado)
  * [Snap](#snap)
  * [Plug](#plug)
  * [Node Cluster](#node-cluster)
  * [ServeMux](#servemux)
  * [Jetty](#jetty)
  * [Crystal HTTP](#crystal-http)

## Scope
The idea behind this repository is to test out how different languages HTTP libraries behave under high loading.   

## Languages
I chose to test the following languages/runtime: Ruby, Crystal, Python, Elixir, Haskell, Node.js, GO, Java.

### Ruby
[Ruby](https://www.ruby-lang.org/en/) 2.3 is installed via homebrew.  
Ruby is the language i have more experience with.  
I find it an enjoyable language to code with, with a plethora of good libraries and a lovely community.

### JRuby
[JRuby](http://jruby.org/) 9.1.2.0 is installed via official distribution.  
JRuby is the Ruby implementation on the JVM: it supports multi-threading and cope with the Ruby release pretty closely.

### Python
[Python](https://www.python.org/) 2.7 comes pre-installed on OSX El Captain. 
I included Python just to see how it compares versus Ruby. I never had the urge to learn Python, the same way pythonians do not look at Ruby.  

### Haskell
[Haskell](https://www.haskell.org/) 7.10.3 is installed by official OSX package.  
Haskell is a purely functional, strong typed, garbage collected, compiled language.
Haskell's weird, terse syntax has relegated it to the academic world (but for specific [use cases](https://code.facebook.com/posts/745068642270222/fighting-spam-with-haskell/)).  

### Elixir
[Elixir](http://elixir-lang.org/) 1.2.5 version is installed via homebrew.
I studied Elixir in 2015, surfing the wave of [Prag-Dave](https://pragdave.me/) enthusiasm and finding its *rubyesque* resemblance inviting.
Being based on [Erlang](https://www.erlang.org/) it supports parallelism out of the box with small (2Kb) processes.

### Node.js
[Node.js](https://nodejs.org/en/) stable version (4.x) is installed by official OSX package.
I once used to program in JavaScript much more that these days. I left it behind in favor or more "backend" languages. I know it's a shame, since V8 is pretty fast, ES6 has filled many language lacks and the rise of Node.js has proven JavaScript is much more than an in-browser tool.

### GO
[GO](https://golang.org/) language version 1.6.2 is installed by official OSX package.  
GO focuses on simplicity by intentionally lacking features considered redundant (i.e. inheritance, exception handling, generics). It tries to address verbosity by using type inference, duck typing and a dry syntax.  
At the same time GO takes a straight approach to parallelism, coming with build in [CSP](https://en.wikipedia.org/wiki/Communicating_sequential_processes) and green threads (goroutines).  

### Java
[Java](https://www.java.com/en/) 8 comes pre-installed on Xcode 7.31.  
I get two Sun certifications back in 2006 and realized the more i delved into Java the less i liked it.
Ignoring Java on this comparison is not an option anyway: Java is the most used programming language in the world (2016) and some smart folks have invested on it since the 90ies.

### Crystal
[Crystal](http://crystal-lang.org/) 0.17.3 is installed via homebrew.
Crystal has a syntax similar to Ruby (indeed is quite impressive how much of Ruby good parts are in the language), but brings some desirable features such as compile-time type checking, efficient garbage collector and compilation to highly optimized native code.  
In order to mimic dynamic languages Crystal relies on a global type inference algorithm (similar to Haskell).  
Crystal adopts the CSP model (like GO) and evented/IO to grant concurrency and avoid blocking calls, but does not support parallelism out of the box.

## Benchmarks
I decided to test how these languages manage multiple HTTP requests by using standard libraries and/or micro-frameworks.  
One exception is [Rails](http://rubyonrails.org/): since many start-ups favor other languages over Ruby for APIs based applications, i dare to illustrate how Rails compare to more micro-service friendly Ruby frameworks.

### Hello World
The "application" i tested is barely minimal: is the HTTP version of the "Hello World" example.

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

### Results
Here are the benchmarks results ordered by increasing throughput.

| App Server                             | Throughput (req/s) | Latency in ms (avg/stdev/max) |
| :------------------------------------- | -----------------: | ----------------------------: |
| [Rails](#rails-sinatra-roda-and-rack)  |           2522.94  |            40.35/18.02241.45  |
| [JRuby-Rails](#jruby-results)          |           4088.59  |             7.85/4.85/108.82  |
| [Tornado](#tornado)                    |           7880.15  |             12.74/4.48/80.41  |
| [Snap](#snap)                          |           8508.51  |            11.87/4.39/176.70  |
| [Sinatra](#rails-sinatra-roda-and-rack)|          15484.45  |            8.34/11.76/235.75  |
| [JRuby-Sinatra](#jruby-results)        |          16649.11  |             1.53/6.38/127.03  |
| [Roda](#rails-sinatra-roda-and-rack)   |          28557.31  |             2.99/0.534/33.40  |
| [JRuby-Roda](#jruby-results)           |          30535.45  |             1.07/1.19/132.54  |
| [Rack](#rails-sinatra-roda-and-rack)   |          29208.81  |             3.13/0.348/13.28  |
| [JRuby-Rack](#jruby-results)           |          32331.47  |             0.99/0.598/44.34  |
| [Plug](#plug)                          |          33261.44  |             2.98/4.97/114.59  |
| [Node Cluster](#node-cluster)          |          47576.68  |             2.51/3.40/120.02  |
| [Jetty](#jetty)                        |          52398.88  |             1.90/0.432/22.45  |
| [ServeMux](#servemux)                  |          58359.97  |             1.70/0.315/18.63  |
| [Crystal HTTP](#crystal-http)          |          74997.65  |              1.33/0.323/6.83  |

### Rails, Sinatra and Roda
As said before i included Rails here to illustrate a fact.  
[Sinatra](http://www.sinatrarb.com/) is the second most used Ruby framework: it's pretty flexible offering a straightforward DSL over HTTP.  
[Roda](http://roda.jeremyevans.net/) is a slim framework i use to replace Sinatra these days: it's twice as fast and allows for a better interaction with the request/response life cycle.  
[Rack](http://rack.github.io/) is the Ruby standard HTTP server interface implemented by Puma.

##### Bootstrap
```
bundle exec puma -w 8 -q -t 16:32 --preload -e production
jruby -S bundle exec puma -q -t 16:32 -e production
```

##### Considerations
I know Rails was pretty slow, but the fact Roda is an order of magnitude faster is quite impressive all the way (making it very close to standalone rack).  

##### JRuby results
JRuby constantly performs slightly better than MRI (Rails especially): Puma leverage on native threads for parallelism, instead of pre-forking a pool of processes.  
Said that JVM need to warm up to do its best and consume much memory than MRI. I reduced performance differences by doubling the number of workers per CPU (8 processes) on MRI.

### Tornado
I picked [Tornado](http://www.tornadoweb.org/en/stable/) since it supports event-IO and multi processes spawning (i also tested Flask, but its performance was disappointing).
I tested Tornado with both Python 2.7 and 3.4, finding the former 10% faster (and
dropping 3.4 results).

##### Bootstrap
```
python2.7 tornado_server.py
```

##### Considerations
Performance are pretty good, on par with Sinatra but far from Roda (which is trice as fast).
I used multi process here as i do for Puma, granting the loads to be balanced on all of the available CPUs.

### Snap
[Snap](http://snapframework.com/) is a lightweight Web framework build on top of Haskel.

##### Bootstrap
```
cabal install
~/.cabal/bin/snapserver -p 9292
```

##### Considerations
Haskell uses green threads and immutability to grant concurrency: functional purists assert that immutability is the only way to do concurrency the right way.   
Indeed i was expecting better performance from Snap: it's on par with Sinatra and Tornado, but far away from Roda, Elixir and Node, not to mention Java, GO and Crystal.

### Plug
I tested Elixir by using [Plug](https://github.com/elixir-lang/plug) library that comes with a [Cowboy](https://github.com/ninenines/cowboy) adapter.

##### Bootstrap
I started elixir by using iex interactive console as described on Plug read-me.

##### Considerations
Elixir performance are pretty solid but not stellar. One of the Elixir (Erlang) killer application is scaling on a multi-core (+16 cores) server and/or on a distributed system.

### Node Cluster
I used Node cluster library to spawn one process per CPU.

##### Bootstrap
```
node node_server.js
```

##### Considerations
While it is true that Node.js suffers JavaScript single threaded nature, it delivered very solid performance.
These results are the sum of using cluster library to spawn multiple processes per CPU (like Ruby and Python) and leveraging on V8 speed.

### ServeMux
Since GO is pretty flexible and comes with "batteries included", i opted for the [HTTP ServeMux](https://golang.org/pkg/net/http/) standard library in place of some flavoured framework.

##### Bootstrap
```
go run go_server.go
```

##### Considerations
GO is a pretty fast language (and is getting faster) and allows using all of the cores with no particular configuration.  
The results delivered by GO is consistent, with a standard deviation always under control.  

### Jetty
To test Java i used [Jetty](http://www.eclipse.org/jetty/): a modern, stable and quite fast servlet container (faster, and simpler, than Tomcat).  

##### Bootstrap
I followed the minimal Hello World tutorial by Eclipse.

##### Considerations
I know Java is pretty fast nowadays: thousands of optimizations have been done to the JVM and many corporates have invested too much in Java to leave it behind.  

### Crystal HTTP
I used Crystal HTTP server standard library. Crystal uses green threads called "fibers", that runs on a single process (thus allowing concurrency, but not parallelism).  
According to the core team multi-threads support is something that will be added to the language before releasing version 1.0.

##### Bootstrap
```
crystal build ./server/crystal_server.cr --release
./crystal_server
```

##### Considerations
Crystal language recorded the best lap of the pack, outperforming more mature languages such as GO and Java.  
This is even more interesting considering the language executes on a single thread only and opens questions about concurrency VS parallelism model on multi core platforms.  
