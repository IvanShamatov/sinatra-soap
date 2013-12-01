ENV['RACK_ENV'] = 'test'
require File.join(File.join(File.expand_path(File.dirname(__FILE__))), '..', 'lib', 'sinatra', 'soap')
require 'rspec'
require 'rack/test'

class SoapApp < Sinatra::Base
  register Sinatra::Soap
  soap :test do
    params
  end
end

module RSpecMixin
  include Rack::Test::Methods
end

RSpec.configure { |c| c.include RSpecMixin }
