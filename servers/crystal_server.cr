require "http/server"

HTTP::Server.new("0.0.0.0", 9292) do |context|
  context.response.content_type = "text/plain"
  context.response.print "Hello World"
end.listen
