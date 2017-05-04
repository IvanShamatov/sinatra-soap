require_relative 'param'

module Sinatra
  module Soap
    module HelperMethods

      # Return the location where we can find our views
      def soap_views()
        File.join(File.dirname(__FILE__), "..", "views")
      end

      def hash_to_xml(xml, hash)
        unless hash.is_a?(Hash)
          raise ArgumentError, "content must be a hash"
        end
        hash.each do |key, value|
          if value.is_a?(Hash)
            attrs = {}
            content = {}
            content_str = nil
            value.each do |key, value|
              if key.to_s == "@@content"
                content_str = value
              elsif key.to_s.start_with?("@")
                attrs[key.to_s[1..-1]] = value
              else
                content[key] = value
              end
            end
            if content_str
              xml.tag!(key, attrs, content_str)
            else
              xml.tag!(key, attrs) do
                hash_to_xml(xml, content)
              end
            end
          elsif value.is_a?(Array)
            parent_tag = singularize(key)

            if parent_tag == key.to_s
              value.each do |value|
                hash_to_xml(xml, parent_tag => value)
              end
            else
              xml.tag!(key) do
                value.each do |value|
                  hash_to_xml(xml, parent_tag => value)
                end
              end
            end
          else
            xml.tag! key, value
          end
        end
      end

      # Try to use activesupport's singularize, failback to simplified implementation
      def singularize(word)
        word = word.to_s
        if word.respond_to?(:singularize)
          word.singularize
        else
          if word =~ /(c|s|x)es$/
            word.sub(/(c|s|x)es$/, '\1')
          else
            word.sub(/s$/, '')
          end
        end
      end

      def call_action_block
        request = Soap::Request.new(env, request, params, self)
        if defined?(logger) && logger
          logger.info "SOAP Request: #{request.action}"
        end
        response = request.execute
        builder :response, views: self.soap_views, locals: {
          wsdl: response.wsdl,
          params: response.params,
          soap_headers: response.headers
        }
      rescue Soap::Error => e
        if defined?(logger) && logger
          logger.error "SOAP Error: #{e.message} - Action: #{env['HTTP_SOAPACTION']}"
        end
        builder :error, locals: {e: e}, views: self.soap_views
      end

      def get_wsdl
        if defined?(settings.wsdl_path)
          path = File.join(settings.public_folder, settings.wsdl_path)
          if File.exist?(path)
            File.read(path)
          else
            raise "No wsdl file"
          end
        else
          builder :wsdl, locals: {wsdl: Soap::Wsdl.actions}, views: self.soap_views
        end
      end

      def wsdl_occurence(param, inject, extend_with = {})
        param=Param.new(param[0], param[1])
        extend_with = { :name => param.name, :type => param.namespaced_type }
        data = !param.multiplied ? {} : {
          "#{'xsi:' if inject}minOccurs" => 0,
          "#{'xsi:' if inject}maxOccurs" => 'unbounded'
        }
        extend_with.merge(data)
      end

      def wsdl_type(xml, param, defined=[])
        param = Param.new(param[0], param[1])
        more = []
        if param.struct?
          if !defined.include?(param.basic_type)
            xml.tag! "xsd:complexType", :name => param.basic_type do
              xml.tag! "xsd:sequence" do
                param.map.each do |value|
                  param_value = Param.new(value[0], value[1])
                  more << value if param_value.struct?
                  xml.tag! "xsd:element", wsdl_occurence(value, false)
                end
              end
            end
            defined << param.basic_type
          elsif !param.classified?
            raise RuntimeError, "Duplicate use of `#{param.basic_type}` type name. Consider using classified types."
          end
        end
        more.each do |p|
          wsdl_type xml, p, defined
        end
      end
    end
  end
end
