require 'spec_helper'

describe "Request" do
  def app
    SoapApp
  end

  it "should render xml with params" do
    headers = {"HTTP_SOAPACTION" => 'test_render'}
    message = '<?xml version="1.0" encoding="UTF-8"?><env:Envelope xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:wsdl="any" xmlns:env="http://schemas.xmlsoap.org/soap/envelope/"><env:Body><wsdl:test></wsdl:test></env:Body></env:Envelope>'
    post '/action', message, headers

    response = %{
<?xml version="1.0" encoding="UTF-8"?>
<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
  <soap:Body>
    <soap:TestRenderReply>
      <top>
        <child attr1="attr_value">
          <value>content</value>
        </child>
      </top>
    </soap:TestRenderReply>
  </soap:Body>
</soap:Envelope>}.strip

    expect(last_response.body).to eq(response + "\n")
  end

end