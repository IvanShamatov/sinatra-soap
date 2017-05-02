xml.instruct!
xml.definitions 'xmlns' => 'http://schemas.xmlsoap.org/wsdl/',
                'xmlns:tns' => settings.namespace,
                'xmlns:soap' => 'http://schemas.xmlsoap.org/wsdl/soap/',
                'xmlns:xsd' => 'http://www.w3.org/2001/XMLSchema',
                'xmlns:soap-enc' => 'http://schemas.xmlsoap.org/soap/encoding/',
                'xmlns:wsdl' => 'http://schemas.xmlsoap.org/wsdl/',
                'name' => settings.service,
                'targetNamespace' => settings.namespace do

  xml.types do
    xml.tag! "schema", :targetNamespace => settings.namespace, :xmlns => 'http://www.w3.org/2001/XMLSchema' do
      defined = []
      wsdl.each do |operation, formats|
        formats[:in]  ||= {}
        formats[:out] ||= {}
        formats[:in].each do |p|
          wsdl_type xml, p, defined
        end
        formats[:out].each do |p|
          wsdl_type xml, p, defined
        end
      end
    end
  end

  xml.portType :name => "#{settings.service}_port" do
    wsdl.keys.each do |operation|
      xml.operation :name => operation do
        xml.input :message => "tns:#{operation}"
        response_name = wsdl[operation][:reply_name] || "#{operation}Response"
        xml.output :message => "tns:#{response_name}"
      end
    end
  end

  xml.binding :name => "#{settings.service}_binding", :type => "tns:#{settings.service}_port" do
    xml.tag! "soap:binding", :style => 'document', :transport => 'http://schemas.xmlsoap.org/soap/http'
    wsdl.keys.each do |operation|
      xml.operation :name => operation do
        xml.tag! "soap:operation", :soapAction => operation
        xml.input do
          xml.tag! "soap:body",
            :use => "literal",
            :namespace => settings.namespace
        end
        xml.output do
          xml.tag! "soap:body",
            :use => "literal",
            :namespace => settings.namespace
        end
      end
    end
  end

  xml.service :name => "service" do
    xml.port :name => "#{settings.service}_port", :binding => "tns:#{settings.service}_binding" do
      xml.tag! "soap:address", :location => "http://#{request.host_with_port}#{settings.endpoint}"
    end
  end

  wsdl.each do |operation, formats|
    xml.message :name => "#{operation}" do
      formats[:in] ||= []
      formats[:in].each do |p|
        xml.part wsdl_occurence(p, false)
      end
    end
    response_name = wsdl[operation][:reply_name] || "#{operation}Response"
    xml.message :name => response_name do
      formats[:out] ||= []
      formats[:out].each do |p|
        xml.part wsdl_occurence(p, false)
      end
    end
  end
end
