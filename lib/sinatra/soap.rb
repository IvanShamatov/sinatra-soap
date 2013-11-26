require 'sinatra/base'
require "sinatra/soap/version"
require "nori"


module Sinatra
  module Soap

    def parse_soap
      before do
        soap_action
        soap_body
      end
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
      app.helpers Helpers
      app.parse_soap
    end
  end
  register Soap
end
