module Sinatra
  module Soap
    class Response

      attr_reader :wsdl
      attr_accessor :params, :headers

      def initialize(wsdl, params, headers = nil)
        @wsdl = wsdl
        @params = params
        @headers = headers
      end
    end
  end
end