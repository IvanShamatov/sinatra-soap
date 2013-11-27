require 'sinatra/base'
require 'sinatra/soap'

# require './lib/sinatra/soap/wsdl'
# require './lib/sinatra/soap/helpers'
class App < Sinatra::Base
  register Sinatra::Soap
  soap :test do |params|
    puts params.inspect
  end

  get '/' do
    puts params.inspect
  end
end
puts App.wsdl