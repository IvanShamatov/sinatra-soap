module Sinatra
  module Soap
    class Wsdl

      @@actions = {}

      def self.actions
        @@actions
      end

      def self.register(name, *args, &block)
        @@actions[name] = {}
        args = args.pop || {}
        args.each do |key, value|
          @@actions[name][key] = value || {}
        end
        @@actions[name][:block] = block if block_given?
      end

      def self.generate
      end

      attr_accessor :action, :block, :arguments, :reply_name

      def initialize(action)
        data = all[action]
        raise Soap::Error, "Undefined Soap Action" if data.nil?
        @action = action
        @block = data[:block]
        @reply_name = data[:reply_name]
        @arguments = data.select {|k,v| k != :block}
      end

      def all
        @@actions
      end

    end
  end
end
