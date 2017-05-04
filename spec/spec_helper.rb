ENV['RACK_ENV'] = 'test'

require_relative '../lib/sinatra/soap'
require 'rspec'
require 'rack/test'

class SoapApp < Sinatra::Base
  register Sinatra::Soap
  soap :test do
    params
  end

  soap :add_circle, in: {circle: {center: {x: :integer, y: :integer}, 
                                  radius: :double}},
                    out: nil do
    params #=> {circle: {center: {x: 3, y: 2}, radius: 12.0} }
    nil
  end

  soap :test_render, reply_name: 'TestRenderReply' do
    {
      top: {
        child: {
          value: "content",
          "@attr1": "attr_value"
        }
      }
    }
  end

  soap :test_render2 do
    {
      result: {
        "@status": "success",
        foo: {
          "@active": true,
          "@@content": "bar"
        }
      }
    }
  end
end

module RSpecMixin
  include Rack::Test::Methods
end

RSpec.configure { |c| c.include RSpecMixin }
