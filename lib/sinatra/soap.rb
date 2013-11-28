require "sinatra/base"
require "sinatra/soap/version"
require "sinatra/soap/helpers"
require "sinatra/soap/wsdl"
require "sinatra/soap/error"
# require "sinatra/soap/builder"
require "builder"


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
        begin
          response = call_action_block
          builder do |xml|
            xml.instruct!
            xml.tag! 'soap:Envelope', 'xmlns:soap' => 'http://schemas.xmlsoap.org/soap/envelope/',
                    'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance' do
              xml.tag! 'soap:Body' do
                xml.tag! "soap:#{params[:action]}Response" do
                  response.each do |key, value| 
                    xml.tag! key, value
                  end
                end
              end
            end
          end
        rescue Soap::SoapFault => e
          builder do |xml|
            xml.instruct!
            xml.tag! 'soap:Envelope', 'xmlns:soap' => 'http://schemas.xmlsoap.org/soap/envelope/',
                    'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance' do
              xml.tag! 'soap:Body' do
                xml.tag! 'soap:Fault', :encodingStyle => 'http://schemas.xmlsoap.org/soap/encoding/' do
                  xml.faultcode 'Client'
                  xml.faultstring e.message
                end
              end
            end
          end
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
