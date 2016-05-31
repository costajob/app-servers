## Table of Contents

* [Scope](#scope)
* [Platform](#platform)
* [Languages](#languages)
  * [Ruby](#ruby)
  * [Python](#python)
  * [Elixir](#elixir)
  * [Node.js](#nodejs)
  * [GO](#go)
  * [Crystal](#crystal)
  * [Java](#java)
* [Benchmarks](#benchmarks)
  * [Hello World](#hello-world)
  * [Wrk](#wrk)
  * [Rails, Sinatra and Roda](#rails-sinatra-and-roda)
  * [Tornado](#tornado)
  * [Plug](#plug)
  * [Node Cluster](#node-cluster)
  * [ServeMux](#servemux)
  * [Crystal HTTP](#crystal-http)
  * [Jetty](#jetty)

## Scope
The idea behind this repository is to test out how different languages HTTP libraries behave upon high loading.   

## Platform
I registered these benchmarks with a MacBook PRO 15 late 2011 having these specs:
* OSX El Captain
* 2,2 GHz Intel Core i7 (4 cores)
* 8 GB 1333 MHz DDR3

## Languages
I chose to test the following languages/runtime: Ruby, Crystal, Python, Elixir, Node.js, GO, Java.

### Ruby
[Ruby](https://www.ruby-lang.org/en/) 2.3 is installed via homebrew.  
Ruby is the language i have more experience with.  
I find it an enjoyable language, although i start missing serious support for a light parallelism model.

### Python
[Python](https://www.python.org/) 2.7 comes pre-installed on OSX El Captain. 
I included Python just to see how it compares versus Ruby. I never had the urge to learn Python, the same way pythonians do not look at Ruby.  

### Elixir
[Elixir](http://elixir-lang.org/) 1.1.1 version is installed via homebrew.
I studied Elixir in 2015, surfing the wave of [Prag-Dave](https://pragdave.me/) enthusiasm and finding its *rubyesque* resemblance inviting.
Being based on [Erlang](https://www.erlang.org/) it supports parallelism out of the box. What i miss in Elixir is the complete lack of state: maybe i've invested too much in the OOP ground.

### Node.js
[Node.js](https://nodejs.org/en/) stable version (4.x) is installed by adding nodesource repository.  
I once used to program in JavaScript much more that these days. I left it behind in favor or more "backend" languages. I know it's a shame, since V8 is pretty fast, ES6 has filled many language lacks and the rise of Node.js has proven JavaScript is much more than an in-browser tool (but also brought entropy on the table).

### GO
[GO](https://golang.org/) language version 1.6.2 is installed by source.  
GO focuses on simplicity, by intentionally lacking features considered redundant (i.e. inheritance, exception handling, generics). It tries to address verbosity by using type inference, duck typing and a dry syntax.  
At the same time GO takes a straight approach to parallelism, coming with build in [CSP](https://en.wikipedia.org/wiki/Communicating_sequential_processes) and green threads (goroutines).  

### Crystal
[Crystal](http://crystal-lang.org/) 0.17.3 is installed via homebrew.
Crystal has a syntax similar to Ruby (indeed is quite impressive how much of Ruby good parts are in the language), but brings some desirable features such as compile-time type checking, efficient garbage collector and compilation to highly optimized native code.  
Crystal adopts the CSP model (like GO) and evented/IO to grant concurrency and avoid IO-blocking. 
In order to mimic dynamic languages Crystal adopts a full type-inference approach (similar to Haskell) that is incredibly stable considering the language is still in its beta.

### Java
[Java](http://www.oracle.com/technetwork/java/javase/downloads/jre7-downloads-1880261.html) 7 Ubuntu's default JDK is used.   
I get two Sun certifications back in 2006 and found out the more i delved into Java the less i liked it.
Ignoring Java on this comparison is not an option anyway: Java is the most used programming language in the world (2015) and some smart folks have invested on it since the 90ies.

## Benchmarks
I decided to test how these languages manage multiple HTTP requests by using standard libraries and/or micro-frameworks.  
One exception is [Rails](http://rubyonrails.org/): since many start-ups favor other languages over Ruby for APIs based applications, i dare to illustrate how Rails compare to more micro-service friendly Ruby frameworks.

### Hello World
The "application" i tested is barely minimal: is the HTTP version of the "Hello World" example.

### Wrk
I used [wrk](https://github.com/wg/wrk) as the loading tool.
I measured each application server three times and took the best lap.  
Here is the common script i used:
```
wrk -t 4 -c 150 -d30s --timeout 2000 http://127.0.0.1:9292
```

### Results
| App Server                             | Throughput (req/s) | Latency in ms (avg/stdev/max) |
| :------------------------------------- | -----------------: | ----------------------------: |
| [Rails](#rails-sinatra-and-roda)       |           1572.43  |           31.43/13.04/138.19  |
| [Sinatra](#rails-sinatra-and-roda)     |          10470.59  |              6.04/3.51/46.38  |
| [Roda](#rails-sinatra-and-roda)        |          24050.49  |              2.63/1.68/25.54  |
| [Tornado](#tornado)                    |           7880.15  |             12.74/4.48/80.41  |
| [Plug](#plug)                          |          33261.44  |             2.98/4.97/114.59  |
| [Node Cluster](#node-cluster)          |          47576.68  |             2.51/3.40/120.02  |
| [ServeMux](#servemux)                  |          58359.97  |             1.70/0.315/18.63  |
| [Crystal HTTP](#crystal-http)          |          72042.19  |              1.38/0.371/7.79  |
| [Jetty](#jetty)                        |          51590.19  |              1.92/0.236/6.53  |

### Rails, Sinatra and Roda
As said before i included Rails here to illustrate a fact.  
[Sinatra](http://www.sinatrarb.com/) is the second most used Ruby framework: it's pretty flexible offering a straightforward DSL over HTTP.  
[Roda](http://roda.jeremyevans.net/) is a slim framework i use to replace Sinatra these days: it's twice as fast and allows for a better interaction with the request/response life cycle.  
I also performed all of the benchmarks against [JRuby](http://jruby.org/) version 9.0.4: since results are on par with MRI i decided is not relevant to include it into the pack.

##### Bootstrap
```
bundle exec puma -w 4 -q -t 16:16 --preload -e production
```

##### Considerations
I know Rails was pretty slow, but the fact Roda is an order of magnitude faster is quite impressive all the way (making it very close to standalone rack).  

### Tornado
I picked [Tornado](http://www.tornadoweb.org/en/stable/) after reading some profiling online.  
If you know some faster app-server for Python i'll be glad to test it too.  
I tested Tornado with both Python 2.7 and 3.4, finding the former 10% faster, so i reported results for the 2.7 version only.

##### Bootstrap
```
python2.7 tornado_server.py
```

##### Considerations
Performance are pretty good, on par with Sinatra but far from Roda (which is trice as fast).
I used multi process here as i do for Puma, granting the loads to be balanced on all of the available CPUs.

### Plug
I tested Elixir by using [Plug](https://github.com/elixir-lang/plug) library that comes with a [Cowboy](https://github.com/ninenines/cowboy) adapter.

##### Bootstrap
I started elixir by using iex interactive console as described on Plug read-me.

##### Considerations
Elixir performance are pretty solid but not stellar. As for Erlang it probably performs better on a multi-core server or/and on a distributed system.

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

### Crystal HTTP
I used Crystal HTTP server standard library. Crystal uses green threads called "fibers", that runs on a single process (thus allowing concurrency, but not parallelism).  
According to the core team multi-threads support is something that will be added to the language before releasing version 1.0.

##### Bootstrap
```
crystal build ./server/crystal_server.cr --release
./crystal_server
```

##### Considerations
Crystal language recorded the best lap of the pack, outperforming more mature languages such as GO and Java of about 25% of throughput.  
This fact is more surprising considering the language is still in its beta and executes on a single process only (and also opens up questions about concurrency VS parallelism).  

### Jetty
To test Java i used [Jetty](http://www.eclipse.org/jetty/): a modern, stable and quite fast servlet container (faster, and simpler, than Tomcat).  

##### Bootstrap
I followed the minimal Hello World [tutorial](http://www.eclipse.org/jetty/documentation/9.2.2.v20140723/advanced-embedding.html) by Eclipse.

##### Considerations
I know Java is pretty fast nowadays: thousands of optimizations have been done to the JVM and many corporates have invested too much in Java to leave it behind.  
