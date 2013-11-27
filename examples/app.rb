require 'sinatra/base'
require 'sinatra/soap'

class App < Sinatra::Base
  register Sinatra::Soap
  soap :test do
    puts soap_params.inspect
  end

  get '/' do
    puts params.inspect
  end
end
App.run!