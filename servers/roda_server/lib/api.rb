require 'roda'

class Api < Roda
  route do |r|
    r.root do
      "Hello World"
    end
  end
end
