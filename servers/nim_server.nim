import asynchttpserver, asyncdispatch

proc cb(req: Request) {.async.} =
  await req.respond(Http200, "Hello World")

waitFor newAsyncHttpServer().serve(Port(9292), cb)
