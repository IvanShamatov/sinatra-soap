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

      app.set :wsdl_route, '/wsdl' unless defined?(app.settings.wsdl_path)
      app.set :namespace, 'Any' unless defined?(app.settings.namespace)
      app.set :endpoint, '/action' unless defined?(app.settings.endpoint)
      app.set :service, 'Sinatra' unless defined?(app.settings.service)

      app.post(app.settings.endpoint) do
        content_type 'text/xml'
        call_action_block
      end

      app.get(app.settings.wsdl_route) do 
        get_wsdl
      end
    end

  end
  Delegator.delegate :soap
  register Soap
end
