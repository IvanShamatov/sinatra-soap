require 'spec_helper'


describe 'A default soap sinatra application' do
  def app
    SoapApp 
  end

  it "should parse soap request and send response" do
    headers = {"HTTP_SOAPACTION" => 'test'}
    message = '<?xml version="1.0" encoding="UTF-8"?><env:Envelope xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:wsdl="any" xmlns:env="http://schemas.xmlsoap.org/soap/envelope/"><env:Body><wsdl:test><par>one</par><par2>bar</par2><foo>wat</foo></wsdl:test></env:Body></env:Envelope>'
    post '/action', message, headers
    response =<<-XML
<?xml version="1.0" encoding="UTF-8"?>
<soap:Envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">
  <soap:Body>
    <soap:testResponse>
      <par>one</par>
      <par2>bar</par2>
      <foo>wat</foo>
    </soap:testResponse>
  </soap:Body>
</soap:Envelope>
    XML
    last_response.body.should == response
  end


  it "should raise soap fault on unknown action" do
    headers = {"HTTP_SOAPACTION" => 'test2'}
    message = '<?xml version="1.0" encoding="UTF-8"?><env:Envelope xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:wsdl="any" xmlns:env="http://schemas.xmlsoap.org/soap/envelope/"><env:Body><wsdl:test><par>one</par><par2>bar</par2><foo>wat</foo></wsdl:test></env:Body></env:Envelope>'
    post '/action', message, headers
    response =<<-XML
<?xml version="1.0" encoding="UTF-8"?>
<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
  <soap:Body>
    <soap:Fault encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
      <faultcode>Client</faultcode>
      <faultstring>Undefined Soap Action</faultstring>
    </soap:Fault>
  </soap:Body>
</soap:Envelope>
    XML
    last_response.body.should == response
  end

  it "should have endpoint for soap actions" do
    endpoint = app.routes["POST"].select {|k| k[0].to_s.match('action')}.count
    endpoint.should eq 1
  end

  it "should have route for wsdl" do
    wsdl = app.routes["GET"].select {|k| k[0].to_s.match('wsdl')}.count
    wsdl.should == 1
  end

  it "should return a usable soap views directory" do
    view_search = File.join(app.views, "*.builder")
    expect(Dir.glob(view_search).count).to be > 0
  end

end
