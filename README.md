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
  * [Ruby](#ruby)

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
[Python](https://www.python.org/) 3.2 comes pre-installed on Ubuntu.  
I included Python just to see how it compares versus Ruby. I have never had the urge to learn Python, since i am pretty happy with Ruby. Said that i know Python has probably a stronger community and can benefit of being one of the supported languages by Google.

### Elixir
[Elixir](http://elixir-lang.org/) last version is installed by adding the
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

### Ruby
Here's how i started both Rails and Roda applications, using Puma on three workers:
```
bundle exec puma -w 3 -t 16:16 -q --preload -e production
```

And here's the results:

| App            | Throughput (req/s) | Latency (ms) | Req. Errors (n/tot) |
| :------------- | -----------------: | -----------: | ------------------: |
| Rails          |            761.15  |       62.95  |            0/22910  |
| Roda           |           7386.36  |        6.27  |           0/221696  |

While comparing Rails with Roda is like comparing melons with oranges, the results are quite impressive all the way.  
This also prove that Ruby is far from being "slow" when minimal libraries are used together with mature App servers.
Just one note for Roda: when request start piling on Puma trying to access the URL in the broeser does not loads the page, thus proving latency is pretty high indeed.

### Python
I just tested [Tornado](http://www.tornadoweb.org/en/stable/), just by reading some profiling online:

| App            | Throughput (req/s) | Latency (ms) | Req. Errors (n/tot) |
| :------------- | -----------------: | -----------: | ------------------: |
| Tornado        |           1609.54  |       93.02  |            0/48388  |

Performnce are twice as Rails, but far form Roda. Probably some specific configuration is necessary here (although i used one process per CPU).
