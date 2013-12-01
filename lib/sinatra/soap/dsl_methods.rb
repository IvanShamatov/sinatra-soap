module Sinatra
  module Soap
    module DslMethods

      def soap(action, *args, &block)
        Soap::Wsdl.register(action, *args, &block)
      end

    end
  end
end