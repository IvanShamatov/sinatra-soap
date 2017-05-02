xml.instruct!
xml.tag! 'soap:Envelope', 'xmlns:soap' => 'http://schemas.xmlsoap.org/soap/envelope/',
        'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance' do
  if soap_headers
    xml.tag! 'soap:Header' do
      hash_to_xml(xml, soap_headers)
    end
  end
  xml.tag! 'soap:Body' do
    xml.tag! "soap:#{wsdl.reply_name || "#{wsdl.action}Response"}" do
      hash_to_xml(xml, params)
    end
  end
end
