import asynchttpserver, asyncdispatch

var server = newAsyncHttpServer()
proc cb(req: Request) {.async.} =
  await req.respond(Http200, "Hello World")

waitFor server.serve(Port(9292), cb)
