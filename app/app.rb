require 'sinatra'
require 'sinatra/soap'


parse_soap_action

post '/' do
	puts env.inspect
end