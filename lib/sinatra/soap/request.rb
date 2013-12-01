require "nori"

module Sinatra
  module Soap
    class Request

      attr_reader :wsdl, :action, :env, :request, :params

      def initialize(env, request, params)
        @env = env
        @request = request
        @params = params
        parse_request
      end


      def call_block
        request_block = wsdl.block
        response_hash = self.instance_eval(&request_block)
        Soap::Response.new(wsdl, response_hash)
      rescue Soap::Error => e
        Soap::Response.new.build_error(e)
      end


      def action
        return params[:action] unless params[:action].nil?
        params[:action] = env['HTTP_SOAPACTION'].to_s.gsub(/^"(.*)"$/, '\1').to_sym
      end


      def soap_params 
        return params[:soap] unless params[:soap].nil?
        rack_input = env["rack.input"].read
        env["rack.input"].rewind
        params[:soap] = nori.parse(rack_input)[:Envelope][:Body]
      end


      private

      def parse_request
        action
        soap_params
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


      def wsdl
        @wsdl = Soap::Wsdl.new(action)
      end

    end
  end
end