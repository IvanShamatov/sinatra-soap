module Sinatra
  module Soap
    class Response

      attr_reader :wsdl, :params

      def initialize(wsdl, params)
        @wsdl = wsdl
        @params = params
      end
    end
  end
end