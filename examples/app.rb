require 'sinatra/base'
require 'sinatra/soap'

class App < Sinatra::Base
  register Sinatra::Soap
  soap :test, in: {reader: :integer},
              out: nil,
              namespace: "anyother" do
    puts "1"
  end
end
App.run!