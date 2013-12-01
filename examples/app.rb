require 'sinatra/base'
require 'sinatra/soap'

class App < Sinatra::Base
  register Sinatra::Soap
  soap :test do
    puts params.inspect
  end
end
puts App.run!