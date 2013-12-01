module Sinatra
  module Soap
    module RequestContextMethods

      def call_action_block
        request = Soap::Request.new(env, request, params)
        response = request.call_block
        response.build
      end

      def get_wsdl
        Soap::Wsdl.generate
      end

    end
  end
end
