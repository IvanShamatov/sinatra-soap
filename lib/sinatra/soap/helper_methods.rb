require_relative 'param'

module Sinatra
  module Soap
    module HelperMethods

      # Return the location where we can find our views
      def soap_views()
        File.join(File.dirname(__FILE__), "..", "views")
      end

      def call_action_block
        request = Soap::Request.new(env, request, params)
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
        builder :error, locals: {e: e}, views: self.soap_views
      end

      def get_wsdl
        if defined?(logger) && logger
          logger.info "SOAP: wsdl request"
        end
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
