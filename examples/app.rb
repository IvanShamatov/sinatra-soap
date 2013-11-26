require 'sinatra/base'
require 'sinatra/soap'

class App < Sinatra::Base
  register Sinatra::Soap
  post '/' do
    puts env['sinatra.soap_action']
    puts env['sinatra.soap_body']
  end
end
App.run!