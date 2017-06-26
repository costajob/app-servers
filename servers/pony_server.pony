use "net/http"

actor Main
  new create(env: Env) =>
    let service = "9292"
    let host = "127.0.0.1"

    let auth = try
      env.root as AmbientAuth
    else
      env.out.print("unable to use network")
      return
    end

    HTTPServer(
      auth,
      ListenHandler(env),
      BackendMaker.create(env)
      where service=service, host=host, reversedns=auth)

class ListenHandler
  let _env: Env

  new iso create(env: Env) =>
    _env = env

  fun ref listening(server: HTTPServer ref) =>
    try
      (let host, let service) = server.local_address().name()
    else
      _env.out.print("Couldn't get local address.")
      server.dispose()
    end

  fun ref not_listening(server: HTTPServer ref) =>
    _env.out.print("Failed to listen.")

  fun ref closed(server: HTTPServer ref) =>
    _env.out.print("Shutdown.")

class BackendMaker is HandlerFactory
  let _env: Env

  new val create(env: Env) =>
    _env = env

  fun apply(session: HTTPSession): HTTPHandler^ =>
    BackendHandler.create(_env, session)

class BackendHandler is HTTPHandler
  let _env: Env
  let _session: HTTPSession

  new ref create(env: Env, session: HTTPSession) =>
    _env = env
    _session = session

  fun ref apply(request: Payload val) =>
    let response = Payload.response()
    response.add_chunk("Hello World")
    _session(consume response)
