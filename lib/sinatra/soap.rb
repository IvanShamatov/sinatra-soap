require "sinatra/base"
require "sinatra/soap/version"
require "sinatra/soap/helpers"
require "nori"


module Sinatra
  module Soap
    include Helpers
    def self.registered(app)
      app.helpers Helpers
      app.set :soap_path, '/action' unless defined?(app.settings.soap_path)
      app.set :wsdl_path, '/wsdl' unless defined?(app.settings.wsdl_path)

      app.post(app.settings.soap_path) do
        action, pars = parse_soap
        puts "action #{action}: with params #{pars}"
        #WSDL['wsdl'][action]["block"].call(pars)
      end

      app.get(app.settings.wsdl_path) do 
        generate_wsdl
      end
    end
  end
  register Soap
  # Delegator.delegate :soap
end
