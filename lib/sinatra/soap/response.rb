require 'builder'

module Sinatra
  module Soap
    class Response

      attr_reader :wsdl, :params
      
      def initialize(wsdl, params)
        @wsdl = wsdl
        @params = params
      end

      def build
        builder do |xml|
          xml.instruct!
          xml.tag! 'soap:Envelope', 'xmlns:soap' => 'http://schemas.xmlsoap.org/soap/envelope/',
                  'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance' do
            xml.tag! 'soap:Body' do
              xml.tag! "soap:#{wsdl.action}Response" do
                params.each do |key, value| 
                  xml.tag! key, value
                end
              end
            end
          end
        end
      end

      def build_error(e)
        builder do |xml|
          xml.instruct!
          xml.tag! 'soap:Envelope', 'xmlns:soap' => 'http://schemas.xmlsoap.org/soap/envelope/',
                  'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance' do
            xml.tag! 'soap:Body' do
              xml.tag! 'soap:Fault', :encodingStyle => 'http://schemas.xmlsoap.org/soap/encoding/' do
                xml.faultcode 'Client'
                xml.faultstring e.message
              end
            end
          end
        end
      end

      def builder
        Builder::XmlMarkup.new
      end

    end
  end
end