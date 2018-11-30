require "agoo"

class MyHandler
  def call(req)
    [ 200, { }, [ BODY ] ]
  end
end

BODY = "Hello World"
WORKERS = ENV.fetch('WORKERS', 4).to_i
HANDLER = MyHandler.new

Agoo::Server.init(9292, "root", thread_count: 0, worker_count: WORKERS)
Agoo::Server.handle(:GET, "/", HANDLER)
Agoo::Server.start()
