require "sinatra/base"
require "sinatra/soap/version"
require "sinatra/soap/helpers"
require "sinatra/soap/wsdl"


module Sinatra
  module Soap

    # soap :LogEvent, 
    #      args: {},
    #      return: {},
    #      namespace: "",
    #      to: method_name do
    # end
    def soap(name, *args, &block)
      Soap::Wsdl.instance.register_action(name, *args, &block)
    end

    def self.registered(app)
      app.helpers Helpers
      app.set :soap_path, '/action' unless defined?(app.settings.soap_path)
      app.set :wsdl_path, '/wsdl' unless defined?(app.settings.wsdl_path)

      app.post(app.settings.soap_path) do
        action, body = parse_soap
        call_block_for(action)
      end

      app.get(app.settings.wsdl_path) do 
        wsdl.generate
      end
    end
  end
  Delegator.delegate :soap
  register Soap
end
