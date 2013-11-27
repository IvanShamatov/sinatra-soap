require "nori"

module Sinatra
  module Soap
    module Helpers

      def call_block_for(action, body)
        wsdl[action][:block].call(body)
      end

      def parse_soap
        action = soap_action
        raise "Undefined Soap Action" unless wsdl.actions.include?(action)
        body = soap_params[:Envelope][:Body]
        [action.to_sym, body]
      end

      def soap_action
        env['HTTP_SOAPACTION'].to_s.gsub(/^"(.*)"$/, '\1').to_sym
      end

      def soap_params 
        rack_input = env["rack.input"].read
        env["rack.input"].rewind
        nori.parse(rack_input)
      end

      def wsdl
        Soap::Wsdl.instance
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
