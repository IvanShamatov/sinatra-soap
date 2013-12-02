require "sinatra/base"
require "sinatra/soap/version"
require "sinatra/soap/wsdl"
require "sinatra/soap/error"
require "sinatra/soap/dsl_methods"
require "sinatra/soap/request_context_methods"
require "sinatra/soap/request"
require "sinatra/soap/response"
require "builder"


module Sinatra
  module Soap

    include DslMethods

    def self.registered(app)
      app.helpers Soap::RequestContextMethods

      app.set :soap_path, '/action' unless defined?(app.settings.soap_path)
      app.set :wsdl_path, '/wsdl' unless defined?(app.settings.wsdl_path)

      app.post(app.settings.soap_path) do
        content_type 'text/xml'
        call_action_block
      end

      app.get(app.settings.wsdl_path) do 
        get_wsdl
      end
    end

  end
  Delegator.delegate :soap
  register Soap
end
