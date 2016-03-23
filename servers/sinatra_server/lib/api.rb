require 'sinatra/base'

class Api < Sinatra::Base
  get '/' do
    headers "Content-Type" => "text/plain"
    'Hello world!'
  end
end
