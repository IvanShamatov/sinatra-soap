require 'spec_helper'

describe "Request" do
  def app
    SoapApp
  end

  before :each do 
    headers = {"HTTP_SOAPACTION" => 'test'}
    message = '<?xml version="1.0" encoding="UTF-8"?>' +
              '<env:Envelope xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" ' +
                'xmlns:wsdl="any" xmlns:env="http://schemas.xmlsoap.org/soap/envelope/">' +
              '<env:Body><wsdl:test><par>one</par><par2>bar</par2><foo>wat</foo></wsdl:test></env:Body></env:Envelope>'
    post '/action', message, headers
    @request = Sinatra::Soap::Request.new(last_request.env, last_request, last_request.params)
  end

  it "should get soap_action" do
    expect(@request.action).to eq(:test)
  end

  it "should get soap arguments" do
    expect(@request.params).to eq({par: "one", par2: "bar", foo: "wat"})
  end

  it "should build response" do
    expect(@request.execute).to be_an_instance_of(Sinatra::Soap::Response)
  end

  it "should validate input with WSDL" do
    skip
  end
end