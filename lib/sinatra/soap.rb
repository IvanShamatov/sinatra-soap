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
      app.helpers Sinatra::Soap::Helpers
      app.set :soap_path, '/action' unless defined?(app.settings.soap_path)
      app.set :wsdl_path, '/wsdl' unless defined?(app.settings.wsdl_path)

      app.post(app.settings.soap_path) do
        response = call_action_block
        if response.is_a? Hash 
          response.inspect
          # build XML Response according to wsdl
          # https://github.com/sinatra/sinatra/blob/master/lib/sinatra/base.rb#L697
        else
          nil
        end
      end

      app.get(app.settings.wsdl_path) do 
        wsdl.generate
      end
    end
  end
  Delegator.delegate :soap
  register Soap
end
