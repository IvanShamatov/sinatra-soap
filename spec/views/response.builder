xml.instruct!
xml.tag! 'soap:Envelope', 'xmlns:soap' => 'http://schemas.xmlsoap.org/soap/envelope/',
        'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance' do
  if soap_headers
    xml.tag! 'soap:Header' do
      soap_headers.each do |key, value|
        xml.tag! key, value
      end
    end
  end
  xml.tag! 'soap:Body' do
    xml.tag! "soap:#{wsdl.action}Response" do
      params.each do |key, value|
        xml.tag! key, value
      end
    end
  end
end
