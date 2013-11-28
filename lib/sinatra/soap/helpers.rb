require "nori"

module Sinatra
  module Soap
    module Helpers

      def call_action_block
        parse_request
        wsdl[params[:action]][:block].call(params[:soap][params[:action]])
      end

      def parse_request
        action = soap_action
        soap_params
        raise "Undefined Soap Action" unless wsdl.actions.include?(action)
      end

      def soap_action
        params[:action] = env['HTTP_SOAPACTION'].to_s.gsub(/^"(.*)"$/, '\1').to_sym
      end

      def soap_params 
        rack_input = env["rack.input"].read
        env["rack.input"].rewind
        params[:soap] = nori.parse(rack_input)[:Envelope][:Body]
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
