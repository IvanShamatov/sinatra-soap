require "nori"

module Sinatra
  module Soap
    module Helpers

      def generate_wsdl
        wsdl.generate_wsdl
      end

      def parse_soap
        action = soap_action
        raise "Undefined Soap Action" unless wsdl.actions.include?(action)
        body = soap_body[:Envelope][:Body]
      end

      def soap_action
        env['HTTP_SOAPACTION'].to_s.gsub(/^"(.*)"$/, '\1').to_sym
      end

      def soap_body
        rack_input = env["rack.input"].read
        env["rack.input"].rewind
        nori.parse(rack_input)
      end

      def wsdl
        Soap::Wsdl
      end

      def nori(snakecase=false)
        Nori.new(
          :strip_namespaces => true,
          :advanced_typecasting => true,
          :convert_tags_to => (
            snakecase ? lambda { |tag| tag.snakecase.to_sym } 
                      : lambda { |tag| tag.to_sym }
          )
        )
      end
    end
  end
end
