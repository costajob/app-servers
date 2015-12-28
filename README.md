## Table of Contents

* [Scope](#scope)
* [Vagrant](#vagrant)
* [Languages](#languages)
  * [Ruby](#ruby)
  * [Python](#python)
  * [Elixir](#elixir)
  * [Node.js](#nodejs)
  * [GO](#go)
* [Benchmarks](#benchmarks)
  * [Hello World](#hello-world)
  * [Wrk](#wrk)
  * [Rails and Roda](#rails-and-roda)
  * [Tornado](#tornado)
  * [Plug](#plug)
  * [Node Cluster](#node-cluster)
  * [ServerMux](#servermux)
* [Conclusions](#conclusions)

## Scope
The idea behind this repo to test out different languages and how each of them provide solutions to serve high HTTP traffic.   

## Vagrant
As for the [ruby-app-servers](https://github.com/costajob/ruby-app-servers) repo i've used a vagrant box wth the following specs:
* Ubuntu Trusty 64 bit 
* 3 VCPUs (out of 4 cores 2.2Ghz)
* 6GB of RAM (out of 8 1333Mhz DDR3)

## Languages
I chose to make the tests on the following languages/runtimes: Ruby, Python, Elixir, Node.js, GO.
You'll notice i've not included any JVM language here: well, although i got two SUN certifications in 1996, my experience with the JVM had never made me happy, so i skipped this lap.

### Ruby
[Ruby](https://www.ruby-lang.org/en/) 2.2 is installed by adding the
[brightbox](https://www.brightbox.com/docs/guides/cli/installation-debian/) repository.  
Ruby is the language i have more experience with.  
I find it an enjoyable language, although i start missing a serious support parallel processing, something quite "hot" on the uprising multi CPUs era.  

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
[Go](https://golang.org/) language is installed by source.
Go is the favorite of mine between the "modern" languages: is simple, elegant and fast. It compiles to native OS bytecode and has CSP built in to favor parallelism.  
I am still exploring GO, but as far as i've gone i am pretty happy with it.

## Benchmarks
I decided to test how these languages manage multiple HTTP requests by using standard libraries and/or micro-frameworks.  
One exception is [Rails](http://rubyonrails.org/): since many start-ups favor other languages over Ruby for APIs based applications, i dare to illustrate how Rails compare to a more micro-service friendly Ruby library like [Roda](http://roda.jeremyevans.net/). 

### Hello World
The "application" i tested is barely minimal: is the HTTP version of the "Hello World" example.

### Wrk
I used the [wrk](https://github.com/wg/wrk) as the loading tool.
Here is the common script i used:
```
wrk -t 3 -c 150 -d30s --timeout 2000 http://192.168.33.22:9292
```

### Results
| App             | Throughput (req/s) | Latency in ms (avg/stdev/max) | Req. Errors (n/tot) |
| :-------------- | -----------------: | ----------------------------: | ------------------: |
| Ruby Rails      |            761.15  |           62.95/19.97/393.54  |            0/22910  |
| Ruby Roda       |           7500.36  |            8.21/16.17/309.10  |           0/225169  |
| Python Tornado  |           3657.77  |            40.98/3.89/342.75  |           0/109850  |
| Elixir Plug     |          11166.19  |            13.99/9.61/235.06  |           0/335079  |
| Node Cluster    |          10874.73  |           15.98/24.35/648.51  |           0/326353  |
| GO ServerMux    |           9939.28  |             15.08/2.50/47.05  |           0/298310  |

### Rails and Roda
As said before i included Rails here to illustrate a fact.  
Roda is a slim framework i used to replace [Sinatra](http://www.sinatrarb.com/) in many cases, since is faster and allow a better integration with the request/response life-cycle.  

##### Bootstrap
```
bundle exec puma -w 3 -t 16:16 -q --preload -e production
```

##### Considerations
I know Rails was pretty slow, but the fact Roda is x10 faster is quite impressive all the way.  
This also prove that Ruby is far from being "slow" when minimal libraries are used together with mature App servers.

### Tornado
I picked [Tornado](http://www.tornadoweb.org/en/stable/) after reading some profiling online. If you know some faster app-server for Python i'll be glad to test it too.

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
I started elixir by using iex interactive console as described on Plug README.

##### Considerations
As expected Elixir performs very well: using small green processes to serve each requests will allow to scale horizontally on multi-core CPUs. I also suspect Cowboy does its part too being one of the fastest Erlang app server available. 

### Node Cluster
Node cluster library was used to let all of the cores serve the requests.

##### Bootstrap
```
node node_server.js
```

##### Considerations
While it is true that Node.js suffers JavaScript single threaded nature, it has proven to be very fast indeed.   
By using cluster library it spawns multiple processs (like Ruby and Python) and V8 implementation is faster enough to grant good results (but consistency is the worst of the pack).

### ServerMux
Since GO is pretty flexible and comes with "battery built-in", i opted for the HTTP ServerMux standard library in place of using some flavoured framework.

##### Bootstrap
```
go run go_server.go
```

##### Considerations
GO is a pretty fast language and allows using all of the cores with no particular configuration.  
Also standard deviation on both latency and number of requests is 20% less than all of the contendants, proving GO it's pretty consistent on scaling high traffic.

## Conclusions
If i have to pick my personal winners here's the rank:

### 1. GO
Balancing good speed, consistency and ease of use GO is the winner for me. 
It has all of the features you need straight in the standard libraries and made concurrency a real breeze. Configuring a production server requires no more than few lines of code and running an OS executable.   
To me GO wins from the design point of view too: suffice to say it has been created from scratch by some of the coolest geeks in the industry (Pike and Thompson among others) and is backed by both Google and a strong OS community.

### 2. Node.js
I am impressed how V8 and clustered Node have performed.  
Reactive programming may not be your best friend (i.e. callbacks hell), but the fact that JavaScript is a well known language explains why Node.js has replaced Rails for the [sacrificial architecture](http://martinfowler.com/bliki/SacrificialArchitecture.html) of several startups projects.

### 3. Ruby
While Ruby clearly suffers its non-parallel nature, it has proven to scale pretty well for standard uses.  
The fact that Ruby got famous thanks to Rails is a double-sharp-side knife: many people which complains about Ruby slowness while it's the heavyweight of Rails they are really paying.  
Said that Ruby lacks the speed of V8 and i fear it has to keep the pace if it wants to be a serious contender of the years to come (Ruby 3.0 is aimed to be x3 faster, but i fear it will come too late)

### 4. Elixir
By only reading benchmarks Elixir wins hands down. I have kept it off the podium several reasons.  
Elixir leverages on Erlang and this is both for good and bad. 
It's good since it can rely on more than 30 years of Erlang VM programming and battle tested libraries implemented with concurrency in mind.  
It's bad since i always had the sense of playing with a face-lifting language, knowing i have to understand Erlang internals when getting serious with the language.  
Erlang OTP is not straightforward: aside from having introduced Mix, the overall complexity is still high compared to Bundler or the GO tool.  
Last but not least i consider Erlang a niche language aimed to solve specific use cases (the Web being one of them), but programming without state is really painful in some cases.

### 5. Python
I left Python as the last one, just because the benchmarks are not as good as Roda (but similar to Sinatra).  
Aside from that Python is in the same league of Ruby regarding parallelism: it's not fast as V8 and is born when multi-core architecture was SciFi.  
That said it probably has more support by scientific community and by Google, thus letting me suppose it will have a brighter future than Ruby.
