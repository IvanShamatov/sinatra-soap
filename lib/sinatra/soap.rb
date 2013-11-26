require "sinatra/base"
require "sinatra/soap/version"
require "sinatra/soap/helpers"
require "sinatra/soap/wsdl"
require "nori"
require "erb"


module Sinatra
  module Soap
    def soap(name, *args, &block)
      Helpers.soap(name, *args, &block)
    end

    def self.registered(app)
      app.helpers Helpers
      app.set :soap_path, '/action' unless defined?(app.settings.soap_path)
      app.set :wsdl_path, '/wsdl' unless defined?(app.settings.wsdl_path)

      app.post(app.settings.soap_path) do
        action, params = parse_soap
        if block = Wsdl.actions[action][:block]
          block.call(params)
        else
          send(Wsdl.actions[action][:to], params)
        end
      end

      app.get(app.settings.wsdl_path) do 
        generate_wsdl
      end
    end
  end
  Delegator.delegate :soap
  register Soap
end
