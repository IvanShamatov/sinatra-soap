require 'sinatra/base'
require 'sinatra/soap'

class App < Sinatra::Base
  register Sinatra::Soap
  soap :test do
    params
  end
end
App.run!