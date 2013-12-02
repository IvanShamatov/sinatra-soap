module Sinatra
  module Soap
    module RequestContextMethods

      def call_action_block
        request = Soap::Request.new(env, request, params)
        response = request.execute
        builder :response, locals: {wsdl: response.wsdl, params: response.params}
      rescue Soap::Error => e
        builder :error, locals: {e: e}
      end

      def get_wsdl
        builder :wsdl, locals: {wsdl: Soap::Wsdl.actions}
      end

    end
  end
end
