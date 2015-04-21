module Sinatra
  module Soap
    class Wsdl

      @@actions = {}

      def self.actions
        @@actions
      end

      def self.register(name, *args, &block)
        args = args.pop || {}
        namespace = args.fetch(:namespace, '')
        action = namespace + name.to_s

        @@actions[action] = {}
        args.each do |key, value|
          @@actions[action][key] = value || {}
        end
        @@actions[action][:block] = block if block_given?
      end

      def self.generate
      end

      attr_accessor :action, :block, :arguments

      def initialize(action)
        data = all[action]
        raise Soap::Error, "Undefined Soap Action" if data.nil?
        @action = action
        @block = data[:block]
        @arguments = data.select {|k,v| k != :block}
      end

      def all
        @@actions
      end

    end
  end
end
