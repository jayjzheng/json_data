require 'ostruct'

module JSONData
  module Data
    module ClassMethods
      def data_attr(orig_name, options = {})
        attr_name = options.fetch(:as) { orig_name }

        define_attr(attr_name, orig_name, options[:data_class])

        add_required_attr(attr_name, options[:required])
      end

      private

      def add_required_attr(attr_name, required)
        return unless required

        instance_eval do
          @required_attrs ||= []
          @required_attrs << attr_name
        end
      end

      def define_attr(method_name, orig_name, klass)
        define_method method_name do
          value = data_source.send(orig_name)
          klass ? klass.new(data_source: value) : value
        end
      end
    end # end ClassMethods

    def self.included(base)
      base.send :extend, ClassMethods
    end

    def initialize(options = {})
      @parser = options.fetch(:parser) { Parser.new }
      self.data_source = options.fetch(:data_source) { JSON.generate({}) }
    end

    def data_source=(json)
      @data_source = OpenStruct.new(parser.parse(json))
    end

    def valid?
      required_attrs.empty? || required_attrs.all? { |f| !send(f).nil? }
    end

    def required_attrs
      self.class.instance_variable_get(:@required_attrs) || []
    end

    private

    attr_reader :data_source, :parser
  end
end
