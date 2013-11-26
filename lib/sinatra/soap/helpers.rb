module Sinatra
  module Soap
    module Helpers
      
      def soap(name, pars, &block)
        # soap :LogEvent, 
        #      args: {},
        #      return: {},
        #      namespace: "",
        #      to: method_name do
        # end
        # wsdl.actions[name]["params"] = pars
        # wsdl.actions[name]["block"] = block if block_given?
        raise "Not implemented"
      end

      def generate_wsdl
        raise "Not implemented"
      end

      def parse_soap
        #TODO: move it to params 
        # so it can be used like: params[:action]
        #                         params[:body]
        [soap_action, soap_body]
      end

      def soap_action
        return env['sinatra.soap_action'] if env['sinatra.soap_action']
        soap_action = env['HTTP_SOAPACTION'].to_s.gsub(/^"(.*)"$/, '\1')
        env['sinatra.soap_action'] = soap_action
      end

      def soap_body
        return env['sinatra.soap_body'] if env['sinatra.soap_body']
        rack_input = env["rack.input"].read
        env["rack.input"].rewind
        env['sinatra.soap_body'] = nori.parse(rack_input)
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
