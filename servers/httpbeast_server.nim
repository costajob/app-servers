import asyncdispatch, httpbeast, options

const settings = httpbeast.initSettings(Port(9292))

proc onRequest(req: Request): Future[void] =
  if req.httpMethod == some(HttpGet):
      const data = "Hello World"
      const headers = "Content-Type: text/plain"
      req.send(Http200, data, headers)

run(onRequest, settings)
