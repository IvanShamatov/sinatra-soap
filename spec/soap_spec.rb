ENV['RACK_ENV'] = 'test'
require File.join(File.join(File.expand_path(File.dirname(__FILE__))), '..', 'lib', 'sinatra', 'soap')
require 'rspec'
require 'rack/test'

class SoapApp < Sinatra::Base
  register Sinatra::Soap
  soap :test do |params|
  end
end

module RSpecMixin
  include Rack::Test::Methods
end

RSpec.configure { |c| c.include RSpecMixin }


describe 'A default soap sinatra application' do
  def app
    SoapApp 
  end
  

  it "should parse soap request" do
    post '/action', '<?xml version="1.0" encoding="UTF-8"?><env:Envelope xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:wsdl="any" xmlns:env="http://schemas.xmlsoap.org/soap/envelope/"><env:Body><wsdl:test><par>one</par><par2>bar</par2><foo>wat</foo></wsdl:test></env:Body></env:Envelope>'
    app.params.should include(:soap)
    app.params[:soap].should == :test
    app.params[:action].should == {something: "sometimes"}
  end

  it "should register soap actions" do
    
  end


  it "should have endpoint for soap actions" do
    endpoint = app.routes["POST"].select {|k| k[0].to_s.match('action')}.count
    endpoint.should eq 1
  end

  it "should have route for wsdl" do
    wsdl = app.routes["GET"].select {|k| k[0].to_s.match('wsdl')}.count
    wsdl.should == 1
  end

end
