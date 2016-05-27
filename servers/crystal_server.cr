require "http/server"

server = HTTP::Server.new(9292) do |context|
  context.response.content_type = "text/plain"
  context.response.print "Hello world!"
end

puts "Listening on http://0.0.0.0:9292"
server.listen
