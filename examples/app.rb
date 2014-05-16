require 'sinatra/base'
require 'sinatra/soap'

class App < Sinatra::Base
  register Sinatra::Soap

  set :service, "sinatra"
  set :namespace, "http://schemas.xmlsoap.org/wsdl/"
  set :endpoint, '/action'
  set :wsdl_route, '/wsdl'

  #soap :test do
  #  params
  #end

  soap :test, in: { hello: :string }, out: nil do
    params
  end

  soap :ObjectTest, in: { TestObject: { a: :string, b: :string }}, out: { hello: :string } do
    params
  end


end
App.run!
