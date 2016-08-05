require "http/server"

class HelloWorld < HTTP::Handler
  def call(context)
    context.response.content_type = "text/plain"
    context.response.print "Hello World"
  end
end

HTTP::Server.new(9292, HelloWorld.new).listen
