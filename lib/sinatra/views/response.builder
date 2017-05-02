xml.instruct!
xml.SOAP :Envelope do
  if soap_headers
    xml.tag! 'soap:Header' do
      soap_headers.each do |key, value|
        xml.tag! key, value
      end
    end
  end
  xml.tag! 'soap:Body' do
    xml.tag! "soap:#{wsdl.reply_name || "#{wsdl.action}Response"}" do
      params.each do |key, value|
        xml.tag! key, value
      end
    end
  end
end