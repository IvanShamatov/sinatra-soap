module Sinatra
  module Soap
    class Wsdl
      @actions = {}
      @namespace = ""

      def self.actions
        @actions
      end

      def self.namespace
        @namespace
      end

      def self.generate_wsdl
        "WSDL GENERATED"
      end
    end
  end
end