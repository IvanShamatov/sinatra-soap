require 'sinatra/base'
require "sinatra/soap/version"


module Sinatra
  module Soap
    def soap_action(name, &block)
    	yield if block_given?
    end
  end
  register Soap
end
