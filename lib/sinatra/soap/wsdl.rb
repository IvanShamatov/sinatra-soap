require 'singleton'

module Sinatra
  module Soap
    class Wsdl
      include Singleton

      attr_accessor :actions, :namespace

      def initialize
        @actions = {}
      end

      def generate
        raise "Not implemented"
      end

      def [](key)
        actions[key]
      end

      def register_action(name, *args, &block)
        actions[name] = {}
        args = args.pop
        unless args.nil?
          args.each do |key, value|
            actions[name][key] = value
          end
        end
        actions[name][:block] = block if block_given?
      end
    end
  end
end