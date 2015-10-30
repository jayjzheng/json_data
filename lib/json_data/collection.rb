require 'json'

module JSONData
  module Collection
    module ClassMethods
      def data_class(klass, options = {})
        formatter = options.fetch(:formatter) { lambda {|json| json} }

        define_method :create_data_objects do
          @data_source = formatter.call(data_source).map {|data| klass.new(data_source: data) }
        end
      end
    end

    def self.included(base)
      base.send :include, Enumerable
      base.send :extend, ClassMethods
    end

    def initialize(options = {})
      self.data_source = options.fetch(:data_source) { [] }
    end

    def data_source=(json)
      @data_source = json.is_a?(String) ? JSON.parse(json) : json
      create_data_objects
    end

    def each(&block)
      data_source.each { |d| block.call(d) }
    end

    def valid?
      !empty? && all? { |d| d.valid? }
    end

    def empty?
      data_source.empty?
    end

    private

    attr_reader :data_source

    def create_data_objects
    end
  end
end
