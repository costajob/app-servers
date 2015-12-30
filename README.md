## Table of Contents

* [Scope](#scope)
* [Vagrant](#vagrant)
* [Languages](#languages)
  * [Ruby](#ruby)
  * [Python](#python)
  * [Elixir](#elixir)
  * [Node.js](#nodejs)
  * [GO](#go)
  * [Java](#java)
* [Benchmarks](#benchmarks)
  * [Hello World](#hello-world)
  * [Wrk](#wrk)
  * [Rails and Roda](#rails-and-roda)
  * [Tornado](#tornado)
  * [Plug](#plug)
  * [Node Cluster](#node-cluster)
  * [ServerMux](#servermux)
  * [Jetty](#jetty)
* [Conclusions](#conclusions)

## Scope
The idea behind this repo is to test out how different languages HTTP libraries behave upon high loading.   

## Vagrant
As for the [ruby-app-servers](https://github.com/costajob/ruby-app-servers) repo i've used a [Vagrant](https://www.vagrantup.com/) box with the following specs:
* Ubuntu Trusty 64 bit 
* 2 VCPUs (out of 4 cores 2.2Ghz)
* 4GB of RAM (out of 8GB 1333Mhz DDR3)

I know i am not testing on a production server, anyway this hardware mimics very closely the average slice offered by common [cloud hosting providers](https://www.digitalocean.com).
Using Vagrant also allows decoupling the client (app servers) by the server (wrk), thus preventing unreliable results.

## Languages
I chose to test the following languages/runtimes: Ruby, Python, Elixir, Node.js, GO, Java.

### Ruby
[Ruby](https://www.ruby-lang.org/en/) 2.2 is installed by adding the
[brightbox](https://www.brightbox.com/docs/guides/cli/installation-debian/) repository.  
Ruby is the language i have more experience with.  
I find it an enjoyable language, although i start missing serious support for parallelism, a hot topic on the uprising multi CPUs era.  

### Python
[Python](https://www.python.org/) 3.4 comes pre-installed on Ubuntu.  
I included Python just to see how it compares versus Ruby. I never had the urge to learn Python, the same way pythonians do not learn Ruby.  
I know Python has probably a strong scientific community and can benefit of being one of the languages officially supported by Google.

### Elixir
[Elixir](http://elixir-lang.org/) 1.1.1 version is installed by adding the
[erlang-solutions](https://www.erlang-solutions.com/about/erlang-other-technologies.html) repository.  
I studied Elixir last year, surfing the wave of Pragmatic Dave enthusiasm and finding its rubyesque resemblance pretty easy to grasp.  
Being based on Erlang it supports parallelism out of the box. What i miss in Elixir is the complete lack of state: while i have invested too much into OOP, i am not convinced pure immutability is required to get parallelism right.

### Node.js
[Node.js](https://nodejs.org/en/) stable version (4.x) is installed by adding nodesource repository.  
I once used to program in JavaScript much more that these days. I left it behind in favor or more "backend" languages. I know it's a shame, since nowadays implementation of JavaScript is pretty fast and the rise of Node.js has proven the language is much more than an in-browser tool (but also brought entropy on the table).

### GO
[GO](https://golang.org/) language version 1.5.2 is installed by source.  
GO is the answer by Google to the need for a modern garbage-collected programming language to scale both in terms of multi-core devices and large distributed teams.
GO focuses on simplicity, by intentionally lacking features considered redundant (i.e. inheritance, exception handling, generics). It also addresses verbosity by using type inference, duck typing and a dry syntax. At the same time GO takes a straight approach to parallelism, coming with build in CSP and green threads (goroutines).  

### Java
[Java](http://www.oracle.com/technetwork/java/javase/downloads/jre7-downloads-1880261.html) 7 Ubuntu's default JDK is used.   
I get two SUN certifications back in 2006 and found out the more i delved into Java the less i liked it.
Ignoring Java on this comparison is not an option anyway: Java is the most used programming language in the world (2015) and some smart folks have invested on it since the 90ies.

## Benchmarks
I decided to test how these languages manage multiple HTTP requests by using standard libraries and/or micro-frameworks.  
One exception is [Rails](http://rubyonrails.org/): since many start-ups favor other languages over Ruby for APIs based applications, i dare to illustrate how Rails compare to a more micro-service friendly Ruby library like [Roda](http://roda.jeremyevans.net/). 

### Hello World
The "application" i tested is barely minimal: is the HTTP version of the "Hello World" example.

### Wrk
I used [wrk](https://github.com/wg/wrk) as the loading tool.
I measured each app server five times and took the best lap.  
Here is the common script i used:
```
wrk -t 3 -c 150 -d30s --timeout 2000 http://192.168.33.22:9292
```

### Results
| App Server                     | Throughput (req/s) | Latency in ms (avg/stdev/max) | Req. Errors (n/tot) |
| :----------------------------- | -----------------: | ----------------------------: | ------------------: |
| [Rails](#rails-and-roda)       |            669.31  |           29.81/20.84/417.84  |            0/20137  |
| [Roda](#rails-and-roda)        |           6979.73  |             10.68/71.89/1600  |           0/209507  |
| [Tornado](#tornado)            |           2647.45  |            56.76/9.68/571.87  |            0/79525  |
| [Plug](#plug)                  |          10004.01  |           17.82/21.07/499.11  |           0/301158  |
| [Node Cluster](#node-cluster)  |           9722.71  |           21.63/38.09/857.91  |           0/291939  |
| [ServerMux](#servermux)        |          14299.24  |            11.29/8.25/200.92  |           0/430475  |
| [Jetty](#jetty)                |          13496.64  |           12.08/15.11/340.81  |           0/406292  |

### Rails and Roda
As said before i included Rails here to illustrate a fact.  
Roda is a slim framework i used to replace [Sinatra](http://www.sinatrarb.com/) in many cases, since is faster and allow a better interaction with the request/response life cycle.  

##### Bootstrap
```
bundle exec puma -w 2 -q --preload -e production
```

##### Considerations
I know Rails was pretty slow, but the fact Roda is an order of magnitude faster is quite impressive all the way.  
To be fair Roda latency can get pretty high when stressing Puma, i recorded the worst data of the pack.

### Tornado
I picked [Tornado](http://www.tornadoweb.org/en/stable/) after reading some profiling online.  
If you know some faster app-server for Python i'll be glad to test it too.

##### Bootstrap
```
python3.4 tornado_server.py
```

##### Considerations
Performance are pretty good, but the half of Roda.  
I used multi process here as i do for Puma, granting the loads to be balanced on all of the available CPUs.

### Plug
I tested Elixir by using [Plug](https://github.com/elixir-lang/plug) library that comes with a [Cowboy](https://github.com/ninenines/cowboy) adapter.

##### Bootstrap
I started elixir by using iex interactive console as described on Plug readme.

##### Considerations
As expected Elixir performs very well: using green processes to serve each requests will allow to scale horizontally on multi-core CPUs. I also suspect Cowboy does its part too, being one of the fastest Erlang app server. 

### Node Cluster
I used Node cluster library to spawn one process per CPU.

##### Bootstrap
```
node node_server.js
```

##### Considerations
While it is true that Node.js suffers JavaScript single threaded nature, it has proven to have very solid performance.
By using cluster library it spawns multiple processes (like Ruby and Python) and V8 implementation is faster enough to grant the results.

### ServerMux
Since GO is pretty flexible and comes with "built-in battery", i opted for the HTTP ServerMux standard library in place of some flavoured framework.

##### Bootstrap
```
go run go_server.go
```

##### Considerations
GO is a pretty fast language (and is getting faster) and allows using all of the cores with no particular configuration.  
The results delivered by GO is consistent, with the lower latency of the pack. 

### Jetty
To test Java i used Jetty 9: a modern, stable and quite fast servlet container.  

##### Bootstrap
I followed the minimal Hello World [tutorial](http://www.eclipse.org/jetty/documentation/9.2.2.v20140723/advanced-embedding.html) by Eclipse.

##### Considerations
I know Java is pretty fast nowadays: thousands of optimizations have been done to the JVM and many corporates have invested too much in Java to leave it behind.  
Said that its performance are a tad worst than GO, in particular regarding latency.

## Conclusions
To layout my personal ranking i do not only focus on the benchmarks, but also on the simplicity of the program, dependencies footprint and setup times.

### 1. GO
Balancing excellent speed, consistency and ease of use GO is the winner for me.   
It has all of the features you need straight in the standard libraries and made concurrency a real breeze. Configuring a production server requires no more than few lines of code and running an OS executable.   
The future of GO also appears bright: it's designed by some of the coolest geeks in the industry (Pike and Thompson among others) and is backed by both Google and a strong OS community.

### 2. Node.js
I am impressed how V8 and clustered Node have performed.  
Reactive programming may not be your best friend (i.e. callbacks hell), but the fact that JavaScript is a well known language explains why Node.js has replaced Rails for the [sacrificial architecture](http://martinfowler.com/bliki/SacrificialArchitecture.html) of several startups projects.  
The only limiting factor for me is that JavaScript was not intended as a general purpose programming language from its birth. Node tries to address this by using custom libraries, but it should be great to find core functionalities (i.e. packages dependencies) into the standard one.
In this regard Ecmascript6 is promising: it takes a more OO approach and rescues features that are missing-in-action on current implementation.

### 3. Java
You could have figured out i do not like Java. It's not true, you know.  
Well, is partially true: i dislike Java rigidity of doing things; i dislike its overall verbosity; i dislike the fat frameworks built around it; i dislike having to create a XML every time i do something or, alternatively, trash my code with annotations; i dislike i have to install a 500MB editor to have things under control; i dislike the fact that SUN have never being able to impose standards and, when they tried, they come out with EJB.  
Ok, it's true...  
Apart from me, if you are not thrilled by new languages and/or other JVM dialects and are comfortable with Java, there's no reason stop using it.  
It's a reliable programming language that can count on a plethora of battle-tested libraries and thousands of excellent resources.

### 4. Elixir
I am expecting Elixir good results, so the reasons of its ranking are outside of pure performance aspects.  
Elixir leverages on Erlang and this is both for good and bad.  
It's good since it can rely on more than 30 years of Erlang VM programming and
optimizations.   
It's bad since i always had the sense of playing with a face-lifting language, knowing i have to deal with Erlang internals when getting more serious.  
Erlang OTP is not straightforward either: aside from having introduced Mix, the overall complexity is still higher than tools like Bundler or GO (the tool).  
Last but not least i consider Erlang a niche language aimed to solve specific use cases (the Web being one of them), but i consider programming without state really painful most of the time.

### 5. Ruby
While Ruby clearly suffers its non-parallel nature, it has proven to scale pretty well for standard uses.  
The fact that Ruby got famous thanks to Rails is a double-sharp-side knife: many people  complains about Ruby slowness, ignoring it's the bulkiness of Rails they are really dragging on.
Ruby lacks the speed of V8 and i suppose it has to keep the pace to be a serious contender of the years to come. In this regard Ruby 3.0 is aimed to be x3 faster with a better support for concurrency (although i doubt the GIL can be removed easily).

### 6. Python
I admit i do not know Python, so its position is justified by the benchmarks not being as good as Roda.
Aside from that Python is in the same league of Ruby regarding parallelism: it's not fast as the V8 and is born when multi-core devices were SciFi.  
As already said Python benefits by the strong support of scientific community and by Google, thus letting me forecast a brighter future than Ruby.
