require "sinatra/base"
require "sinatra/soap/version"
require "nori"


module Sinatra
  module Soap
    attr_accessor :soap_actions, :wsdl 

    def parse_soap
      before do
         #TODO: move it to params 
         # so it can be used like: params[:action]
         #                         params[:body]
        [soap_action, soap_body]
      end
    end

    def soap(name, params, &block)
      # soap :LogEvent, 
      #      args: {},
      #      return: {},
      #      namespace: "",
      #      to: method_name do
      # end
      wsdl.actions[name]["params"] = params
      wsdl.actions[name]["block"] = block if block_given?
      raise "Not implemented"
    end

    def generate_wsdl
      raise "Not implemented"
    end

    module Helpers
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

    def self.registered(app)
      app.set :soap_path, '/action'
      app.set :wsdl_path, '/wsdl'

      app.post(settings.soap_path) do
        action, pars = app.parse_soap
        #WSDL['wsdl'][action]["block"].call(pars)
      end

      app.post(settings.wsdl_path) do 
        app.generate_wsdl
      end
    end
  end
  register Soap
  Delegator.delegate :soap
end
