require 'roda'

class Api < Roda
  plugin :default_headers, 'Content-Type'=>'text/plain'

  route do |r|
    r.root do
      "Hello World"
    end
  end
end
