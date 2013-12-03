ENV['RACK_ENV'] = 'test'
require File.join(File.join(File.expand_path(File.dirname(__FILE__))), '..', 'lib', 'sinatra', 'soap')
require 'rspec'
require 'rack/test'

class SoapApp < Sinatra::Base
  register Sinatra::Soap
  soap :test do
    params
  end

  soap :add_circle, in: {circle: {center: {x: :integer, y: :integer}, 
                                  radius: :double}},
            				out: nil do
  	params #=> {circle: {center: {x: 3, y: 2}, radius: 12.0} }
  	nil
	end
end

module RSpecMixin
  include Rack::Test::Methods
end

RSpec.configure { |c| c.include RSpecMixin }
