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
  * [Rails & Roda](#rails-&-roda)
  * [Tornado](#tornado)
  * [Plug](#plug)
  * [Node Cluster](#node-cluster)
  * [ServerMux](#servermux)
* [Conclusions](#conclusions)

## Scope
The idea behind this repo is to have an environment where to test different application servers for disparate programming languages.  
The scope id to test out different languages and at the same time verify the HTTP server implementation each langugage brings to the table.  
In the meantime i also tried to benchmark each server, although i have to admit i had know how on Ruby only and i've applied no particular optimization to the others.

## Vagrant
As for the [ruby-app-servers](https://github.com/costajob/ruby-app-servers) repo i've used a vagrant box wth the following specs:
* Ubuntu Trusty 64 bit 
* 3 VCPUs (out of 4 of my MacBook Pro)
* 6GB of RAM

## Languages
I chose to make the tests on the following languages/runtimes: Ruby, Python, Elixir, GO, Node.js.
You'll notice i've not included any JVM language here: well, although i got two SUN certifications in 1996, my experience with the JVM had never made me happy.

### Ruby
[Ruby](https://www.ruby-lang.org/en/) 2.2 is installed by adding the
[brightbox](https://www.brightbox.com/docs/guides/cli/installation-debian/) repository.  
Ruby is the language i have more experience with.  
I find it an enjoyable language, although i start missing a serious support parallel processing, something quite "hot" on the uprising multi CPUs era.  

### Python
[Python](https://www.python.org/) 3.4 comes pre-installed on Ubuntu.  
I included Python just to see how it compares versus Ruby. I have never had the urge to learn Python, since i am pretty happy with Ruby.  
Said that i know Python has probably a stronger community and can benefit of being one of the supported languages by Google.

### Elixir
[Elixir](http://elixir-lang.org/) 1.1.1 version is installed by adding the
[erlang-solutions](https://www.erlang-solutions.com/about/erlang-other-technologies.html) repository.  
I studied Elixir last year, surfing the wave of Pragmatic Dave enthusiasm and finding its rubyesque resemblance pretty easy to grasp.  
Being based on Erlang it supports parallelism quite nicely and can leverage on some battle-tested frameworks.
What i dislike most is the complete lack of state: while i have invested too much time into OO techniques, i am not convinced pure immutability is required to get parallelism right.

### Node.js
[Node.js](https://nodejs.org/en/) stable version (4.x) is installed by adding nodesource repository.  
I once used to program in JavaScript much more that these days. I left it behind in
favor or more "backend" languages. I know it's a shame, since nowadays implementation of JS is quite fast, and the rise of Node.js has proven the language is much more than an in-browser tool.

### GO
[Go](https://golang.org/) language is installed by source.
Go is the favorite of mine between the "modern" languages: is simple, elegant and
fast. It compiles to native OS code and have CSP built in to favor parallelism.  
I am still exploring GO, but as far as i've gone i am pretty happy with it.

## Benchmarks
I decided to test how these languages manage multiple HTTP requests by using standard libraries and/or micro-frameworks.  
One exception is [Rails](http://rubyonrails.org/): since many start-ups favor other languages over Ruby for APIs based applications, i dare to illustrate how Rails compare to a more micro-service friendly Ruby library like [Roda](http://roda.jeremyevans.net/). 

### Hello World
The "application" i tested is barely minimal: is the HTTP version of the "Hello World" example.

### Wrk
I used the [wrk](https://github.com/wg/wrk) tool to stress load the different application servers.  
Here is the common script i used:
```
wrk -t 3 -c 150 -d30s --timeout 2000 http://192.168.33.22:9292
```

### Rails & Roda
Here's how i started both Rails and Roda applications, using Puma on three workers:
```
bundle exec puma -w 3 -t 16:16 -q --preload -e production
```

And here's the results:

| App            | Throughput (req/s) | Latency in ms (avg/stdev/max) | Req. Errors (n/tot) |
| :------------- | -----------------: | ----------------------------: | ------------------: |
| Rails          |            761.15  |           62.95/19.97/393.54  |            0/22910  |
| Roda           |           7500.36  |            8.21/16.17/309.10  |           0/225169  |

While comparing Rails with Roda is like comparing watermelons with cherries, the x10 results are quite impressive all the way.  
This also prove that Ruby is far from being "slow" when minimal libraries are used together with mature App servers.

### Tornado
I just tested [Tornado](http://www.tornadoweb.org/en/stable/), just by reading some profiling online:

| App            | Throughput (req/s) | Latency in ms (avg/stdev/max) | Req. Errors (n/tot) |
| :------------- | -----------------: | ----------------------------: | ------------------: |
| Tornado        |           1609.54  |            93.60/9.83/418.61  |            0/48388  |

Performance are twice as Rails, but far form Roda. Probably some specific configuration is necessary here (although i used one process per CPU as for Puma).

### Plug
I tested Elixir by using [Plug](https://github.com/elixir-lang/plug) library together with the battle-tested [Cowboy](://github.com/ninenines/cowboy) Web server.

| App            | Throughput (req/s) | Latency in ms (avg/stdev/max) | Req. Errors (n/tot) |
| :------------- | -----------------: | ----------------------------: | ------------------: |
| Plug           |          11166.19  |            13.99/9.61/235.06  |           0/335079  |

As expected Elixir performs very well: using small green processes to server each requests will allow to scale horizontally on multi-core CPUs. I also suspect Cowboy does its part too. 

### Node Cluster
Node cluster library was used to let all of the cores serve the requests.

| App            | Throughput (req/s) | Latency in ms (avg/stdev/max) | Req. Errors (n/tot) |
| :------------- | -----------------: | ----------------------------: | ------------------: |
| Node Cluster   |          10874.73  |           15.98/24.35/648.51  |           0/326353  |

While it is true that Node.js suffers JavaScript single thread nature, it is very fast indeed. By using cluster library it uses multiple processes (like Ruby and Python) and V8 implementation is fater enough to grant good results.

### ServerMux
Since GO is pretty flexible when using HTTP standard libraries i decided to go straight with them instead of using some wrapping framework.

| App            | Throughput (req/s) | Latency in ms (avg/stdev/max) | Req. Errors (n/tot) |
| :------------- | -----------------: | ----------------------------: | ------------------: |
| Node Cluster   |           9939.28  |             15.08/2.50/47.05  |           0/298310  |

GO is a pretty fast language and allows you to uses all of the cores by using small goroutines to server each request.  
Also standard deviation on both latency and number of requests is 20% less than all of the contendants, proving it's a pretty consistent on scaling high traffic.

## Conclusions
If i've have to pick my personal winners here i will rank them as the following:
1. GO: balancing good speed, consistency and ease of use GO is a winner for me. It has all of the features you need straight in the standard librray and made concurrency a real breeze. Configuring a production server requires no more than few lines of code and running a native OS executable
2. Node.js: i am impressed how V8 and clustered node are fast. Reactive programming may not be your best friend (i.e. callbacks hell), but the fact that JavaScript is a well known language explain why Node.js has replaced Rails for the very first version of several startups projects.
3. Ruby: while Ruby clearly suffer its non-parallel nature, it has proven to scale pretty well for standard uses. The fact that Rails has made Ruby famous is weird, since many people complains about Ruby slowness while it's the heavyweight of Rails they are suffering from. Said that Ruby lack the speed of V8 and i fear it has to keep the pace if it wants to be a serious contender on the years to come. 
4. Elixir: Elixir leverages on Erlang and this is both for good and bad.  It's good since it can rely on the parallel Erlang VM and most of the libraries are battle tested and with concurrency in mind. It's bad since i always had a sense of playing with a reskin-language, knowing i will have to understand Erlang internals when going beyond the surface. Also i consider Erlang a niche language aimed to solve specific problems: it is a good candidate for Web, much less for other general purpose programming.
5. Python: i left Python as the last one, just because the benchmarks are not as good as Roda. If someone will prove me some better implementation i will be glad to update my results. Also Python is in the same league of Ruby regarding parallelism: it's not fast as V8 and is born when multi-core architecture was Sci-Fi. Said that it probably have more support by scientific community and Google, thus meaning a happier future than Ruby.
