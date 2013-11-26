module Sinatra
  module Soap
    module Helpers

      def soap(name, *args, &block)
        # soap :LogEvent, 
        #      args: {},
        #      return: {},
        #      namespace: "",
        #      to: method_name do
        # end
        wsdl = Soap::Wsdl
        wsdl.actions[name] = {}
        args.pop.each do |key, value|
          wsdl.actions[name][key] = value
        end
        wsdl.actions[name][:block] = block if block_given?
      end
      module_function :soap

      def generate_wsdl
        Soap::Wsdl.generate_wsdl
      end

      def parse_soap
        action = soap_action
        raise SoapFault unless Soap::Wsdl.actions.include?(action)
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
