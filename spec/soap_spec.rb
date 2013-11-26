ENV['RACK_ENV'] = 'test'
require File.join(File.join(File.expand_path(File.dirname(__FILE__))), '..', 'lib', 'sinatra', 'soap')
require 'rack/test'
require 'rspec'
require 'savon'

class SoapApp < Sinatra::Base
  register Sinatra::Soap
end

module RSpecMixin
  include Rack::Test::Methods
  def app() SoapApp end
end

# For RSpec 2.x
RSpec.configure { |c| c.include RSpecMixin }
# If you use RSpec 1.x you should use this instead:
Spec::Runner.configure { |c| c.include RSpecMixin }

describe 'A sinatra application' do

  before :all do 
    @savon = Savon.client(endpoint: "http://127.0.0.1/action",
                          namespace: "anynamespace")
  end
  it "should parse soap request" do
    @savon.call(:Event, message: {something: "sometimes"})
    env.should include('sinatra.soap_action')
    env.should include('sinatra.soap_body')
  end
end