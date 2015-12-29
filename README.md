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
The idea behind this repo to test out different languages and how each of them provide solutions to serve high HTTP traffic.   

## Vagrant
As for the [ruby-app-servers](https://github.com/costajob/ruby-app-servers) repo i've used a [Vagrant](https://www.vagrantup.com/) box with the following specs:
* Ubuntu Trusty 64 bit 
* 3 VCPUs (out of 4 cores 2.2Ghz)
* 6GB of RAM (out of 8 1333Mhz DDR3)

## Languages
I chose to make the tests on the following languages/runtimes: Ruby, Python, Elixir, Node.js, GO, Java.

### Ruby
[Ruby](https://www.ruby-lang.org/en/) 2.2 is installed by adding the
[brightbox](https://www.brightbox.com/docs/guides/cli/installation-debian/) repository.  
Ruby is the language i have more experience with.  
I find it an enjoyable language, although i start missing serious support for parallel processing, something quite "hot" on the uprising multi CPUs era.  

### Python
[Python](https://www.python.org/) 3.4 comes pre-installed on Ubuntu.  
I included Python just to see how it compares versus Ruby. I never had the urge to learn Python, since i am pretty happy with Ruby.  
Said that i know Python has probably a stronger community and can benefit of being one of the languages officially supported by Google.

### Elixir
[Elixir](http://elixir-lang.org/) 1.1.1 version is installed by adding the
[erlang-solutions](https://www.erlang-solutions.com/about/erlang-other-technologies.html) repository.  
I studied Elixir last year, surfing the wave of Pragmatic Dave enthusiasm and finding its rubyesque resemblance pretty easy to grasp.  
Being based on Erlang it supports parallelism quite nicely, what i dislike most is the complete lack of state: while i have invested too much time into OOP, i am not convinced pure immutability is required to get parallelism right.

### Node.js
[Node.js](https://nodejs.org/en/) stable version (4.x) is installed by adding nodesource repository.  
I once used to program in JavaScript much more that these days. I left it behind in favor or more "backend" languages. I know it's a shame, since nowadays implementation of JS is pretty fast and the rise of Node.js has proven the language is much more than an in-browser tool.

### GO
[GO](https://golang.org/) language version 1.5.2 is installed by source.  
GO is the answer by Google to the need for a modern GC language to scale both in terms of multi-core devices and large distributed teams.
GO focuses on simplicity, by intentionally missing features considered redundant (i.e. inheritance, exception handling, generics). It also addresses verbosity by using type inference, duck typing and a dry syntax. At the same time GO took a straight approach to parallelism, coming with build in CSP and green threads (GO routines).  
I am still exploring GO, but as far as i've gone i like what i see.

### Java
[Java](http://www.oracle.com/technetwork/java/javase/downloads/jre7-downloads-1880261.html) 7 Ubuntu's deafult JDK is used.   
I get two SUN certifications back to 2006 and found out the more i delved into Java the less i liked it (read conclusions).  
Said that, ignoring Java on this comparison is not an option: Java is the most used language in the world (2015) and some smart folks have invested on it since twenty years.

## Benchmarks
I decided to test how these languages manage multiple HTTP requests by using standard libraries and/or micro-frameworks.  
One exception is [Rails](http://rubyonrails.org/): since many start-ups favor other languages over Ruby for APIs based applications, i dare to illustrate how Rails compare to a more micro-service friendly Ruby library like [Roda](http://roda.jeremyevans.net/). 

### Hello World
The "application" i tested is barely minimal: is the HTTP version of the "Hello World" example.

### Wrk
I used the [wrk](https://github.com/wg/wrk) as the loading tool.
I measured each app server five times and took the best lap.  
Here is the common script i used:
```
wrk -t 3 -c 150 -d30s --timeout 2000 http://192.168.33.22:9292
```

### Results
| App             | Throughput (req/s) | Latency in ms (avg/stdev/max) | Req. Errors (n/tot) |
| :-------------- | -----------------: | ----------------------------: | ------------------: |
| Ruby Rails      |            761.15  |           62.95/19.97/393.54  |            0/22910  |
| Ruby Roda       |           7500.36  |            8.21/16.17/309.10  |           0/225169  |
| Python Tornado  |           3724.99  |            40.24/6.93/347.27  |           0/111834  |
| Elixir Plug     |          11335.87  |            13.43/6.02/228.83  |           0/340165  |
| Node Cluster    |          11085.29  |           14.66/17.25/411.10  |           0/333696  |
| GO ServerMux    |          10075.21  |             14.89/2.81/91.20  |           0/302352  |
| Java Jetty      |           9108.45  |           16.79/10.06/368.92  |           0/274195  |

### Rails and Roda
As said before i included Rails here to illustrate a fact.  
Roda is a slim framework i used to replace [Sinatra](http://www.sinatrarb.com/) in many cases, since is faster and allow a better integration with the request/response life-cycle.  

##### Bootstrap
```
bundle exec puma -w 3 -t 16:16 -q --preload -e production
```

##### Considerations
I know Rails was pretty slow, but the fact Roda is x10 faster is quite impressive all the way.  
To be fair Roda latency can get pretty high when stressing Puma: i get the worst case of 20 seconds when requests start piling up, probably due to the fact that spawned porcesses consume all available memory.  
In this regards Rails is more consistent, albeit an order of magnitude slower.

### Tornado
I picked [Tornado](http://www.tornadoweb.org/en/stable/) after reading some profiling online.  
If you know some faster app-server for Python i'll be glad to test it too.

##### Bootstrap
```
python3.4 tornado_server.py
```

##### Considerations
Performance are pretty nice but behind Roda.  
I used multi process here as i do for Puma, granting the loads to be balanced on all of the available CPUs.

### Plug
I tested Elixir by using [Plug](https://github.com/elixir-lang/plug) library that comes with a [Cowboy](https://github.com/ninenines/cowboy) adapter.

##### Bootstrap
I started elixir by using iex interactive console as described on Plug readme.

##### Considerations
As expected Elixir performs very well: using small green processes to serve each requests will allow to scale horizontally on multi-core CPUs. I also suspect Cowboy does its part too, being one of the fastest Erlang app server. 

### Node Cluster
I used Node cluster library to spawn one process per CPU (i hard-coded this for simplicity).

##### Bootstrap
```
node node_server.js
```

##### Considerations
While it is true that Node.js suffers JavaScript single threaded nature, it has proven to be one of the fastest app server tested.  
By using cluster library it spawns multiple processes (like Ruby and Python) and V8 implementation is faster enough to grant great results.

### ServerMux
Since GO is pretty flexible and comes with "built-in battery", i opted for the HTTP ServerMux standard library in place of using some flavoured framework.

##### Bootstrap
```
go run go_server.go
```

##### Considerations
GO is a pretty fast language and allows using all of the cores with no particular configuration.  
Also standard deviation on both latency and number of requests is 20% less than all of the contendants, proving GO it's pretty consistent on scaling high traffic.

### Jetty
To test Java i used Jetty 9: a modern, stable and quite fast servlet container.  

##### Bootstrap
I followed the minimal Hello World [tutorial](http://www.eclipse.org/jetty/documentation/9.2.2.v20140723/advanced-embedding.html) by Eclipse.
```
java -cp .:javax.servlet-3.0.v201112011016.jar:jetty-all-9.2.14.v20151106.jar HelloWorld
```

##### Considerations
I know Java is pretty fast nowadays: many optimizations have been done to the JVM and many corporates have invested too much in Java to leave it behind.  
Said that its performance are worst than GO, Node.js and Elixir and just a tad better than Roda (but far more consistent as well).

## Conclusions
If i have to pick my personal winners here's the rank:

### 1. GO
Balancing good speed, consistency and ease of use GO is the winner for me. 
It has all of the features you need straight in the standard libraries and made concurrency a real breeze. Configuring a production server requires no more than few lines of code and running an OS executable.   
To me GO wins from the design point of view too: suffice to say it has been created from scratch by some of the coolest geeks in the industry (Pike and Thompson among others) and is backed by both Google and a strong OS community.

### 2. Node.js
I am impressed how V8 and clustered Node have performed.  
Reactive programming may not be your best friend (i.e. callbacks hell), but the fact that JavaScript is a well known language explains why Node.js has replaced Rails for the [sacrificial architecture](http://martinfowler.com/bliki/SacrificialArchitecture.html) of several startups projects.  
The only limiting factor for me is that JavaScript was not intended as a general purpose programming language from its birth. Node tries to address this by using some extrenal libraries, but it should be great to find them in the standard library of the language.  
In this regard Ecmascript6 is promising: it took a more OO approach and rescues many MIA features of current implementation.

### 3. Elixir
By only reading benchmarks Elixir wins hands down. To me it is not the champion for several reasons.  
Elixir leverages on Erlang and this is both for good and bad.  
It's good since it can rely on more than 30 years of Erlang VM programming and battle tested libraries (implemented with concurrency in mind).  
It's bad since i always had the sense of playing with a face-lifting language, knowing i have to deal with Erlang internals when getting more serious.  
Erlang OTP is not straightforward either: aside from having introduced Mix, the overall complexity is still higher than the experience i have using Bundler or the GO tool.  
Last but not least i consider Erlang a niche language aimed to solve specific use cases (the Web being one of them), but i consider programming without state really painful most of the time.

### 4. Ruby
While Ruby clearly suffers its non-parallel nature, it has proven to scale pretty well for standard uses.  
The fact that Ruby got famous thanks to Rails is a double-sharp-side knife: many people  complains about Ruby slowness, ignoring it's the heavyweight of Rails they are really suffering from.
Said that Ruby lacks the speed of V8 and i think it has to keep the pace if it wants to be a serious contender of the years to come. In this regard Ruby 3.0 is aimed to be x3 faster with a better support for concurrency (although i doubt the GIL can be removed easily).

### 5. Python
I admit i do not know Python, so its position is justified by the benchmarks not being as good as Roda (but on par with Sinatra, not in the comparison).  
Aside from that Python is in the same league of Ruby regarding parallelism: it's not fast as the V8 and is born when multi-core architecture was SciFi.  
Anyway Python is strongly supported by the scientific community and by Google, thus letting me forecast a brighter future than Ruby.

### 6. Java
You should have figured out i do not like Java. It's not true, you know.  
Well, i dislike Java rigidity of doing things, i dislike its overall verbosity, i dislike the fat frameworks built around it, i dislike annotations, i dislike having to create a XML everytime i do something, i dislike i have to install a 500MB editor to get things done, i dislike the fact that SUN has never being able to impose standards and, when it tried, it comes out with EJB.  
Ok, it's true...  
Apart from me, if you are not thrilled by new languages and/or other JVM dialects and are comfortable with Java, there's no reason stop using it.  
Doing so you can leverage on a reliable language, a plethora of battle-tested libraries and thousands of excellent resources.
