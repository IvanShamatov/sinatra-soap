require 'sinatra/base'
require "sinatra/soap/version"
require "nori"


module Sinatra
  module Soap

    def parse_soap_action
      before do
        return env['sinatra.soap_action'] if env['sinatra.soap_action']
        soap_action = env['HTTP_SOAPACTION'].to_s.gsub(/^"(.*)"$/, '\1')
        puts soap_action.inspect
        env['sinatra.soap_action'] = soap_action
      end
    end

    module Helpers
      def parse_soap_action
        before do
          return env['sinatra.soap_action'] if env['sinatra.soap_action']
          soap_action = env['HTTP_SOAPACTION'].to_s.gsub(/^"(.*)"$/, '\1')
          puts soap_action.inspect
          env['sinatra.soap_action'] = soap_action
        end
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
      app.parse_soap_action
    end
  end
  Delegator.delegate :parse_soap_action
  register Soap
end
