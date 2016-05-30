## Table of Contents

* [Scope](#scope)
* [Vagrant](#vagrant)
* [Languages](#languages)
  * [Ruby](#ruby)
  * [Crystal](#crystal)
  * [Python](#python)
  * [Elixir](#elixir)
  * [Node.js](#nodejs)
  * [GO](#go)
  * [Java](#java)
* [Benchmarks](#benchmarks)
  * [Hello World](#hello-world)
  * [Wrk](#wrk)
  * [Rails, Sinatra and Roda](#rails-sinatra-and-roda)
  * [Tornado](#tornado)
  * [Plug](#plug)
  * [Node Cluster](#node-cluster)
  * [ServeMux](#servemux)
  * [Jetty](#jetty)

## Scope
The idea behind this repository is to test out how different languages HTTP libraries behave upon high loading.   

## Vagrant
As for the [ruby-app-servers](https://github.com/costajob/ruby-app-servers) repository i've used a [Vagrant](https://www.vagrantup.com/) box with the following specs:
* Ubuntu Trusty 64 bit 
* 3 VCPUs (out of 4 cores 2.2Ghz)
* 6GB of RAM (out of 8GB 1333Mhz DDR3)

I know i am not testing on a production server, anyway this hardware mimics pretty closely the common slice offered by cloud hosting providers.
Using Vagrant also allows decoupling the client by the server, thus preventing unreliable results.

## Languages
I chose to test the following languages/runtime: Ruby, Python, Elixir, Node.js, GO, Java.

### Ruby
[Ruby](https://www.ruby-lang.org/en/) 2.3 is installed by adding the
[brightbox](https://www.brightbox.com/docs/guides/cli/installation-debian/) repository.  
Ruby is the language i have more experience with.  
I find it an enjoyable language, although i start missing serious support for a light parallelism model.

### Crystal
[Crystal](http://crystal-lang.org/) 0.17.3 is installed by homebrew: i used my MacBook PRO without Vagrant, since for some reason i was not able to access the HTTP server from the vagrant box.  
Crystal has a syntax similar to Ruby (quite impressive how much of Ruby good parts are in the language), but brings some desirable features such as static typing, efficient garbace collector and compilation to highly optimized native code.

### Python
[Python](https://www.python.org/) 2.7 and 3.4 come pre-installed on Ubuntu. 
I included Python just to see how it compares versus Ruby. I never had the urge to learn Python, the same way pythonians do not look at Ruby.  

### Elixir
[Elixir](http://elixir-lang.org/) 1.1.1 version is installed by adding the
[erlang-solutions](https://www.erlang-solutions.com/about/erlang-other-technologies.html) repository.  
I studied Elixir last year, surfing the wave of Pragmatic Dave enthusiasm and finding its rubyesque resemblance pretty easy to grasp.  
Being based on Erlang it supports parallelism out of the box. What i miss in Elixir is the complete lack of state: while i have invested too much into OOP, i am not convinced pure immutability is required to get parallelism right.

### Node.js
[Node.js](https://nodejs.org/en/) stable version (4.x) is installed by adding nodesource repository.  
I once used to program in JavaScript much more that these days. I left it behind in favor or more "backend" languages. I know it's a shame, since nowadays implementation of JavaScript is pretty fast and the rise of Node.js has proven the language is much more than an in-browser tool (but also brought entropy on the table).

### GO
[GO](https://golang.org/) language version 1.6 is installed by source.  
GO is the answer by Google to the need for a modern garbage-collected programming language to scale both in terms of multi-core devices and large distributed teams.
GO focuses on simplicity, by intentionally lacking features considered redundant (i.e. inheritance, exception handling, generics). It also addresses verbosity by using type inference, duck typing and a dry syntax. At the same time GO takes a straight approach to parallelism, coming with build in [CSP](https://en.wikipedia.org/wiki/Communicating_sequential_processes) and green threads (goroutines).  

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
I measured each app server three times and took the best lap.  
Here is the common script i used:
```
wrk -t 3 -c 150 -d30s --timeout 2000 http://192.168.33.22:9292
```

#### Missing data
I avoid to report Crystal data, since they are recorded on my Mac and are much higher than the ones recorded within the Vagrant box.

### Results
| App Server                             | Throughput (req/s) | Latency in ms (avg/stdev/max) |
| :------------------------------------- | -----------------: | ----------------------------: |
| [Rails](#rails-sinatra-and-roda)       |            833.18  |          129.26/48.09/367.67  |
| [Sinatra](#rails-sinatra-and-roda)     |           1912.56  |           40.47/52.40/551.55  |
| [Roda](#rails-sinatra-and-roda)        |           8353.74  |           19.37/20.03/412.39  |
| [Tornado](#tornado)                    |           4193.27  |            35.74/6.64/137.35  |
| [Plug](#plug)                          |          11277.30  |           14.95/19.58/385.37  |
| [Node Cluster](#node-cluster)          |          11616.61  |            13.09/5.11/236.63  |
| [ServeMux](#servemux)                  |           9926.36  |            15.25/4.68/129.87  |
| [Jetty](#jetty)                        |           8887.97  |           21.62/43.61/795.46  |

### Rails, Sinatra and Roda
As said before i included Rails here to illustrate a fact.  
[Sinatra](http://www.sinatrarb.com/) is the second most used Ruby framework: it's pretty flexible offering a straightforward DSL over HTTP.  
[Roda](http://roda.jeremyevans.net/) is a slim framework i use to replace Sinatra these days: it's faster and allow for a better interaction with the request/response life cycle.  
I also performed all of the benchmarks against [JRuby](http://jruby.org/) version 9.0.4: since results are on par with MRI i decided is not relevant to include it into the pack.

##### Bootstrap
```
bundle exec puma -w 5 -q --preload -e production
```

##### Considerations
I know Rails was pretty slow, but the fact Roda is an order of magnitude faster is quite impressive all the way (making it very close to standalone rack).  
To be fair Roda latency can get pretty high when stressing Puma, i recorded the worst data of the pack.

### Crystal HTTP server
I used Crystal HTTP server standard library. I know current Crystal version does use green threads called "Fibers", that runs on a single process (thus allowing concurrency, but not parallelism). According to the core members multi-threads support is something that will be added to the language before releasing version 1.0.

##### Bootstrap
```
crystal build ./server/crystal_server.cr --release
./crystal_server
```

##### Considerations
I was simply astonished to record the best lap for the Crystal language: it outperformed more mature languages such as GO and Java of about 45% of throughput. What surprise me most is that this performance was recorded by using a single thread on a 4-CPUs device, thus leaving me pondering the performance once multi-threading support will be available.  
It is also incredible how Crystal can be so fast and still so enjoyable to code with: you are convinced to write ruby code until you run the compiler and see the benchmark produced by the running program...

### Tornado
I picked [Tornado](http://www.tornadoweb.org/en/stable/) after reading some profiling online.  
If you know some faster app-server for Python i'll be glad to test it too.  
I tested Tornado with both Python 2.7 and 3.4, finding the former 10% faster, so i reported results for the 2.7 version only.

##### Bootstrap
```
python2.7 tornado_server.py
```

##### Considerations
Performance are pretty good, better than almost all Ruby frameworks but for Roda (which is twice as faster).
I used multi process here as i do for Puma, granting the loads to be balanced on all of the available CPUs.

### Plug
I tested Elixir by using [Plug](https://github.com/elixir-lang/plug) library that comes with a [Cowboy](https://github.com/ninenines/cowboy) adapter.

##### Bootstrap
I started elixir by using iex interactive console as described on Plug read-me.

##### Considerations
As expected Elixir performs very well: using green processes to serve each requests will allow to scale horizontally on multi-core CPUs. I also suspect Cowboy does its part too, being one of the fastest Erlang app server. 

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
The results delivered by GO is consistent, with a standard deviation
always under control.  
Indeed GO is the fastest language of the pack, but strangely enough i've recorded its best lap by using only 2 VCPUs instead of 3 (> 130000 requests/sec).  

### Jetty
To test Java i used [Jetty](http://www.eclipse.org/jetty/): a modern, stable and quite fast servlet container (faster, and simpler, than Tomcat).  

##### Bootstrap
I followed the minimal Hello World [tutorial](http://www.eclipse.org/jetty/documentation/9.2.2.v20140723/advanced-embedding.html) by Eclipse.

##### Considerations
I know Java is pretty fast nowadays: thousands of optimizations have been done to the JVM and many corporates have invested too much in Java to leave it behind.  
As with GO, i've recorded better results by uisng only 2 VCPUs instead of 3 (more than 12000 requests/sec).
